import { Request, Response } from 'express';
import openaiService from '../services/openai.service';

export const analyzeCodeComplexity = async (req: Request, res: Response): Promise<void> => {
  try {
    const { code, language, submissionId } = req.body;
    
    if (!code || !language) {
      res.status(400).json({ error: 'Code and language are required' });
      return;
    }
    
    const analysis = await openaiService.analyzeComplexity(code, language);
    
    res.status(200).json({ analysis });
  } catch (error) {
    console.error('Error in complexity analysis:', error);
    res.status(500).json({ error: 'Failed to analyze code complexity' });
  }
};