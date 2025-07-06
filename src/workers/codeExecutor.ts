import { Kafka } from "kafkajs";
import { exec } from "child_process";
import fs from "fs";
import path from "path";
import pool from "../config/db";
import dotenv from "dotenv";

dotenv.config();

const kafka = new Kafka({
  clientId: "code-executor-worker",
  brokers: [process.env.KAFKA_BROKER || "localhost:9092"],
});

const consumer = kafka.consumer({ groupId: "code-execution-group" });

interface CodeSubmission {
  submissionId: number;
  language: string;
  code: string;
  stdin?: string;
  problemId?: string; // For test case validation
  userId?: number;
}

interface TestCase {
  id: number;
  input: string;
  expected_output: string;
  is_sample: boolean;
}

interface TestResult {
  testCaseId: number;
  input: string;
  expected_output: string;
  actual_output: string;
  passed: boolean;
  execution_time: number;
  error?: string;
}

interface LanguageConfig {
  extension: string;
  compileCommand?: string;
  executeCommand: string;
}

const languageConfigsTest: Record<string, LanguageConfig> = {
  python: {
    extension: "py",
    executeCommand: "python3 {file}",
  },
  javascript: {
    extension: "js",
    executeCommand: "node {file}",
  },
  java: {
    extension: "java",
    compileCommand: "javac {file}",
    executeCommand: "java {className}",
  },
  cpp: {
    extension: "cpp",
    compileCommand: "g++ -o {output} {file}",
    executeCommand: "{output}",
  }
};

const executeCode = async (submission: CodeSubmission): Promise<void> => {
  const { submissionId, language, code, stdin, problemId, userId } = submission;

  try {
    await pool.query(
      "UPDATE submissions SET status = $1, updated_at = CURRENT_TIMESTAMP WHERE submission_id = $2",
      ["running", submissionId]
    );

    const config = languageConfigsTest[language.toLowerCase()];
    if (!config) {
      throw new Error(`Unsupported language: ${language}`);
    }

    const tempDir = path.join("/tmp", `code_${submissionId}`);
    if (!fs.existsSync(tempDir)) {
      fs.mkdirSync(tempDir, { recursive: true });
    }

    // Handle Java class name extraction
    let fileName = `code_${submissionId}.${config.extension}`;
    let className = `code_${submissionId}`;
    
    if (language.toLowerCase() === "java") {
      const publicClassMatch = code.match(/public\s+class\s+(\w+)/);
      const classMatch = code.match(/class\s+(\w+)/);
      
      if (publicClassMatch) {
        className = publicClassMatch[1];
        fileName = `${className}.java`;
      } else if (classMatch) {
        className = classMatch[1];
        fileName = `${className}.java`;
      }
    }

    const filePath = path.join(tempDir, fileName);
    fs.writeFileSync(filePath, code);

    const startTime = Date.now();
    let outputFile = "";

    // Compilation phase
    if (config.compileCommand) {
      if (language.toLowerCase() === "java") {
        const compileCmd = config.compileCommand.replace("{file}", filePath);
        
        console.log(`Compiling with command: ${compileCmd}`);
        const compileResult = await executeCommand(compileCmd, tempDir, 10000);

        if (compileResult.stderr && compileResult.stderr.toLowerCase().includes("error")) {
          throw new Error(`Compilation failed: ${compileResult.stderr}`);
        }

        const classFile = path.join(tempDir, `${className}.class`);
        if (!fs.existsSync(classFile)) {
          throw new Error(`Compilation failed: ${className}.class file not created. Stderr: ${compileResult.stderr}`);
        }
      } else {
        outputFile = path.join(tempDir, `output_${submissionId}`);
        const compileCmd = config.compileCommand
          .replace("{file}", filePath)
          .replace("{output}", outputFile);

        console.log(`Compiling with command: ${compileCmd}`);
        const compileResult = await executeCommand(compileCmd, tempDir, 10000);

        if (compileResult.stderr && compileResult.stderr.includes("error:")) {
          throw new Error(`Compilation failed: ${compileResult.stderr}`);
        }

        if (!fs.existsSync(outputFile)) {
          throw new Error(`Compilation failed: executable not created. Stderr: ${compileResult.stderr}`);
        }

        fs.chmodSync(outputFile, "755");
      }
    }

    // If problemId is provided, run test cases; otherwise run with stdin
    if (problemId) {
      await runTestCases(submissionId, problemId, tempDir, fileName, className, config, language, startTime);
    } else {
      await runSingleExecution(submissionId, stdin, tempDir, fileName, className, config, language, startTime);
    }

    fs.rmSync(tempDir, { recursive: true, force: true });
  } catch (error) {
    console.error(`Error executing code for submission ${submissionId}:`, error);

    await pool.query(
      `UPDATE submissions 
       SET stderr = $1, status = $2, updated_at = CURRENT_TIMESTAMP 
       WHERE submission_id = $3`,
      [
        error instanceof Error ? error.message : "Unknown error",
        "error",
        submissionId,
      ]
    );

    const tempDir = path.join("/tmp", `code_${submissionId}`);
    if (fs.existsSync(tempDir)) {
      fs.rmSync(tempDir, { recursive: true, force: true });
    }
  }
};

