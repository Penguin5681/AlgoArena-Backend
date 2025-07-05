import express from 'express';
import { deleteUserData } from '../controllers/admin.controller';

const router = express.Router();

router.delete('/delete-user/:userId', deleteUserData);

export default router;
