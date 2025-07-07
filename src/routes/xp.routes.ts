import { Router } from 'express';
import { getUserXP, getUserSolvedProblemsList, checkProblemSolvedByUser } from '../controllers/xp.controller';
import { verifyToken } from '../middlewares/auth.middleware';

const router = Router();

router.get('/user', verifyToken, getUserXP);

router.get('/solved-problems', verifyToken, getUserSolvedProblemsList);

router.get('/problem/:problemId/solved', verifyToken, checkProblemSolvedByUser);

export default router;