const runTestCases = async (
  submissionId: number,
  problemId: string,
  tempDir: string,
  fileName: string,
  className: string,
  config: LanguageConfig,
  language: string,
  startTime: number
): Promise<void> => {
  // Get test cases from database
  const testCasesResult = await pool.query(
    'SELECT id, input, expected_output, is_sample FROM coding_problem_testcases WHERE problem_id = $1 ORDER BY id',
    [problemId]
  );

  const testCases: TestCase[] = testCasesResult.rows;
  const testResults: TestResult[] = [];
  let allTestsPassed = true;

  console.log(`Running ${testCases.length} test cases for problem ${problemId}`);

  for (const testCase of testCases) {
    const testStartTime = Date.now();
    
    try {
      // Create input file for this test case
      const inputFile = path.join(tempDir, `test_${testCase.id}_input.txt`);
      fs.writeFileSync(inputFile, testCase.input);

      // Prepare execution command
      let executeCmd = config.executeCommand;
      
      if (language.toLowerCase() === "java") {
        executeCmd = executeCmd.replace("{className}", className);
      } else if (config.compileCommand) {
        executeCmd = executeCmd.replace("{output}", path.join(tempDir, `output_${submissionId}`));
      } else {
        executeCmd = executeCmd.replace("{file}", path.join(tempDir, fileName));
      }

      const fullCommand = `${executeCmd} < ${inputFile}`;
      const result = await executeCommand(fullCommand, tempDir, 5000);
      
      const testExecutionTime = Date.now() - testStartTime;
      const actualOutput = result.stdout.trim();
      const expectedOutput = testCase.expected_output.trim();
      const passed = compareOutputs(actualOutput, expectedOutput);

      if (!passed) {
        allTestsPassed = false;
      }

      testResults.push({
        testCaseId: testCase.id,
        input: testCase.input,
        expected_output: expectedOutput,
        actual_output: actualOutput,
        passed,
        execution_time: testExecutionTime,
        error: result.stderr || undefined
      });

      console.log(`Test case ${testCase.id}: ${passed ? 'PASSED' : 'FAILED'}`);

    } catch (error) {
      allTestsPassed = false;
      testResults.push({
        testCaseId: testCase.id,
        input: testCase.input,
        expected_output: testCase.expected_output,
        actual_output: "",
        passed: false,
        execution_time: Date.now() - testStartTime,
        error: error instanceof Error ? error.message : "Unknown error"
      });

      console.log(`Test case ${testCase.id}: ERROR - ${error}`);
    }
  }

  const totalExecutionTime = Date.now() - startTime;
  const passedTests = testResults.filter(r => r.passed).length;
  const status = allTestsPassed ? "success" : (passedTests > 0 ? "partial" : "error");

  await pool.query(
    `UPDATE submissions 
     SET stdout = $1, stderr = $2, status = $3, execution_time = $4, 
         test_results = $5, tests_passed = $6, total_tests = $7, updated_at = CURRENT_TIMESTAMP 
     WHERE submission_id = $8`,
    [
      JSON.stringify(testResults.map(r => r.actual_output)),
      JSON.stringify(testResults.filter(r => r.error).map(r => r.error)),
      status,
      totalExecutionTime,
      JSON.stringify(testResults),
      passedTests,
      testResults.length,
      submissionId
    ]
  );

  console.log(`Submission ${submissionId} completed: ${passedTests}/${testResults.length} tests passed`);
};

