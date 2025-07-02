import { Request, Response } from "express";
import pool from "../config/db";
import { generateTeamCode } from "../utils/generate-team-code";
import { assert, error } from "console";

export const createTeam = async (req: Request, res: Response) => {
    const userId = (req as any).user.id;
    const { name } = req.body;

    try {
        const existing = await pool.query("SELECT * FROM team_members WHERE user_id = $1", [userId]);
        if (existing.rowCount && existing.rowCount > 0) {
            return res.status(400).json({ error: 'User already in a team' });
        }


        let joinCode: string;
        while (true) {
            joinCode = generateTeamCode();
            const result = await pool.query('SELECT id FROM teams WHERE join_code = $1', [joinCode]);
            if (result.rowCount == 0) {
                break;
            }
        }

        const teamRes = await pool.query('INSERT INTO teams (name, join_code, created_by) VALUES ($1, $2, $3) RETURNING id', [name, joinCode, userId]);
        const teamId = teamRes.rows[0].id;

        await pool.query(
            'INSERT INTO team_members (user_id, team_id, is_admin) VALUES ($1, $2, $3)',
            [userId, teamId, true]
        );

        res.status(201).json({ teamId, joinCode });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Server encountered an error" });
    }
};

export const joinTeam = async (req: Request, res: Response) => {
    const userId = (req as any).user.id;
    const { joinCode } = req.body;

    try {
        const existing = await pool.query('SELECT * FROM team_members WHERE user_id = $1', [userId]);
        if (existing.rowCount && existing.rowCount > 0) {
            return res.status(400).json({ error: 'User already in a team' });
        }

        const teamRes = await pool.query('SELECT id FROM teams WHERE join_code = $1', [joinCode]);
        if (teamRes.rowCount === 0) {
            return res.status(404).json({ error: 'Team not found' });
        }

        await pool.query(
            'INSERT INTO team_members (user_id, team_id, is_admin) VALUES ($1, $2, false)',
            [userId, teamRes.rows[0].id]
        );

        res.json({ message: 'Joined team' });
    } catch (err) {
        res.status(500).json({ error: 'Server error' });
    }
};

export const getTeamInfo = async (req: Request, res: Response) => {
    const userId = (req as any).user.id;

    try {
        const teamRes = await pool.query(`
          SELECT t.id, t.name, t.join_code, t.created_at
          FROM teams t
          JOIN team_members tm ON tm.team_id = t.id
          WHERE tm.user_id = $1
        `, [userId]);

        if (teamRes.rowCount === 0) {
            return res.status(404).json({ error: 'User not in a team' });
        }

        const team = teamRes.rows[0];

        const membersRes = await pool.query(`
          SELECT u.username, u.email, u.profile_picture, tm.is_admin
          FROM users u
          JOIN team_members tm ON tm.user_id = u.id
          WHERE tm.team_id = $1
        `, [team.id]);

        res.json({
            ...team,
            members: membersRes.rows
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error while fetching team info' });
    }
};


export const leaveTeam = async (req: Request, res: Response) => {
    const userId = (req as any).user.id;

    try {
        const result = await pool.query(
            'SELECT is_admin FROM team_members WHERE user_id = $1',
            [userId]
        );

        if (result.rowCount === 0) {
            return res.status(404).json({ error: 'User not in a team' });
        }

        const isAdmin = result.rows[0].is_admin;
        if (isAdmin) {
            return res.status(403).json({ error: 'Admins cannot leave the team. You can delete the team instead.' });
        }

        await pool.query('DELETE FROM team_members WHERE user_id = $1', [userId]);

        res.json({ message: 'Left the team successfully' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error while leaving team' });
    }
};



export const promoteToAdmin = async (req: Request, res: Response) => {
    const adminId = (req as any).user.id;
    const { targetUserEmail } = req.body;

    try {
        const adminCheck = await pool.query(`
            SELECT team_id, is_admin FROM team_members WHERE user_id = $1
        `, [adminId]);

        if (adminCheck.rowCount === 0 || !adminCheck.rows[0]?.is_admin) {
            return res.status(403).json({ error: "Only admins can promote others" });
        }

        const teamId = adminCheck.rows[0].team_id;

        const userQuery = await pool.query(`
            SELECT id FROM users WHERE email = $1
        `, [targetUserEmail]);

        if (userQuery.rowCount === 0) {
            return res.status(404).json({ error: "User with this email not found" });
        }

        const targetUserId = userQuery.rows[0].id;

        const teamCheck = await pool.query(`
            SELECT * FROM team_members WHERE user_id = $1 AND team_id = $2
        `, [targetUserId, teamId]);

        if (teamCheck.rowCount === 0) {
            return res.status(400).json({ error: "Target user is not in your team" });
        }

        if (teamCheck.rows[0].is_admin) {
            return res.status(400).json({ error: "User is already an admin" });
        }

        await pool.query(`
            UPDATE team_members SET is_admin = true WHERE user_id = $1 AND team_id = $2
        `, [targetUserId, teamId]);

        res.json({ 
            message: "User promoted to admin successfully",
            user: targetUserEmail
        });
    } catch (err) {
        console.error("Error promoting user to admin:", err);
        res.status(500).json({ error: "Server error while promoting user" });
    }
};


export const deleteTeam = async (req: Request, res: Response) => {
    const adminId = (req as any).user.id;

    // Get team and check admin status
    const res1 = await pool.query(`
    SELECT t.id FROM teams t
    JOIN team_members tm ON tm.team_id = t.id
    WHERE tm.user_id = $1 AND tm.is_admin = true
  `, [adminId]);

    if (res1.rowCount === 0) {
        return res.status(403).json({ error: "Only admins can delete the team" });
    }

    const teamId = res1.rows[0].id;

    // Delete team
    await pool.query('DELETE FROM teams WHERE id = $1', [teamId]);
    res.json({ message: "Team deleted and all members removed" });
};

export const getCurrentTeam = async (req: Request, res: Response) => {
  const userId = (req as any).user.id;

  try {
    const teamRes = await pool.query(`
      SELECT t.id, t.name, t.join_code, t.created_at
      FROM teams t
      JOIN team_members tm ON t.id = tm.team_id
      WHERE tm.user_id = $1
    `, [userId]);

    if (teamRes.rowCount === 0) {
      return res.status(404).json({ error: "User is not in a team" });
    }

    const team = teamRes.rows[0];

    const membersRes = await pool.query(`
      SELECT u.username, u.email, u.profile_picture, tm.is_admin
      FROM users u
      JOIN team_members tm ON u.id = tm.user_id
      WHERE tm.team_id = $1
    `, [team.id]);

    res.json({
      ...team,
      members: membersRes.rows
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Server error while fetching team info" });
  }
};
