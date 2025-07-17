import { Router } from "express";
import {
  getTeamChatMessages,
  sendTeamChatMessage,
  getTeamMembers,
} from "../controllers/teamChat.controller";
import { verifyToken } from "../middlewares/auth.middleware";

const router = Router();

router.get("/:teamId/messages", verifyToken, getTeamChatMessages);

router.post("/:teamId/messages", verifyToken, sendTeamChatMessage);

router.get("/:teamId/members", verifyToken, getTeamMembers);

export default router;
