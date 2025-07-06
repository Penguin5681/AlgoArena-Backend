import express from 'express';
import { CodeExecutionController } from '../controllers/codeExecution.controller';
import { verifyToken } from '../middlewares/auth.middleware';

const router = express.Router();
const codeExecutionController = new CodeExecutionController();

router.post('/problems/:problemId/submit', 
  verifyToken, 
  codeExecutionController.submitCodeForProblem.bind(codeExecutionController)
);

router.post('/compile', 
  verifyToken, 
  codeExecutionController.submitCodeForCompilation.bind(codeExecutionController)
);

router.get('/submissions/:submissionId', 
  verifyToken, 
  codeExecutionController.getSubmissionResult.bind(codeExecutionController)
);

router.get('/submissions', 
  verifyToken, 
  codeExecutionController.getUserSubmissions.bind(codeExecutionController)
);

router.get('/problems/:problemId/test-cases', 
  codeExecutionController.getProblemTestCases.bind(codeExecutionController)
);

export default router;