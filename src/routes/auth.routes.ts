import { Router } from 'express';
import {
    loginUser, 
    registerUser, 
    checkUsername,
    checkEmail,
    checkAvailability,
    firebaseLogin
} from '../controllers/auth.controller';

const router = Router();

router.post('/signup', registerUser);
router.post('/login', loginUser);
router.post('/firebase-login', firebaseLogin);

router.get('/check/username/:username', checkUsername);
router.get('/check/email/:email', checkEmail);
router.get('/check/availability', checkAvailability);

export default router;