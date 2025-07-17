import { Router } from "express";
import { getUserActivityHeatmap, recordUserActivity, updateUserProfile } from "../controllers/user.controller";

const router = Router();

router.put("/profile", updateUserProfile);
router.post("/record-activity", recordUserActivity);
router.get("/get-heatmap/:userId", getUserActivityHeatmap);

export default router;