const runSingleExecution = async (
  submissionId: number,
  stdin: string | undefined,
  tempDir: string,
  fileName: string,
  className: string,
  config: LanguageConfig,
  language: string,
  startTime: number
): Promise<void> => {
  let stdinFile = "";
  if (stdin) {
    stdinFile = path.join(tempDir, `input_${submissionId}.txt`);
    fs.writeFileSync(stdinFile, stdin);
  }

  let executeCmd = config.executeCommand;

  if (language.toLowerCase() === "java") {
    executeCmd = executeCmd.replace("{className}", className);
  } else if (config.compileCommand) {
    executeCmd = executeCmd.replace("{output}", path.join(tempDir, `output_${submissionId}`));
  } else {
    executeCmd = executeCmd.replace("{file}", path.join(tempDir, fileName));
  }

  console.log(`Executing with command: ${executeCmd}`);

  const fullCommand = stdin ? `${executeCmd} < ${stdinFile}` : executeCmd;
  const result = await executeCommand(fullCommand, tempDir, 5000);
  const executionTime = Date.now() - startTime;

  await pool.query(
    `UPDATE submissions 
     SET stdout = $1, stderr = $2, status = $3, execution_time = $4, updated_at = CURRENT_TIMESTAMP 
     WHERE submission_id = $5`,
    [result.stdout, result.stderr, "success", executionTime, submissionId]
  );

  console.log(`Submission ${submissionId} completed successfully`);
};

const compareOutputs = (actual: string, expected: string): boolean => {
  // Normalize whitespace
  const normalizeOutput = (output: string) => {
    return output.trim().replace(/\s+/g, ' ');
  };

  const normalizedActual = normalizeOutput(actual);
  const normalizedExpected = normalizeOutput(expected);

  // Direct comparison
  if (normalizedActual === normalizedExpected) {
    return true;
  }

  // Try JSON comparison for arrays/objects
  try {
    const actualParsed = JSON.parse(actual);
    const expectedParsed = JSON.parse(expected);
    
    if (Array.isArray(actualParsed) && Array.isArray(expectedParsed)) {
      return JSON.stringify(actualParsed.sort()) === JSON.stringify(expectedParsed.sort());
    }
    
    return JSON.stringify(actualParsed) === JSON.stringify(expectedParsed);
  } catch (e) {
    // Not JSON, continue with string comparison
  }

  return false;
};

const executeCommand = (
  command: string,
  cwd: string,
  timeout: number
): Promise<{ stdout: string; stderr: string }> => {
  return new Promise((resolve, reject) => {
    console.log(`Executing: ${command} in ${cwd}`);

    exec(
      command,
      {
        cwd,
        timeout,
        maxBuffer: 1024 * 1024,
        env: { ...process.env, PATH: "/usr/bin:/bin:/usr/local/bin" },
      },
      (error, stdout, stderr) => {
        if (error) {
          if (error.signal === "SIGTERM" || error.killed) {
            reject(new Error("Time limit exceeded"));
          } else {
            console.log(`Command failed: ${error.message}`);
            resolve({ stdout, stderr: stderr || error.message });
          }
        } else {
          resolve({ stdout, stderr });
        }
      }
    );
  });
};

const processTestCaseInput = (input: string, problemId: string): string => {
  switch (problemId) {
    case 'two-sum':
      const numsMatch = input.match(/nums\s*=\s*(\[[\d,\s]+\])/);
      const targetMatch = input.match(/target\s*=\s*(\d+)/);
      
      if (numsMatch && targetMatch) {
        const nums = numsMatch[1];
        const target = targetMatch[1];
        
        return `${nums}\n${target}`;
      }
      break;
    
    case 'valid-parentheses':
      const sMatch = input.match(/s\s*=\s*"([^"]*)"/);
      if (sMatch) {
        return sMatch[1];
      }
      break;
    
    default:
      return input;
  }
  
  return input;
};

export const startCodeExecutor = async () => {
  try {
    await consumer.connect();
    await consumer.subscribe({ topic: "code_submissions" });

    await consumer.run({
      eachMessage: async ({ message }) => {
        if (message.value) {
          try {
            const submission: CodeSubmission = JSON.parse(
              message.value.toString()
            );
            console.log(`Processing submission ${submission.submissionId}`);
            await executeCode(submission);
          } catch (error) {
            console.error("Error processing message:", error);
          }
        }
      },
    });

    console.log("Code executor worker started");
  } catch (error) {
    console.error("Failed to start code executor:", error);
  }
};

process.on("SIGINT", async () => {
  await consumer.disconnect();
  process.exit(0);
});
