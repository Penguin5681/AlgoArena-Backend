import { Request, Response } from "express";
import { bucket } from "../config/firebase";
import { v4 as uuidv4 } from "uuid";
import path from "path";
import pool from "../config/db";

export const uploadProfilePicture = async (req: Request, res: Response) => {
  try {
    const email = req.body.email;
    if (!email) return res.status(400).json({ message: "Email is required" });
    if (!req.file) return res.status(400).json({ message: "No file uploaded" });

    const file = req.file;
    const fileName = `profile_pictures/${uuidv4()}${path.extname(
      file.originalname
    )}`;
    const fileUpload = bucket.file(fileName);

    const uuid = uuidv4();

    const stream = fileUpload.createWriteStream({
      metadata: {
        contentType: file.mimetype,
        metadata: {
          firebaseStorageDownloadTokens: uuid,
        },
      },
    });

    stream.on("error", (err: { message: any }) => {
      console.error(err);
      res.status(500).json({ message: "Upload error", error: err.message });
    });

    stream.on("finish", async () => {
      const publicUrl = `https://firebasestorage.googleapis.com/v0/b/${
        bucket.name
      }/o/${encodeURIComponent(fileName)}?alt=media&token=${uuid}`;
      try {
        await pool.query(
          `UPDATE users SET profile_picture = $1 WHERE email = $2`,
          [publicUrl, email]
        );
        return res.status(200).json({ url: publicUrl });
      } catch (dbErr) {
        console.error("DB update error:", dbErr);
        return res.status(500).json({ message: "DB update failed" });
      }
    });

    stream.end(file.buffer);
  } catch (err: any) {
    console.error(err);
    res.status(500).json({ message: "Unexpected error", error: err.message });
  }
};

export const getUserProfile = async (req: Request, res: Response) => {
  const email = req.params.email;

  if (!email) {
    return res.status(400).json({ error: "Email is required" });
  }

  try {
    const result = await pool.query(
      `SELECT 
         email,
         username,
         github_link,
         linkedin_link,
         facebook_link,
         profile_picture,
         rank,
         bio,
         tech_stack,
         programming_languages,
         role,
         badges
       FROM users
       WHERE email = $1`,
      [email]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }

    return res.status(200).json(result.rows[0]);
  } catch (err) {
    console.error("Error fetching user profile:", err);
    return res.status(500).json({ error: "Internal server error" });
  }
};

// PATCH /api/profile/update
export const updateFullProfile = async (req: Request, res: Response) => {
  const userId = (req as any).user.id;

  const {
    email,
    github_link,
    linkedin_link,
    facebook_link,
    tech_stack,
    programming_languages,
    profile_picture,
  } = req.body;

  try {
    const result = await pool.query(
      `
      UPDATE users
      SET 
        github_link = COALESCE($2, github_link),
        linkedin_link = COALESCE($3, linkedin_link),
        facebook_link = COALESCE($4, facebook_link),
        tech_stack = COALESCE($5, tech_stack),
        programming_languages = COALESCE($6, programming_languages),
        profile_picture = COALESCE($7, profile_picture)
      WHERE email = $1
      RETURNING *;
      `,
      [
        email,
        github_link,
        linkedin_link,
        facebook_link,
        tech_stack,
        programming_languages,
        profile_picture,
      ]
    );

    res.status(200).json({ message: "Profile updated", user: result.rows[0] });
  } catch (error) {
    console.error("Error updating profile:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

export const updateBio = async (req: Request, res: Response) => {
  const userId = (req as any).user.id;
  
  const { email, bio } = req.body;
  
  try {
    const result = await pool.query(
      `UPDATE users SET bio = $2 WHERE email = $1 RETURNING *;`,
      [email, bio]
    );

    res.status(200).json({ message: "Bio updated", user: result.rows[0] });
  } catch (error) {
    console.error("Error updating bio:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

export const updateRole = async (req: Request, res: Response) => {
  const userId = (req as any).user.id;
  
  const { email, role } = req.body;

  try {
    const result = await pool.query(
      `UPDATE users SET role = $2 WHERE email = $1 RETURNING *;`,
      [email, role]
    );

    res.status(200).json({ message: "Role updated", user: result.rows[0] });
  } catch (error) {
    console.error("Error updating role:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

export const updateTechStack = async (req: Request, res: Response) => {
  const { email, tech_stack } = req.body;

  try {
    const result = await pool.query(
      `UPDATE users SET tech_stack = $2 WHERE email = $1 RETURNING *;`,
      [email, tech_stack]
    );

    res.status(200).json({ message: "Tech stack updated", user: result.rows[0] });
  } catch (error) {
    console.error("Error updating tech stack:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

export const updateProgrammingLanguages = async (req: Request, res: Response) => {
  const { email, programming_languages } = req.body;

  try {
    const result = await pool.query(
      `UPDATE users SET programming_languages = $2 WHERE email = $1 RETURNING *;`,
      [email, programming_languages]
    );

    res.status(200).json({ message: "Programming languages updated", user: result.rows[0] });
  } catch (error) {
    console.error("Error updating programming languages:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

export const updateSocialLinks = async (req: Request, res: Response) => {
  const { email, github_link, linkedin_link, facebook_link } = req.body;

  try {
    const result = await pool.query(
      `
      UPDATE users
      SET 
        github_link = COALESCE($2, github_link),
        linkedin_link = COALESCE($3, linkedin_link),
        facebook_link = COALESCE($4, facebook_link)
      WHERE email = $1
      RETURNING *;
      `,
      [email, github_link, linkedin_link, facebook_link]
    );

    res.status(200).json({ message: "Social links updated", user: result.rows[0] });
  } catch (error) {
    console.error("Error updating social links:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};
