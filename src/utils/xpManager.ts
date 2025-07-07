import pool from "../config/db";

export const updateUserXPForSolvedProblem = async (
  userId: number,
  problemId: string,
  submissionId: number
): Promise<boolean> => {
  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    const existingRecord = await client.query(
      "SELECT id FROM user_solved_problems WHERE user_id = $1 AND problem_id = $2",
      [userId, problemId]
    );

    if (existingRecord.rows.length > 0) {
      await client.query("ROLLBACK");
      return false;
    }

    const problemResult = await client.query(
      "SELECT xp FROM coding_problems WHERE id = $1",
      [problemId]
    );

    if (problemResult.rows.length === 0) {
      throw new Error(`Problem with ID ${problemId} not found`);
    }

    const xpToAdd = problemResult.rows[0].xp;

    await client.query(
      `INSERT INTO user_solved_problems (user_id, problem_id, submission_id) 
       VALUES ($1, $2, $3)`,
      [userId, problemId, submissionId]
    );

    const userXpResult = await client.query(
      "SELECT user_id FROM user_total_xp WHERE user_id = $1",
      [userId]
    );

    if (userXpResult.rows.length === 0) {
      const userResult = await client.query(
        "SELECT email FROM users WHERE id = $1",
        [userId]
      );

      if (userResult.rows.length === 0) {
        throw new Error(`User with ID ${userId} not found`);
      }

      const userEmail = userResult.rows[0].email;

      await client.query(
        "INSERT INTO user_total_xp (user_id, email, total_xp) VALUES ($1, $2, $3)",
        [userId, userEmail, xpToAdd]
      );
    } else {
      await client.query(
        "UPDATE user_total_xp SET total_xp = total_xp + $1 WHERE user_id = $2",
        [xpToAdd, userId]
      );
    }

    await client.query("COMMIT");
    console.log(
      `Added ${xpToAdd} XP to user ${userId} for solving problem ${problemId}`
    );
    return true;
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Error updating user XP:", error);
    throw error;
  } finally {
    client.release();
  }
};

export const getUserTotalXP = async (userId: number): Promise<number> => {
  try {
    const result = await pool.query(
      "SELECT total_xp FROM user_total_xp WHERE user_id = $1",
      [userId]
    );

    return result.rows.length > 0 ? result.rows[0].total_xp : 0;
  } catch (error) {
    console.error("Error fetching user total XP:", error);
    return 0;
  }
};

export const getUserSolvedProblems = async (userId: number) => {
  try {
    const result = await pool.query(
      `SELECT 
        usp.problem_id,
        usp.solved_at,
        usp.submission_id,
        cp.title,
        cp.difficulty,
        cp.xp
       FROM user_solved_problems usp
       JOIN coding_problems cp ON usp.problem_id = cp.id
       WHERE usp.user_id = $1
       ORDER BY usp.solved_at DESC`,
      [userId]
    );

    return result.rows;
  } catch (error) {
    console.error("Error fetching user solved problems:", error);
    return [];
  }
};

export const checkProblemSolved = async (userId: number, problemId: string): Promise<boolean> => {
  try {
    const result = await pool.query(
      'SELECT id FROM user_solved_problems WHERE user_id = $1 AND problem_id = $2',
      [userId, problemId]
    );
    
    return result.rows.length > 0;
  } catch (error) {
    console.error('Error checking if problem is solved:', error);
    return false;
  }
};

export const getProblemSolvedDetails = async (userId: number, problemId: string) => {
  try {
    const result = await pool.query(
      `SELECT 
        usp.solved_at,
        usp.submission_id,
        cp.title,
        cp.difficulty,
        cp.xp
       FROM user_solved_problems usp
       JOIN coding_problems cp ON usp.problem_id = cp.id
       WHERE usp.user_id = $1 AND usp.problem_id = $2`,
      [userId, problemId]
    );
    
    return result.rows.length > 0 ? result.rows[0] : null;
  } catch (error) {
    console.error('Error fetching problem solved details:', error);
    return null;
  }
};