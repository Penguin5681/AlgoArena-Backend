import { Request, Response } from "express";
import pool from "../config/db";

export interface ChatMessage {
	id: number;
	team_id: number;
	sender_id: number;
	content: string;
	created_at: Date;
	sender_username: string;
}

export const getTeamChatMessages = async (
	req: Request,
	res: Response
): Promise<void> => {
	try {
		const { teamId } = req.params;
		const userId = (req as any).user.id;
		const { page = 1, limit = 50 } = req.query;

		const memberCheck = await pool.query(
			"SELECT user_id FROM team_members WHERE user_id = $1 AND team_id = $2",
			[userId, teamId]
		);

		if (memberCheck.rows.length === 0) {
			res.status(403).json({
				success: false,
				error: "You are not a member of this team",
			});
			return;
		}

		const offset = (Number(page) - 1) * Number(limit);

		const result = await pool.query(
			`SELECT 
        tcm.id,
        tcm.team_id,
        tcm.sender_id,
        tcm.content,
        tcm.created_at,
        u.username as sender_username
       FROM team_chat_messages tcm
       JOIN users u ON tcm.sender_id = u.id
       WHERE tcm.team_id = $1
       ORDER BY tcm.created_at DESC
       LIMIT $2 OFFSET $3`,
			[teamId, limit, offset]
		);

		const countResult = await pool.query(
			"SELECT COUNT(*) FROM team_chat_messages WHERE team_id = $1",
			[teamId]
		);

		const totalMessages = parseInt(countResult.rows[0].count);
		const totalPages = Math.ceil(totalMessages / Number(limit));

		res.json({
			success: true,
			data: {
				messages: result.rows.reverse(),
				pagination: {
					currentPage: Number(page),
					totalPages,
					totalMessages,
					limit: Number(limit),
				},
			},
		});
	} catch (error) {
		console.error("Error fetching team chat messages:", error);
		res.status(500).json({
			success: false,
			error: "Failed to fetch chat messages",
		});
	}
};

export const sendTeamChatMessage = async (
	req: Request,
	res: Response
): Promise<void> => {
	try {
		const { teamId } = req.params;
		const { content } = req.body;
		const userId = (req as any).user.id;

		if (!content || content.trim().length === 0) {
			res.status(400).json({
				success: false,
				error: "Message content is required",
			});
			return;
		}

		if (content.length > 1000) {
			res.status(400).json({
				success: false,
				error: "Message content cannot exceed 1000 characters",
			});
			return;
		}

		// Verify user is a member of the team
		const memberCheck = await pool.query(
			"SELECT user_id FROM team_members WHERE user_id = $1 AND team_id = $2",
			[userId, teamId]
		);

		if (memberCheck.rows.length === 0) {
			res.status(403).json({
				success: false,
				error: "You are not a member of this team",
			});
			return;
		}

		// Insert the message
		const result = await pool.query(
			`INSERT INTO team_chat_messages (team_id, sender_id, content)
       VALUES ($1, $2, $3)
       RETURNING id, team_id, sender_id, content, created_at`,
			[teamId, userId, content.trim()]
		);

		// Get sender username
		const userResult = await pool.query(
			"SELECT username FROM users WHERE id = $1",
			[userId]
		);

		const message = {
			...result.rows[0],
			sender_username: userResult.rows[0].username,
		};

		res.status(201).json({
			success: true,
			data: message,
		});
	} catch (error) {
		console.error("Error sending team chat message:", error);
		res.status(500).json({
			success: false,
			error: "Failed to send message",
		});
	}
};

export const getTeamMembers = async (
	req: Request,
	res: Response
): Promise<void> => {
	try {
		const { teamId } = req.params;
		const userId = (req as any).user.id;

		// Verify user is a member of the team
		const memberCheck = await pool.query(
			"SELECT user_id FROM team_members WHERE user_id = $1 AND team_id = $2",
			[userId, teamId]
		);

		if (memberCheck.rows.length === 0) {
			res.status(403).json({
				success: false,
				error: "You are not a member of this team",
			});
			return;
		}

		// Get all team members
		const result = await pool.query(
			`SELECT 
        tm.user_id,
        tm.is_admin,
        u.username,
        u.email
       FROM team_members tm
       JOIN users u ON tm.user_id = u.id
       WHERE tm.team_id = $1
       ORDER BY tm.is_admin DESC, u.username ASC`,
			[teamId]
		);

		res.json({
			success: true,
			data: result.rows,
		});
	} catch (error) {
		console.error("Error fetching team members:", error);
		res.status(500).json({
			success: false,
			error: "Failed to fetch team members",
		});
	}
};
