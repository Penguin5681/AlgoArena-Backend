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
  const { submissionId, language, code, stdin } = submission;

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
      // Extract class name from Java code
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

    let stdinFile = "";
    if (stdin) {
      stdinFile = path.join(tempDir, `input_${submissionId}.txt`);
      fs.writeFileSync(stdinFile, stdin);
    }

    const startTime = Date.now();
    let outputFile = "";

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

    let executeCmd = config.executeCommand;

    if (language.toLowerCase() === "java") {
      executeCmd = executeCmd.replace("{className}", className);
    } else if (config.compileCommand) {
      executeCmd = executeCmd.replace("{output}", outputFile);
    } else {
      executeCmd = executeCmd.replace("{file}", filePath);
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

    fs.rmSync(tempDir, { recursive: true, force: true });
  } catch (error) {
    console.error(
      `Error executing code for submission ${submissionId}:`,
      error
    );

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
