// src/controllers/learn.controller.ts

import { Request, Response } from "express";
import pool from "../config/db";

export const getTopicSummary = async (req: Request, res: Response) => {
  try {
    const userId = req.body.user_id;

    const topicsQuery = await pool.query(
      `SELECT t.id, t.title, t.section, t.xp, COALESCE(utp.status, 'not_started') AS status
       FROM topics t
       LEFT JOIN user_topic_progress utp ON t.id = utp.topic_id AND utp.user_id = $1
       ORDER BY t.id`,
      [userId]
    );

    res.json(topicsQuery.rows);
  } catch (err) {
    console.error("Error fetching topic summary:", err);
    res.status(500).json({ error: "Server error" });
  }
};

// ✅ GET /api/learn/topic/:id
export const getTopicDetails = async (req: Request, res: Response) => {
  try {
    const topicId = parseInt(req.params.id);

    const topicRes = await pool.query("SELECT * FROM topics WHERE id = $1", [
      topicId,
    ]);
    const codeRes = await pool.query(
      "SELECT language, code FROM topic_code_examples WHERE topic_id = $1",
      [topicId]
    );

    if (topicRes.rowCount === 0)
      return res.status(404).json({ error: "Topic not found" });

    const topic = topicRes.rows[0];
    topic.code_examples = codeRes.rows;

    res.json(topic);
  } catch (err) {
    console.error("Error fetching topic:", err);
    res.status(500).json({ error: "Server error" });
  }
};

// ✅ GET /api/learn/topic/:id/questions
export const getTopicQuestions = async (req: Request, res: Response) => {
  const topicId = parseInt(req.params.id);
  const userId = parseInt(req.query.user_id as string); 

  try {
    const { rows } = await pool.query(
      `
      SELECT q.*, uqp.is_passed, uqp.duration_sec
      FROM questions q
      LEFT JOIN user_question_progress uqp 
        ON q.id = uqp.question_id AND uqp.user_id = $2
      WHERE q.topic_id = $1
      `,
      [topicId, userId]
    );

    res.json(rows);
  } catch (err) {
    console.error("Error fetching topic questions:", err);
    res.status(500).json({ error: "Server error" });
  }
};

// ✅ GET /api/learn/topic/:id/mcqs
export const getTopicMcqs = async (req: Request, res: Response) => {
  try {
    const topicId = parseInt(req.params.id);
    const mcqRes = await pool.query("SELECT * FROM mcqs WHERE topic_id = $1", [
      topicId,
    ]);
    res.json(mcqRes.rows);
  } catch (err) {
    console.error("Error fetching mcqs:", err);
    res.status(500).json({ error: "Server error" });
  }
};

// ✅ GET /api/learn/xp
export const getUserXP = async (req: Request, res: Response) => {
  try {
    const userId = req.body.user_id;
    const xpRes = await pool.query(
      "SELECT total_xp FROM user_total_xp WHERE user_id = $1",
      [userId]
    );
    res.json({ total_xp: xpRes.rows[0]?.total_xp || 0 });
  } catch (err) {
    console.error("Error fetching user XP:", err);
    res.status(500).json({ error: "Server error" });
  }
};

// ✅ POST /api/learn/progress/topic
export const updateTopicProgress = async (req: Request, res: Response) => {
  try {
    const { user_id, topic_id, status } = req.body;

    await pool.query(
      `INSERT INTO user_topic_progress (user_id, topic_id, status, completed_at)
       VALUES ($1, $2, $3, CURRENT_TIMESTAMP)
       ON CONFLICT (user_id, topic_id)
       DO UPDATE SET status = EXCLUDED.status, completed_at = CURRENT_TIMESTAMP`,
      [user_id, topic_id, status]
    );

    if (status === "completed") {
      const result = await pool.query(`SELECT xp FROM topics WHERE id = $1`, [
        topic_id,
      ]);
      const xp = result.rows[0]?.xp ?? 0;

      await pool.query(
        `INSERT INTO user_xp_log (user_id, source_type, source_key, xp_earned)
   VALUES ($1, 'question', $2, $3)
   ON CONFLICT (user_id, source_type, source_key) DO NOTHING`,
        [user_id, topic_id, xp]
      );
    }

    res.json({ message: "Topic progress updated." });
  } catch (err) {
    console.error("Error updating topic progress:", err);
    res.status(500).json({ error: "Server error" });
  }
};

export const updateQuestionProgress = async (req: Request, res: Response) => {
  try {
    const { user_id, question_id, is_passed, duration_sec, status } = req.body;

    // Update user progress
    await pool.query(
      `INSERT INTO user_question_progress (user_id, question_id, is_passed, duration_sec, status, updated_at)
       VALUES ($1, $2, $3, $4, $5, CURRENT_TIMESTAMP)
       ON CONFLICT (user_id, question_id)
       DO UPDATE SET is_passed = EXCLUDED.is_passed, duration_sec = EXCLUDED.duration_sec, status = EXCLUDED.status, updated_at = CURRENT_TIMESTAMP`,
      [user_id, question_id, is_passed, duration_sec, status]
    );

    if (is_passed) {
      const result = await pool.query(
        `SELECT xp FROM questions WHERE id = $1`,
        [question_id]
      );
      const xp = result.rows[0]?.xp ?? 0;

      await pool.query(
        `INSERT INTO user_xp_log (user_id, source_type, source_key, xp_earned)
   VALUES ($1, 'question', $2, $3)
   ON CONFLICT (user_id, source_type, source_key) DO NOTHING`,
        [user_id, question_id, xp]
      );
    }

    res.json({ message: "Question progress updated." });
  } catch (err) {
    console.error("Error updating question progress:", err);
    res.status(500).json({ error: "Server error" });
  }
};

// GET /api/learn/progress/topics?user_id=123
export const getUserTopicProgress = async (req: Request, res: Response) => {
  const { user_id } = req.query;

  if (!user_id) {
    return res.status(400).json({ error: 'user_id is required' });
  }

  try {
    const result = await pool.query(
      `SELECT topic_id, status, completed_at
       FROM user_topic_progress
       WHERE user_id = $1`,
      [user_id]
    );

    res.json({ progress: result.rows });
  } catch (err) {
    console.error('Error fetching topic progress:', err);
    res.status(500).json({ error: 'Server error' });
  }
};

// GET /api/learn/progress?user_id=123
export const getUserLearningProgress = async (req: Request, res: Response) => {
  const { user_id } = req.query;

  if (!user_id) {
    return res.status(400).json({ error: 'user_id is required' });
  }

  try {
    const [topicResult, questionResult] = await Promise.all([
      pool.query(
        `SELECT topic_id, status, completed_at
         FROM user_topic_progress
         WHERE user_id = $1`,
        [user_id]
      ),
      pool.query(
        `SELECT question_id, is_passed, duration_sec, status, updated_at
         FROM user_question_progress
         WHERE user_id = $1`,
        [user_id]
      )
    ]);

    res.json({
      topic_progress: topicResult.rows,
      question_progress: questionResult.rows,
    });
  } catch (err) {
    console.error('Error fetching learning progress:', err);
    res.status(500).json({ error: 'Server error' });
  }
};
