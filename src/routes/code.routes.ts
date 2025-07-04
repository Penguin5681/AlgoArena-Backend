import express from 'express';
import { createCodeSubmission, getSubmissionResult } from '../controllers/code.controller';
import { verifyToken } from '../middlewares/auth.middleware';

const router = express.Router();

router.post('/submit', createCodeSubmission);
router.get('/result/:submissionId', getSubmissionResult);

export default router;