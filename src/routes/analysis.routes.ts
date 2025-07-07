import { Router } from 'express';
import { analyzeCodeComplexity } from '../controllers/analysis.controller';

const router = Router();

router.post('/complexity', analyzeCodeComplexity);

export default router;