import { Request, Response } from "express";
import pool from "../config/db";
import fs from "fs";
import path from "path";

interface ProblemData {
  title: string;
  slug: string;
  description: string;
  topic: string;
  difficulty: "easy" | "medium" | "hard";
  constraints: string[];
  examples: Array<{
    input: string;
    output: string;
  }>;
  hints: string[];
  time_complexity: string;
  space_complexity: string;
}

export class SeedProblemsController {
  private getXPForDifficulty(difficulty: string): number {
    switch (difficulty) {
      case "easy":
        return 10;
      case "medium":
        return 25;
      case "hard":
        return 50;
      default:
        return 10;
    }
  }

  private async getOrCreateTopic(topicName: string): Promise<number> {
    const client = await pool.connect();
    try {
      const topicResult = await client.query(
        "SELECT id FROM problem_topics WHERE name = $1",
        [topicName]
      );

      if (topicResult.rows.length > 0) {
        return topicResult.rows[0].id;
      }

      // Create new topic
      const insertResult = await client.query(
        "INSERT INTO problem_topics (name) VALUES ($1) RETURNING id",
        [topicName]
      );

      return insertResult.rows[0].id;
    } finally {
      client.release();
    }
  }

  public async seedProblems(req: Request, res: Response): Promise<void> {
    const client = await pool.connect();

    try {
      const { filePath } = req.body;

      if (!filePath) {
        res.status(400).json({ error: "File path is required" });
        return;
      }

      // Read JSON file
      const fullPath = path.resolve(filePath);

      if (!fs.existsSync(fullPath)) {
        res.status(404).json({ error: "File not found" });
        return;
      }

      const jsonData = JSON.parse(fs.readFileSync(fullPath, "utf8"));

      if (!Array.isArray(jsonData)) {
        res
          .status(400)
          .json({ error: "JSON file must contain an array of problems" });
        return;
      }

      await client.query("BEGIN");

      const seededProblems = [];

      for (const problemData of jsonData as ProblemData[]) {
        try {
          if (
            !problemData.title ||
            !problemData.slug ||
            !problemData.description ||
            !problemData.difficulty ||
            !problemData.topic
          ) {
            console.warn(
              `Skipping problem with missing required fields: ${
                problemData.title || "Unknown"
              }`
            );
            continue;
          }

          const topicId = await this.getOrCreateTopic(problemData.topic);

          const xp = this.getXPForDifficulty(problemData.difficulty);

          const constraintsText = Array.isArray(problemData.constraints)
            ? problemData.constraints.join("\n")
            : problemData.constraints || "";

          const problemResult = await client.query(
            `
                        INSERT INTO coding_problems 
                        (id, title, description, constraints, difficulty, time_complexity, space_complexity, hints, xp)
                        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
                        ON CONFLICT (id) DO UPDATE SET
                            title = EXCLUDED.title,
                            description = EXCLUDED.description,
                            constraints = EXCLUDED.constraints,
                            difficulty = EXCLUDED.difficulty,
                            time_complexity = EXCLUDED.time_complexity,
                            space_complexity = EXCLUDED.space_complexity,
                            hints = EXCLUDED.hints,
                            xp = EXCLUDED.xp
                        RETURNING id
                    `,
            [
              problemData.slug,
              problemData.title,
              problemData.description,
              constraintsText,
              problemData.difficulty,
              problemData.time_complexity || "O(1)",
              problemData.space_complexity || "O(1)",
              problemData.hints || [],
              xp,
            ]
          );

          const problemId = problemResult.rows[0].id;

          await client.query(
            `
                        INSERT INTO coding_problem_topics (problem_id, topic_id)
                        VALUES ($1, $2)
                        ON CONFLICT (problem_id, topic_id) DO NOTHING
                    `,
            [problemId, topicId]
          );

          if (problemData.examples && Array.isArray(problemData.examples)) {
            for (const example of problemData.examples) {
              await client.query(
                `
                                INSERT INTO coding_problem_testcases (problem_id, input, expected_output, is_sample)
                                VALUES ($1, $2, $3, $4)
                            `,
                [problemId, example.input, example.output, true]
              );
            }
          }

          seededProblems.push({
            id: problemId,
            title: problemData.title,
            difficulty: problemData.difficulty,
            topic: problemData.topic,
          });
        } catch (error) {
          console.error(`Error seeding problem ${problemData.title}:`, error);
        }
      }

      await client.query("COMMIT");

      res.json({
        success: true,
        message: `Successfully seeded ${seededProblems.length} problems`,
        seededProblems,
      });
    } catch (error) {
      await client.query("ROLLBACK");
      console.error("Error seeding problems:", error);
      res.status(500).json({
        error: "Failed to seed problems",
        details: error instanceof Error ? error.message : "Unknown error",
      });
    } finally {
      client.release();
    }
  }

