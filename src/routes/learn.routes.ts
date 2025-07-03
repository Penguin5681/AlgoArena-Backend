// src/routes/learn.routes.ts

import express from 'express';
import {
  getTopicSummary,
  getTopicDetails,
  getTopicQuestions,
  getTopicMcqs,
  getUserXP,
  updateTopicProgress,
  updateQuestionProgress,
  getUserTopicProgress,
  getUserLearningProgress
} from '../controllers/learn.controller';

const router = express.Router();

router.get('/summary', getTopicSummary);
router.get('/topic/:id', getTopicDetails);
router.get('/topic/:id/questions', getTopicQuestions);
router.get('/topic/:id/mcqs', getTopicMcqs);
router.post('/xp', getUserXP);
router.post('/progress/topic', updateTopicProgress);
router.post('/progress/question', updateQuestionProgress);
router.get('/progress/topics', getUserTopicProgress);
router.get('/progress', getUserLearningProgress);

export default router;
