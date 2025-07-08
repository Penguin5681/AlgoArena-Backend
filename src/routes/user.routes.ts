import { Router } from "express";
import { updateUserProfile } from "../controllers/user.controller";
import { verifyToken } from "../middlewares/auth.middleware";

const router = Router();

router.put("/profile", updateUserProfile);

export default router;
