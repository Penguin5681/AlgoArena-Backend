import express from 'express';
import multer from 'multer';
import { deleteAllLearningMaterials, seedLearningMaterials } from '../controllers/seedLearning.controller';

const router = express.Router();
const upload = multer();

router.post('/seed-learning', upload.single('zip'), seedLearningMaterials);
router.delete('/seed-learning', deleteAllLearningMaterials);

export default router;
