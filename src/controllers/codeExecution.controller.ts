import { Request, Response } from "express";
import pool from "../config/db";
import { kafka } from "../config/kafka";

export class CodeExecutionController {
  public async submitCodeForProblem(
    req: Request,
    res: Response
  ): Promise<void> {
    try {
      const { problemId } = req.params;
      const { language, code } = req.body;
      const userId = (req as any).user?.id;

      if (!problemId || !language || !code) {
        res.status(400).json({
          success: false,
          error: "Problem ID, language, and code are required",
        });
        return;
      }

      // Verify problem exists
      const problemResult = await pool.query(
        "SELECT id, title FROM coding_problems WHERE id = $1",
        [problemId]
      );

      if (problemResult.rows.length === 0) {
        res.status(404).json({
          success: false,
          error: "Problem not found",
        });
        return;
      }

      // Create submission record
      const submissionResult = await pool.query(
        `INSERT INTO submissions (language, code, status, problem_id, user_id)
         VALUES ($1, $2, 'pending', $3, $4)
         RETURNING submission_id`,
        [language, code, problemId, userId]
      );

      const submissionId = submissionResult.rows[0].submission_id;

      // Send to Kafka for processing
      const producer = kafka.producer();
      await producer.connect();

      await producer.send({
        topic: "code_submissions",
        messages: [
          {
            value: JSON.stringify({
              submissionId,
              language,
              code,
              problemId,
              userId,
            }),
          },
        ],
      });

      await producer.disconnect();

      res.json({
        success: true,
        data: {
          submissionId,
          status: "pending",
          message: "Code submitted for testing",
        },
      });
    } catch (error) {
      console.error("Error submitting code:", error);
      res.status(500).json({
        success: false,
        error: "Failed to submit code",
      });
    }
  }

  // Submit code for compilation only (no test cases)
  public async submitCodeForCompilation(
    req: Request,
    res: Response
  ): Promise<void> {
    try {
      const { language, code, stdin } = req.body;
      const userId = (req as any).user?.id;

      if (!language || !code) {
        res.status(400).json({
          success: false,
          error: "Language and code are required",
        });
        return;
      }

      // Create submission record
      const submissionResult = await pool.query(
        `INSERT INTO submissions (language, code, status, user_id)
         VALUES ($1, $2, 'pending', $3)
         RETURNING submission_id`,
        [language, code, userId]
      );

      const submissionId = submissionResult.rows[0].submission_id;

      // Send to Kafka for processing
      const producer = kafka.producer();
      await producer.connect();

      await producer.send({
        topic: "code_submissions",
        messages: [
          {
            value: JSON.stringify({
              submissionId,
              language,
              code,
              stdin,
            }),
          },
        ],
      });

      await producer.disconnect();

      res.json({
        success: true,
        data: {
          submissionId,
          status: "pending",
          message: "Code submitted for compilation",
        },
      });
    } catch (error) {
      console.error("Error submitting code:", error);
      res.status(500).json({
        success: false,
        error: "Failed to submit code",
      });
    }
  }

  // Get submission result
  public async getSubmissionResult(req: Request, res: Response): Promise<void> {
    try {
      const { submissionId } = req.params;

      const result = await pool.query(
        `SELECT s.*, cp.title as problem_title
         FROM submissions s
         LEFT JOIN coding_problems cp ON s.problem_id = cp.id
         WHERE s.submission_id = $1`,
        [submissionId]
      );

      if (result.rows.length === 0) {
        res.status(404).json({
          success: false,
          error: "Submission not found",
        });
        return;
      }

      const submission = result.rows[0];

      res.json({
        success: true,
        data: {
          submissionId: submission.submission_id,
          language: submission.language,
          status: submission.status,
          stdout: submission.stdout,
          stderr: submission.stderr,
          executionTime: submission.execution_time,
          problemTitle: submission.problem_title,
          testResults: submission.test_results,
          testsPassed: submission.tests_passed,
          totalTests: submission.total_tests,
          createdAt: submission.created_at,
          updatedAt: submission.updated_at,
        },
      });
    } catch (error) {
      console.error("Error fetching submission:", error);
      res.status(500).json({
        success: false,
        error: "Failed to fetch submission",
      });
    }
  }

  // Get all submissions for a user
  public async getUserSubmissions(req: Request, res: Response): Promise<void> {
    try {
      const userId = (req as any).user?.id;
      const { problemId, status, limit = 20, offset = 0 } = req.query;

      let query = `
        SELECT s.*, cp.title as problem_title
        FROM submissions s
        LEFT JOIN coding_problems cp ON s.problem_id = cp.id
        WHERE s.user_id = $1
      `;

      const params = [userId];
      let paramIndex = 2;

      if (problemId) {
        query += ` AND s.problem_id = $${paramIndex++}`;
        params.push(problemId);
      }

      if (status) {
        query += ` AND s.status = $${paramIndex++}`;
        params.push(status);
      }

      query += ` ORDER BY s.created_at DESC LIMIT $${paramIndex++} OFFSET $${paramIndex++}`;
      params.push(parseInt(limit as string), parseInt(offset as string));

      const result = await pool.query(query, params);

      res.json({
        success: true,
        data: {
          submissions: result.rows,
          pagination: {
            limit: parseInt(limit as string),
            offset: parseInt(offset as string),
          },
        },
      });
    } catch (error) {
      console.error("Error fetching user submissions:", error);
      res.status(500).json({
        success: false,
        error: "Failed to fetch submissions",
      });
    }
  }

  public async submitRawCodeForProblem(
    req: Request,
    res: Response
  ): Promise<void> {
    try {
      const { problemId } = req.params;
      const { code, language } = req.body;
      const userId = (req as any).user.id;

      if (!problemId || !code || !language) {
        res.status(400).json({
          success: false,
          error: "Problem ID, code, and language are required",
        });
        return;
      }

      const supportedLanguages = ["cpp", "js", "javascript"];

      if (!supportedLanguages.includes(language.toLowerCase())) {
        res.status(400).json({
          success: false,
          error:
            "Only C++ and Javascript are supported for raw code submission at this time",
        });
        return;
      }

      const submissionResult = await pool.query(
        `INSERT INTO submissions (language, code, status, problem_id, user_id)
         VALUES ($1, $2, 'pending', $3, $4)
         RETURNING submission_id`,
        [language, code, problemId, userId]
      );

      const submissionId = submissionResult.rows[0].submission_id;

      const producer = kafka.producer();
      await producer.connect();

      await producer.send({
        topic: "code_submissions",
        messages: [
          {
            value: JSON.stringify({
              submissionId,
              language,
              code,
              problemId,
              userId,
              isRawSubmission: true, 
            }),
          },
        ],
      });

      await producer.disconnect();

      res.json({
        success: true,
        data: {
          submissionId,
          status: "pending",
          message: "Raw code submitted for testing",
        },
      });
    } catch (error) {
      console.error("Error submitting raw code:", error);
      res.status(500).json({
        success: false,
        error: "Failed to submit raw code",
      });
    }
  }

  public async getProblemTestCases(req: Request, res: Response): Promise<void> {
    try {
      const { problemId } = req.params;

      const result = await pool.query(
        "SELECT id, input, expected_output FROM coding_problem_testcases WHERE problem_id = $1 AND is_sample = true ORDER BY id",
        [problemId]
      );

      res.json({
        success: true,
        data: {
          testCases: result.rows,
        },
      });
    } catch (error) {
      console.error("Error fetching test cases:", error);
      res.status(500).json({
        success: false,
        error: "Failed to fetch test cases",
      });
    }
  }
}
