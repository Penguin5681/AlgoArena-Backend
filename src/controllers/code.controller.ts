import { Request, Response } from "express";
import pool from "../config/db";
import { producer } from "../config/kafka";

export const createCodeSubmission = async (req: Request, res: Response) => {
    const { code, language, stdin, userId } = req.body;
    
    try {
        if (!code || !language || !userId) {
            return res.status(400).json({ 
                error: 'Missing required fields: code, language, userId' 
            });
        }

        const query = `
            INSERT INTO submissions (user_id, language, code, stdin, status, created_at)
            VALUES ($1, $2, $3, $4, $5, NOW())
            RETURNING submission_id
        `;
        
        const values = [userId, language, code, stdin || null, 'queued'];
        const result = await pool.query(query, values);
        
        const submissionId = result.rows[0].submission_id;

        await producer.send({
            topic: "code_submissions",
            messages: [{
                value: JSON.stringify({
                    submissionId,
                    language,
                    code,
                    stdin: stdin || null
                })
            }]
        });

        res.status(201).json({
            submissionId
        });

    } catch (error) {
        console.error('Error creating code submission:', error);
        res.status(500).json({ 
            error: 'Internal server error' 
        });
    }
};

export const getSubmissionResult = async (req: Request, res: Response) => {
    const { submissionId } = req.params;
    
    try {
        const query = `
            SELECT submission_id, status, stdout, stderr, execution_time, memory_usage, created_at, updated_at
            FROM submissions 
            WHERE submission_id = $1
        `;
        
        const result = await pool.query(query, [submissionId]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({ 
                error: 'Submission not found' 
            });
        }
        
        const submission = result.rows[0];
        
        res.json({
            id: submission.submission_id,
            status: submission.status,
            stdout: submission.stdout,
            stderr: submission.stderr,
            executionTime: submission.execution_time,
            memoryUsage: submission.memory_usage,
            createdAt: submission.created_at,
            updatedAt: submission.updated_at
        });
        
    } catch (error) {
        console.error('Error fetching submission result:', error);
        res.status(500).json({ 
            error: 'Internal server error' 
        });
    }
};