  public async getProblemStatus(req: Request, res: Response): Promise<void> {
    try {
      const result = await pool.query(`
                SELECT 
                    cp.id,
                    cp.title,
                    cp.difficulty,
                    pt.name as topic,
                    COUNT(cpt.problem_id) as test_case_count
                FROM coding_problems cp
                LEFT JOIN coding_problem_topics cpt_link ON cp.id = cpt_link.problem_id
                LEFT JOIN problem_topics pt ON cpt_link.topic_id = pt.id
                LEFT JOIN coding_problem_testcases cpt ON cp.id = cpt.problem_id
                GROUP BY cp.id, cp.title, cp.difficulty, pt.name
                ORDER BY cp.created_at DESC
            `);

      res.json({
        totalProblems: result.rows.length,
        problems: result.rows,
      });
    } catch (error) {
      console.error("Error fetching seeded problems:", error);
      res.status(500).json({ error: "Failed to fetch problems status" });
    }
  }

  public async getAllProblems(req: Request, res: Response): Promise<void> {
    try {
      const {
        difficulty,
        topic,
        limit = 50,
        offset = 0,
        sortBy = "created_at",
        sortOrder = "DESC",
      } = req.query;

      let query = `
                SELECT 
                    cp.id,
                    cp.title,
                    cp.description,
                    cp.constraints,
                    cp.difficulty,
                    cp.time_complexity,
                    cp.space_complexity,
                    cp.hints,
                    cp.xp,
                    cp.created_at,
                    pt.name as topic,
                    pt.id as topic_id,
                    COUNT(cpt.id) as test_case_count,
                    COUNT(CASE WHEN cpt.is_sample = true THEN 1 END) as sample_test_case_count
                FROM coding_problems cp
                LEFT JOIN coding_problem_topics cpt_link ON cp.id = cpt_link.problem_id
                LEFT JOIN problem_topics pt ON cpt_link.topic_id = pt.id
                LEFT JOIN coding_problem_testcases cpt ON cp.id = cpt.problem_id
            `;

      const conditions = [];
      const params = [];
      let paramIndex = 1;

      // Add filters
      if (difficulty) {
        conditions.push(`cp.difficulty = $${paramIndex++}`);
        params.push(difficulty);
      }

      if (topic) {
        conditions.push(`pt.name ILIKE $${paramIndex++}`);
        params.push(`%${topic}%`);
      }

      if (conditions.length > 0) {
        query += " WHERE " + conditions.join(" AND ");
      }

      query += `
                GROUP BY cp.id, cp.title, cp.description, cp.constraints, cp.difficulty, 
                         cp.time_complexity, cp.space_complexity, cp.hints, cp.xp, 
                         cp.created_at, pt.name, pt.id
                ORDER BY ${sortBy} ${sortOrder}
                LIMIT $${paramIndex++} OFFSET $${paramIndex++}
            `;

      params.push(parseInt(limit as string), parseInt(offset as string));

      const result = await pool.query(query, params);

      // Get total count for pagination
      let countQuery = `
                SELECT COUNT(DISTINCT cp.id) as total
                FROM coding_problems cp
                LEFT JOIN coding_problem_topics cpt_link ON cp.id = cpt_link.problem_id
                LEFT JOIN problem_topics pt ON cpt_link.topic_id = pt.id
            `;

      const countConditions = [];
      const countParams = [];
      let countParamIndex = 1;

      if (difficulty) {
        countConditions.push(`cp.difficulty = $${countParamIndex++}`);
        countParams.push(difficulty);
      }

      if (topic) {
        countConditions.push(`pt.name ILIKE $${countParamIndex++}`);
        countParams.push(`%${topic}%`);
      }

      if (countConditions.length > 0) {
        countQuery += " WHERE " + countConditions.join(" AND ");
      }

      const countResult = await pool.query(countQuery, countParams);
      const totalCount = parseInt(countResult.rows[0].total);

      res.json({
        success: true,
        data: {
          problems: result.rows,
          pagination: {
            total: totalCount,
            limit: parseInt(limit as string),
            offset: parseInt(offset as string),
            hasMore:
              parseInt(offset as string) + parseInt(limit as string) <
              totalCount,
          },
        },
      });
    } catch (error) {
      console.error("Error fetching all problems:", error);
      res.status(500).json({
        error: "Failed to fetch problems",
        details: error instanceof Error ? error.message : "Unknown error",
      });
    }
  }

