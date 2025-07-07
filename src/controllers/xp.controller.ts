import { Request, Response } from "express";
import { getUserTotalXP, getUserSolvedProblems, checkProblemSolved, getProblemSolvedDetails } from "../utils/xpManager";

export const getUserXP = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = (req as any).user.id;
    
    const totalXP = await getUserTotalXP(userId);
    const solvedProblems = await getUserSolvedProblems(userId);
    
    res.json({
      success: true,
      data: {
        userId,
        totalXP,
        solvedProblems: solvedProblems.length,
        recentSolves: solvedProblems.slice(0, 10) 
      }
    });
  } catch (error) {
    console.error('Error fetching user XP:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch user XP'
    });
  }
};

export const getUserSolvedProblemsList = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = (req as any).user.id;
    const solvedProblems = await getUserSolvedProblems(userId);
    
    const difficultyCount = {
      easy: 0,
      medium: 0,
      hard: 0
    };
    
    solvedProblems.forEach(problem => {
      if (problem.difficulty === 'easy') {
        difficultyCount.easy++;
      } else if (problem.difficulty === 'medium') {
        difficultyCount.medium++;
      } else if (problem.difficulty === 'hard') {
        difficultyCount.hard++;
      }
    });
    
    res.json({
      success: true,
      data: {
        solvedProblems,
        totalSolved: solvedProblems.length,
        difficultyBreakdown: {
          easy: difficultyCount.easy,
          medium: difficultyCount.medium,
          hard: difficultyCount.hard
        }
      }
    });
  } catch (error) {
    console.error('Error fetching solved problems:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch solved problems'
    });
  }
};

export const checkProblemSolvedByUser = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = (req as any).user.id;
    const { problemId } = req.params;
    
    if (!problemId) {
      res.status(400).json({
        success: false,
        error: 'Problem ID is required'
      });
      return;
    }
    
    const isSolved = await checkProblemSolved(userId, problemId);
    const solvedDetails = isSolved ? await getProblemSolvedDetails(userId, problemId) : null;
    
    res.json({
      success: true,
      data: {
        problemId,
        isSolved,
        solvedDetails
      }
    });
  } catch (error) {
    console.error('Error checking problem solved status:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to check problem solved status'
    });
  }
};