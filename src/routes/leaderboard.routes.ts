import { Router } from "express";
import { getAllUsersWithCount } from "../controllers/leaderboard.controller";
import { verifyToken } from "../middlewares/auth.middleware";

const router = Router();

router.get("/users", verifyToken, getAllUsersWithCount);

export default router;