  public async getProblemById(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;

      if (!id) {
        res.status(400).json({ error: "Problem ID is required" });
        return;
      }

      // Get problem details
      const problemResult = await pool.query(
        `
                SELECT 
                    cp.id,
                    cp.title,
                    cp.description,
                    cp.constraints,
                    cp.difficulty,
                    cp.time_complexity,
                    cp.space_complexity,
                    cp.hints,
                    cp.xp,
                    cp.created_at,
                    pt.name as topic,
                    pt.id as topic_id
                FROM coding_problems cp
                LEFT JOIN coding_problem_topics cpt_link ON cp.id = cpt_link.problem_id
                LEFT JOIN problem_topics pt ON cpt_link.topic_id = pt.id
                WHERE cp.id = $1
            `,
        [id]
      );

      if (problemResult.rows.length === 0) {
        res.status(404).json({ error: "Problem not found" });
        return;
      }

      // Get test cases
      const testCasesResult = await pool.query(
        `
                SELECT 
                    id,
                    input,
                    expected_output,
                    is_sample
                FROM coding_problem_testcases
                WHERE problem_id = $1
                ORDER BY is_sample DESC, id ASC
            `,
        [id]
      );

      const problem = problemResult.rows[0];
      const testCases = testCasesResult.rows;

      res.json({
        success: true,
        data: {
          ...problem,
          testCases: testCases,
          sampleTestCases: testCases.filter((tc) => tc.is_sample),
          totalTestCases: testCases.length,
        },
      });
    } catch (error) {
      console.error("Error fetching problem by ID:", error);
      res.status(500).json({
        error: "Failed to fetch problem",
        details: error instanceof Error ? error.message : "Unknown error",
      });
    }
  }

  public async getProblemsByTopic(req: Request, res: Response): Promise<void> {
    try {
      const { topicId } = req.params;
      const { limit = 20, offset = 0 } = req.query;

      if (!topicId) {
        res.status(400).json({ error: "Topic ID is required" });
        return;
      }

      const result = await pool.query(
        `
                SELECT 
                    cp.id,
                    cp.title,
                    cp.difficulty,
                    cp.xp,
                    cp.created_at,
                    pt.name as topic,
                    COUNT(cpt.id) as test_case_count
                FROM coding_problems cp
                INNER JOIN coding_problem_topics cpt_link ON cp.id = cpt_link.problem_id
                INNER JOIN problem_topics pt ON cpt_link.topic_id = pt.id
                LEFT JOIN coding_problem_testcases cpt ON cp.id = cpt.problem_id
                WHERE pt.id = $1
                GROUP BY cp.id, cp.title, cp.difficulty, cp.xp, cp.created_at, pt.name
                ORDER BY cp.created_at DESC
                LIMIT $2 OFFSET $3
            `,
        [topicId, parseInt(limit as string), parseInt(offset as string)]
      );

      res.json({
        success: true,
        data: {
          problems: result.rows,
          topicId: parseInt(topicId),
          pagination: {
            limit: parseInt(limit as string),
            offset: parseInt(offset as string),
          },
        },
      });
    } catch (error) {
      console.error("Error fetching problems by topic:", error);
      res.status(500).json({
        error: "Failed to fetch problems by topic",
        details: error instanceof Error ? error.message : "Unknown error",
      });
    }
  }

  public async getTopics(req: Request, res: Response): Promise<void> {
    try {
      const result = await pool.query(`
                SELECT 
                    pt.id,
                    pt.name,
                    COUNT(cpt_link.problem_id) as problem_count,
                    COUNT(CASE WHEN cp.difficulty = 'easy' THEN 1 END) as easy_count,
                    COUNT(CASE WHEN cp.difficulty = 'medium' THEN 1 END) as medium_count,
                    COUNT(CASE WHEN cp.difficulty = 'hard' THEN 1 END) as hard_count
                FROM problem_topics pt
                LEFT JOIN coding_problem_topics cpt_link ON pt.id = cpt_link.topic_id
                LEFT JOIN coding_problems cp ON cpt_link.problem_id = cp.id
                GROUP BY pt.id, pt.name
                ORDER BY problem_count DESC, pt.name ASC
            `);

      res.json({
        success: true,
        data: {
          topics: result.rows,
        },
      });
    } catch (error) {
      console.error("Error fetching topics:", error);
      res.status(500).json({
        error: "Failed to fetch topics",
        details: error instanceof Error ? error.message : "Unknown error",
      });
    }
  }
}
