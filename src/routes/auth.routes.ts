import { Router } from 'express';
import {
    loginUser, 
    registerUser, 
    checkUsername,
    checkEmail,
    checkAvailability,
    firebaseLogin,
    getAccountDeletionInfo,
    deleteAccount
} from '../controllers/auth.controller';
import { verifyToken } from '../middlewares/auth.middleware';

const router = Router();

router.post('/signup', registerUser);
router.post('/login', loginUser);
router.post('/firebase-login', firebaseLogin);

router.get('/check/username/:username', checkUsername);
router.get('/check/email/:email', checkEmail);
router.get('/check/availability', checkAvailability);

router.get('/account/deletion-info', verifyToken, getAccountDeletionInfo);
router.delete('/account', verifyToken, deleteAccount);

export default router;