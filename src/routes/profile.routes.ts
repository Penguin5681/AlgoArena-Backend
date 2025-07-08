import { Router } from "express";
import {
  updateBio,
  updateFullProfile,
  updateProgrammingLanguages,
  updateRole,
  updateSocialLinks,
  updateTechStack,
  uploadProfilePicture,
} from "../controllers/profile.controller";
import { upload } from "../middlewares/upload.middleware";
import { getUserProfile } from "../controllers/profile.controller";
import { verifyToken } from "../middlewares/auth.middleware";

const router = Router();

router.post(
  "/upload-profile-picture",
  upload.single("file"),
  uploadProfilePicture
);
router.get("/get-profile/:email", getUserProfile);
router.patch("/update", verifyToken, updateFullProfile);
router.patch("/update-bio", verifyToken, updateBio);
router.patch("/update-role", verifyToken, updateRole);
router.patch("/update-tech-stack", verifyToken, updateTechStack);
router.patch(
  "/update-programming-languages",
  verifyToken,
  updateProgrammingLanguages
);
router.patch("/update-social-links", verifyToken, updateSocialLinks);

export default router;
