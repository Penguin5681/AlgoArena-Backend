import express from 'express';
import { createTeam, getCurrentTeam, getTeamInfo, joinTeam, leaveTeam, promoteToAdmin } from '../controllers/teams.controller';
import { verifyToken } from '../middlewares/auth.middleware';

const router = express.Router();

router.post('/create', verifyToken, createTeam);
router.post('/join', verifyToken, joinTeam);
router.post('/leave', verifyToken, leaveTeam);
router.get('/teamInfo', verifyToken, getTeamInfo);
router.get('/current', verifyToken, getCurrentTeam);
router.post('/promote', verifyToken, promoteToAdmin);

export default router;
