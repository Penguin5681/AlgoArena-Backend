import { Request, Response } from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import pool from "../config/db";
import admin from "../config/firebase";

const JWT_SECRET = process.env.JWT_SECRET as string;

export const registerUser = async (req: Request, res: Response) => {
  const { username, email, password } = req.body;
  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    await pool.query(
      "INSERT INTO users (username, email, password) VALUES ($1, $2, $3)",
      [username, email, hashedPassword]
    );
    res.status(201).json({ message: "User created" });
  } catch (err) {
    res.status(500).json({ message: "" + err });
  }
};

export const loginUser = async (req: Request, res: Response) => {
  const { identifier, password } = req.body;
  try {
    const result = await pool.query(
      "SELECT * FROM users WHERE email = $1 OR username = $1",
      [identifier]
    );
    const user = result.rows[0];

    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ error: "Invalid credentials" });
    }

    const token = jwt.sign(
      { id: user.id, username: user.username, email: user.email },
      JWT_SECRET,
      { expiresIn: "1h" }
    );
    res.status(200).json({
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
      },
    });
  } catch (err) {
    res.status(500).json({ error: "Server error: " + err });
  }
};

export const checkUsername = async (req: Request, res: Response) => {
  const { username } = req.params;

  if (!username) {
    return res.status(400).json({ error: "Username is required" });
  }

  try {
    const result = await pool.query(
      "SELECT username FROM users WHERE username = $1",
      [username]
    );

    const exists = result.rows.length > 0;

    res.json({
      username,
      exists,
      available: !exists,
    });
  } catch (err: any) {
    console.error("Username check error:", err);
    res.status(500).json({ error: "Server error: " + err.message });
  }
};

export const checkEmail = async (req: Request, res: Response) => {
  const { email } = req.params;

  if (!email) {
    return res.status(400).json({ error: "Email is required" });
  }

  try {
    const result = await pool.query(
      "SELECT email FROM users WHERE email = $1",
      [email]
    );

    const exists = result.rows.length > 0;

    res.json({
      email,
      exists,
      available: !exists,
    });
  } catch (err: any) {
    console.error("Email check error:", err);
    res.status(500).json({ error: "Server error: " + err.message });
  }
};

export const checkAvailability = async (req: Request, res: Response) => {
  const { username, email } = req.query;

  if (!username && !email) {
    return res.status(400).json({ error: "Username or email is required" });
  }

  try {
    let result;

    if (username && email) {
      result = await pool.query(
        "SELECT username, email FROM users WHERE username = $1 OR email = $2",
        [username, email]
      );
    } else if (username) {
      result = await pool.query(
        "SELECT username FROM users WHERE username = $1",
        [username]
      );
    } else {
      result = await pool.query("SELECT email FROM users WHERE email = $1", [
        email,
      ]);
    }

    const foundUser = result.rows[0];

    const response: any = {};

    if (username) {
      response.username = {
        value: username,
        exists: foundUser && foundUser.username === username,
        available: !(foundUser && foundUser.username === username),
      };
    }

    if (email) {
      response.email = {
        value: email,
        exists: foundUser && foundUser.email === email,
        available: !(foundUser && foundUser.email === email),
      };
    }

    res.json(response);
  } catch (err: any) {
    console.error("Availability check error:", err);
    res.status(500).json({ error: "Server error: " + err.message });
  }
};

export const firebaseLogin = async (req: Request, res: Response) => {
  const { idToken, email, name, photoURL, uid } = req.body;

  if (!idToken) {
    return res.status(400).json({ error: "ID token is required" });
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);

    if (decodedToken.uid !== uid) {
      return res.status(401).json({ error: "Invalid token" });
    }

    const userResult = await pool.query(
      "SELECT * FROM users WHERE firebase_uid = $1",
      [uid]
    );

    let user = userResult.rows[0];

    if (!user) {
      const baseUsername = (name || email.split("@")[0])
        .toLowerCase()
        .replace(/\s+/g, "");
      let username = baseUsername;
      let usernameExists = true;
      let counter = 1;

      while (usernameExists) {
        const usernameCheck = await pool.query(
          "SELECT username FROM users WHERE username = $1",
          [username]
        );

        if (usernameCheck.rows.length === 0) {
          usernameExists = false;
        } else {
          username = `${baseUsername}${counter}`;
          counter++;
        }
      }

      const newUserResult = await pool.query(
        `INSERT INTO users (
          username, 
          email, 
          password, 
          firebase_uid, 
          profile_picture
        ) VALUES ($1, $2, $3, $4, $5) RETURNING *`,
        [
          username,
          email,
          await bcrypt.hash(Math.random().toString(36).slice(-10), 10),
          uid,
          photoURL || null,
        ]
      );

      user = newUserResult.rows[0];
    } else {
      await pool.query(
        `UPDATE users SET 
          email = $1, 
          profile_picture = $2
        WHERE firebase_uid = $3`,
        [email, photoURL || null, uid]
      );
    }

    const token = jwt.sign(
      {
        id: user.id,
        username: user.username,
        email: user.email,
        firebase_uid: user.firebase_uid,
      },
      JWT_SECRET,
      { expiresIn: "7d" }
    );

    res.status(200).json({
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        profilePicture: user.profile_picture,
      },
    });
  } catch (error: any) {
    console.error("Firebase authentication error:", error);
    res.status(401).json({ error: "Invalid Firebase token: " + error.message });
  }
};

