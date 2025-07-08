import { Router } from 'express';
import { uploadProfilePicture } from '../controllers/profile.controller';
import { upload } from '../middlewares/upload.middleware';

const router = Router();

router.post('/upload-profile-picture', upload.single('file'), uploadProfilePicture);

export default router;
