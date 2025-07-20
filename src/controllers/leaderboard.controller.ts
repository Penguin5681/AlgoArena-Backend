import { Request, Response } from "express";
import pool from "../config/db";

export const getAllUsersWithCount = async (req: Request, res: Response): Promise<void> => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const offset = (Number(page) - 1) * Number(limit);

    const countResult = await pool.query("SELECT COUNT(*) FROM users");
    const totalUsers = parseInt(countResult.rows[0].count, 10);

    const usersResult = await pool.query(
      `SELECT 
          u.id, u.username, u.email, u.github_link, u.linkedin_link, u.facebook_link, 
          u.rank, u.bio, u.tech_stack, u.programming_languages, u.role,
          u.badges, u.profile_picture,
          COALESCE(utx.total_xp, 0) AS total_xp
       FROM users u
       LEFT JOIN user_total_xp utx ON u.id = utx.user_id
       ORDER BY u.id ASC
       LIMIT $1 OFFSET $2`,
      [limit, offset]
    );

    res.json({
      success: true,
      data: {
        totalUsers,
        users: usersResult.rows,
        pagination: {
          page: Number(page),
          limit: Number(limit),
          totalPages: Math.ceil(totalUsers / Number(limit))
        }
      }
    });
  } catch (error) {
    console.error("Error fetching users:", error);
    res.status(500).json({
      success: false,
      error: "Failed to fetch users"
    });
  }
};