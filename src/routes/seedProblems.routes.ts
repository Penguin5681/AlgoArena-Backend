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

export default router;