export const deleteAccount = async (req: Request, res: Response) => {
  const userId = (req as any).user.id;
  const { password, confirmDelete } = req.body;

  try {
    const userResult = await pool.query("SELECT * FROM users WHERE id = $1", [
      userId,
    ]);

    if (userResult.rows.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }

    const user = userResult.rows[0];

    if (user.password && !user.firebase_uid) {
      if (!password) {
        return res.status(400).json({
          error: "Password is required to delete account",
        });
      }

      const isValidPassword = await bcrypt.compare(password, user.password);
      if (!isValidPassword) {
        return res.status(401).json({ error: "Invalid password" });
      }
    }

    if (confirmDelete !== "DELETE_MY_ACCOUNT") {
      return res.status(400).json({
        error:
          'Please confirm account deletion by sending confirmDelete: "DELETE_MY_ACCOUNT"',
      });
    }

    await pool.query("BEGIN");

    try {
      const soloAdminTeams = await pool.query(
        `
        SELECT t.id, t.name 
        FROM teams t
        WHERE t.id IN (
          SELECT tm.team_id 
          FROM team_members tm 
          WHERE tm.user_id = $1 AND tm.is_admin = true
        )
        AND (
          SELECT COUNT(*) 
          FROM team_members tm2 
          WHERE tm2.team_id = t.id AND tm2.is_admin = true
        ) = 1
      `,
        [userId]
      );

      if (soloAdminTeams.rows.length > 0) {
        for (const team of soloAdminTeams.rows) {
          await pool.query("DELETE FROM teams WHERE id = $1", [team.id]);
        }
      }

      await pool.query("DELETE FROM team_members WHERE user_id = $1", [userId]);

      await pool.query("DELETE FROM user_topic_progress WHERE user_id = $1", [
        userId,
      ]);
      await pool.query(
        "DELETE FROM user_question_progress WHERE user_id = $1",
        [userId]
      );
      await pool.query("DELETE FROM user_total_xp WHERE user_id = $1", [
        userId,
      ]);

      await pool.query("DELETE FROM users WHERE id = $1", [userId]);

      await pool.query("COMMIT");

      res.json({
        message: "Account deleted successfully",
        deletedTeams: soloAdminTeams.rows.map((team) => team.name),
      });
    } catch (error) {
      await pool.query("ROLLBACK");
      throw error;
    }
  } catch (error: any) {
    console.error("Delete account error:", error);
    res.status(500).json({
      error: "Failed to delete account: " + error.message,
    });
  }
};

export const getAccountDeletionInfo = async (req: Request, res: Response) => {
  const userId = (req as any).user.id;

  try {
    const userResult = await pool.query(
      "SELECT username, email, firebase_uid FROM users WHERE id = $1",
      [userId]
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }

    const user = userResult.rows[0];

    const teamMemberships = await pool.query(
      `
      SELECT t.name, tm.is_admin,
        (SELECT COUNT(*) FROM team_members tm2 WHERE tm2.team_id = t.id AND tm2.is_admin = true) as admin_count
      FROM teams t
      JOIN team_members tm ON t.id = tm.team_id
      WHERE tm.user_id = $1
    `,
      [userId]
    );

    const progressStats = await pool.query(
      `
      SELECT 
        (SELECT COUNT(*) FROM user_topic_progress WHERE user_id = $1) as completed_topics,
        (SELECT COUNT(*) FROM user_question_progress WHERE user_id = $1) as attempted_questions,
        (SELECT total_xp FROM user_total_xp WHERE user_id = $1) as total_xp
    `,
      [userId]
    );

    const teamsAsOnlyAdmin = teamMemberships.rows.filter(
      (team) => team.is_admin && team.admin_count === 1
    );

    res.json({
      user: {
        username: user.username,
        email: user.email,
        isFirebaseUser: !!user.firebase_uid,
      },
      impact: {
        teamsAsOnlyAdmin: teamsAsOnlyAdmin.map((t) => t.name),
        teamsAsMember: teamMemberships.rows
          .filter((t) => !t.is_admin)
          .map((t) => t.name),
        teamsAsCoAdmin: teamMemberships.rows
          .filter((t) => t.is_admin && t.admin_count > 1)
          .map((t) => t.name),
        completedTopics: progressStats.rows[0]?.completed_topics || 0,
        attemptedQuestions: progressStats.rows[0]?.attempted_questions || 0,
        totalXP: progressStats.rows[0]?.total_xp || 0,
      },
      warning:
        teamsAsOnlyAdmin.length > 0
          ? `Deleting your account will also delete ${teamsAsOnlyAdmin.length} team(s) where you are the only admin.`
          : null,
    });
  } catch (error: any) {
    console.error("Get deletion info error:", error);
    res.status(500).json({ error: "Server error: " + error.message });
  }
};
