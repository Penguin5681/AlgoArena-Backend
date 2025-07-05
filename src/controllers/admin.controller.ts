import { Request, Response } from 'express';
import pool from '../config/db';

export const deleteUserData = async (req: Request, res: Response) => {
  const userId = parseInt(req.params.userId);

  if (isNaN(userId)) {
    return res.status(400).json({ error: 'Invalid user ID' });
  }

  const client = await pool.connect();

  try {
    await client.query('BEGIN');

    await client.query('DELETE FROM user_xp_log WHERE user_id = $1', [userId]);
    await client.query('DELETE FROM user_question_progress WHERE user_id = $1', [userId]);
    await client.query('DELETE FROM user_topic_progress WHERE user_id = $1', [userId]);
    await client.query('DELETE FROM submissions WHERE user_id = $1', [userId]);
    await client.query('DELETE FROM team_members WHERE user_id = $1', [userId]); 
    await client.query('DELETE FROM users WHERE id = $1', [userId]);

    await client.query('COMMIT');
    res.json({ message: `All data for user ID ${userId} has been deleted.` });
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Error deleting user data:', err);
    res.status(500).json({ error: 'Failed to delete user data' });
  } finally {
    client.release();
  }
};
