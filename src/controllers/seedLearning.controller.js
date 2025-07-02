"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteAllLearningMaterials = exports.seedLearningMaterials = void 0;
const adm_zip_1 = __importDefault(require("adm-zip"));
const path_1 = __importDefault(require("path"));
const db_1 = __importDefault(require("../config/db"));
const seedLearningMaterials = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    const extensionMap = {
        cpp: "cpp",
        java: "java",
        javascript: "js",
        python: "py",
    };
    try {
        if (!req.file) {
            return res.status(400).json({ error: "No ZIP file uploaded" });
        }
        const zip = new adm_zip_1.default(req.file.buffer);
        const entries = zip.getEntries();
        const topicFolders = Array.from(new Set(entries.map((entry) => entry.entryName.split("/")[0]))).filter((name) => /^\d+-/.test(name));
        for (const folder of topicFolders) {
            const topicId = parseInt(folder.split("-")[0]);
            const metaEntry = zip.getEntry(`${folder}/meta.json`);
            if (!metaEntry)
                continue;
            const meta = JSON.parse(metaEntry.getData().toString("utf-8"));
            const markdownEntry = zip.getEntry(`${folder}/explanation.md`);
            const markdown = markdownEntry
                ? markdownEntry.getData().toString("utf-8")
                : "";
            // Diagrams
            const diagrams = [];
            const diagramEntries = entries.filter((e) => e.entryName.startsWith(`${folder}/diagrams/`) &&
                e.entryName.endsWith(".png"));
            for (const entry of diagramEntries) {
                const filename = path_1.default.basename(entry.entryName);
                const base64 = entry.getData().toString("base64");
                diagrams.push([filename, `data:image/png;base64,${base64}`]);
            }
            console.log(`Topic ${topicId}: Found ${diagrams.length} diagrams`);
            // Insert topic
            yield db_1.default.query(`INSERT INTO topics (id, title, slug, section, difficulty, markdown, diagrams, xp)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`, [
                topicId,
                meta.title,
                meta.slug,
                meta.section,
                meta.difficulty,
                markdown,
                diagrams.length ? diagrams : null,
                (_a = meta.xp) !== null && _a !== void 0 ? _a : 0,
            ]);
            // Insert code examples
            const languages = ["cpp", "java", "javascript", "python"];
            for (const lang of languages) {
                const ext = extensionMap[lang];
                const codeEntry = zip.getEntry(`${folder}/code/${lang}.${ext}`);
                if (codeEntry) {
                    const code = codeEntry.getData().toString("utf-8");
                    yield db_1.default.query(`INSERT INTO topic_code_examples (topic_id, language, code)
             VALUES ($1, $2, $3)`, [topicId, lang, code]);
                }
            }
            // Insert coding questions
            for (let i = 1; i <= 3; i++) {
                const entry = zip.getEntry(`${folder}/questions/q${i}.json`);
                if (!entry)
                    continue;
                const q = JSON.parse(entry.getData().toString("utf-8"));
                const id = `C${topicId}.${i}`;
                yield db_1.default.query(`INSERT INTO questions (id, topic_id, title, description, difficulty, xp)
           VALUES ($1, $2, $3, $4, $5, $6)`, [id, topicId, q.title, q.description, q.difficulty, q.xp]);
            }
            // Insert MCQs
            for (let i = 1; i <= 3; i++) {
                const entry = zip.getEntry(`${folder}/mcqs/q${i}.json`);
                if (!entry)
                    continue;
                const mcq = JSON.parse(entry.getData().toString("utf-8"));
                const id = `M${topicId}.${i}`;
                yield db_1.default.query(`INSERT INTO mcqs (id, topic_id, question, options, correct_index)
           VALUES ($1, $2, $3, $4, $5)`, [id, topicId, mcq.question, mcq.options, mcq.correct_index]);
            }
        }
        res.json({ message: "Learning materials seeded successfully." });
    }
    catch (err) {
        console.error("Seeding error:", err);
        res.status(500).json({ error: "Failed to seed learning materials." });
    }
});
exports.seedLearningMaterials = seedLearningMaterials;
const deleteAllLearningMaterials = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        yield db_1.default.query("DELETE FROM mcqs");
        yield db_1.default.query("DELETE FROM questions");
        yield db_1.default.query("DELETE FROM topic_code_examples");
        yield db_1.default.query("DELETE FROM topics");
        res.json({ message: "All learning materials deleted successfully." });
    }
    catch (err) {
        console.error("Error deleting learning materials:", err);
        res
            .status(500)
            .json({ error: "Server error while deleting learning materials." });
    }
});
exports.deleteAllLearningMaterials = deleteAllLearningMaterials;
