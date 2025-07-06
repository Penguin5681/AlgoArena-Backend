import express from 'express';
import { CodeExecutionController } from '../controllers/codeExecution.controller';
import { verifyToken } from '../middlewares/auth.middleware';
import { SeedTemplatesController } from '../controllers/seedTemplates.controller';

const router = express.Router();
const codeExecutionController = new CodeExecutionController();
const controller = new SeedTemplatesController();

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

router.get('/problems/:problemId/templates/:language', 
  controller.getTemplate.bind(controller)
);

router.get('/problems/:problemId/templates', 
  controller.getProblemTemplates.bind(controller)
);

router.post('/problems/:problemId/templates/:language', 
  controller.createOrUpdateTemplate.bind(controller)
);

router.post('/templates/seed/file', 
  controller.seedTemplatesFromFile.bind(controller)
);

router.post('/templates/seed/body', 
  controller.seedTemplatesFromBody.bind(controller)
);

router.delete('/problems/:problemId/templates/:language', 
  controller.deleteTemplate.bind(controller)
);

export default router;