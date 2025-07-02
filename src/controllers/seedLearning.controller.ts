import { Request, Response } from "express";
import AdmZip from "adm-zip";
import path from "path";
import pool from "../config/db";

export const seedLearningMaterials = async (req: Request, res: Response) => {
  const extensionMap: Record<string, string> = {
    cpp: "cpp",
    java: "java",
    javascript: "js",
    python: "py",
  };

  try {
    if (!req.file) {
      return res.status(400).json({ error: "No ZIP file uploaded" });
    }

    const zip = new AdmZip(req.file.buffer);
    const entries = zip.getEntries();

    const topicFolders = Array.from(
      new Set(entries.map((entry) => entry.entryName.split("/")[0]))
    ).filter((name) => /^\d+-/.test(name));

    for (const folder of topicFolders) {
      const topicId = parseInt(folder.split("-")[0]);

      const metaEntry = zip.getEntry(`${folder}/meta.json`);
      if (!metaEntry) continue;

      const meta = JSON.parse(metaEntry.getData().toString("utf-8"));

      const markdownEntry = zip.getEntry(`${folder}/explanation.md`);
      const markdown = markdownEntry
        ? markdownEntry.getData().toString("utf-8")
        : "";

      // Diagrams
      const diagrams: Array<[string, string]> = [];
      const diagramEntries = entries.filter(
        (e) =>
          e.entryName.startsWith(`${folder}/diagrams/`) &&
          e.entryName.endsWith(".png")
      );

      for (const entry of diagramEntries) {
        const filename = path.basename(entry.entryName);
        const base64 = entry.getData().toString("base64");
        diagrams.push([filename, `data:image/png;base64,${base64}`]);
      }

      console.log(`Topic ${topicId}: Found ${diagrams.length} diagrams`);

      // Insert topic
      await pool.query(
        `INSERT INTO topics (id, title, slug, section, difficulty, markdown, diagrams, xp)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
        [
          topicId,
          meta.title,
          meta.slug,
          meta.section,
          meta.difficulty,
          markdown,
          diagrams.length ? diagrams : null,
          meta.xp ?? 0,
        ]
      );

      // Insert code examples
      const languages = ["cpp", "java", "javascript", "python"];
      for (const lang of languages) {
          const ext = extensionMap[lang];
  const codeEntry = zip.getEntry(`${folder}/code/${lang}.${ext}`);
        if (codeEntry) {
          const code = codeEntry.getData().toString("utf-8");
          await pool.query(
            `INSERT INTO topic_code_examples (topic_id, language, code)
             VALUES ($1, $2, $3)`,
            [topicId, lang, code]
          );
        }
      }

      // Insert coding questions
      for (let i = 1; i <= 3; i++) {
        const entry = zip.getEntry(`${folder}/questions/q${i}.json`);
        if (!entry) continue;
        const q = JSON.parse(entry.getData().toString("utf-8"));
        const id = `C${topicId}.${i}`;
        await pool.query(
          `INSERT INTO questions (id, topic_id, title, description, difficulty, xp)
           VALUES ($1, $2, $3, $4, $5, $6)`,
          [id, topicId, q.title, q.description, q.difficulty, q.xp]
        );
      }

      // Insert MCQs
      for (let i = 1; i <= 3; i++) {
        const entry = zip.getEntry(`${folder}/mcqs/q${i}.json`);
        if (!entry) continue;
        const mcq = JSON.parse(entry.getData().toString("utf-8"));
        const id = `M${topicId}.${i}`;
        await pool.query(
          `INSERT INTO mcqs (id, topic_id, question, options, correct_index)
           VALUES ($1, $2, $3, $4, $5)`,
          [id, topicId, mcq.question, mcq.options, mcq.correct_index]
        );
      }
    }

    res.json({ message: "Learning materials seeded successfully." });
  } catch (err) {
    console.error("Seeding error:", err);
    res.status(500).json({ error: "Failed to seed learning materials." });
  }
};

export const deleteAllLearningMaterials = async (
  req: Request,
  res: Response
) => {
  try {
    await pool.query("DELETE FROM mcqs");
    await pool.query("DELETE FROM questions");
    await pool.query("DELETE FROM topic_code_examples");
    await pool.query("DELETE FROM topics");

    res.json({ message: "All learning materials deleted successfully." });
  } catch (err) {
    console.error("Error deleting learning materials:", err);
    res
      .status(500)
      .json({ error: "Server error while deleting learning materials." });
  }
};
