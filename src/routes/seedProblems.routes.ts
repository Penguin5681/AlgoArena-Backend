import express from "express";
import { SeedProblemsController } from "../controllers/seedProblems.controller";

const router = express.Router();
const seedProblemsController = new SeedProblemsController();

router.post(
  "/seed-problems",
  seedProblemsController.seedProblems.bind(seedProblemsController)
);
router.get(
  "/status",
  seedProblemsController.getProblemStatus.bind(seedProblemsController)
);

router.get(
  "/problems",
  seedProblemsController.getAllProblems.bind(seedProblemsController)
);
router.get(
  "/problems/:id",
  seedProblemsController.getProblemById.bind(seedProblemsController)
);
router.get(
  "/topics/:topicId/problems",
  seedProblemsController.getProblemsByTopic.bind(seedProblemsController)
);
router.get(
  "/topics",
  seedProblemsController.getTopics.bind(seedProblemsController)
);

export default router;
