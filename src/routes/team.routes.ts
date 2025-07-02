import express from 'express';
import { createTeam, getTeamInfo, joinTeam, leaveTeam } from '../controllers/teams.controller';
import { verifyToken } from '../middlewares/auth.middleware';

const router = express.Router();

router.post('/create', verifyToken, createTeam);
router.post('/join', verifyToken, joinTeam);
router.post('/leave', verifyToken, leaveTeam);
router.get('/teamInfo', verifyToken, getTeamInfo);

export default router;
