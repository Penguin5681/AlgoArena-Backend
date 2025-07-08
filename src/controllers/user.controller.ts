import { Request, Response } from "express";
import pool from "../config/db";

export const updateUserProfile = async (req: Request, res: Response) => {
  const {
    email,
    github_link,
    linkedin_link,
    facebook_link,
    rank,
    bio,
    tech_stack,
    programming_languages,
    role,
    profile_picture,
  } = req.body;

  try {
    const fields: string[] = [];
    const values: any[] = [];
    let index = 1;

    if (github_link) {
      fields.push(`github_link = $${index++}`);
      values.push(github_link);
    }
    if (linkedin_link) {
      fields.push(`linkedin_link = $${index++}`);
      values.push(linkedin_link);
    }
    if (facebook_link) {
      fields.push(`facebook_link = $${index++}`);
      values.push(facebook_link);
    }
    if (rank !== undefined) {
      fields.push(`rank = $${index++}`);
      values.push(rank);
    }
    if (bio) {
      fields.push(`bio = $${index++}`);
      values.push(bio);
    }
    if (tech_stack) {
      fields.push(`tech_stack = $${index++}`);
      values.push(tech_stack);
    }
    if (programming_languages) {
      fields.push(`programming_languages = $${index++}`);
      values.push(programming_languages);
    }
    if (role) {
      fields.push(`role = $${index++}`);
      values.push(role);
    }
    if (profile_picture) {
      fields.push(`profile_picture = $${index++}`);
      values.push(profile_picture);
    }

    if (fields.length === 0) {
      return res.status(400).json({ message: "No data provided to update." });
    }

    const query = `UPDATE users SET ${fields.join(
      ", "
    )} WHERE email = $${index}`;
    values.push(email);

    await pool.query(query, values);
    res.json({ message: "Profile updated successfully" });
  } catch (err) {
    console.error("Error updating profile:", err);
    res.status(500).json({ message: "Failed to update profile" });
  }
};

export const getUserProfilePicture = async (req: Request, res: Response) => {
  const { email } = req.body;
  try {
    const result = await pool.query(
      "SELECT profile_picture FROM users WHERE email = $1",
      [email]
    );
    res.status(200).json({ profile_picture: result });
  } catch (err) {
    console.error("Profile not found");
    res.status(500).json({ message: "Failed to get profile" });
  }
};
