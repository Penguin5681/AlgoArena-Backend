import { Request, Response } from 'express';
import pool from '../config/db';
import fs from 'fs';
import path from 'path';

interface ProblemData {
    title: string;
    slug: string;
    description: string;
    topic: string;
    difficulty: 'easy' | 'medium' | 'hard';
    constraints: string[];
    examples: Array<{
        input: string;
        output: string;
    }>;
    hints: string[];
    time_complexity: string;
    space_complexity: string;
}

export class SeedProblemsController {
    private getXPForDifficulty(difficulty: string): number {
        switch (difficulty) {
            case 'easy': return 10;
            case 'medium': return 25;
            case 'hard': return 50;
            default: return 10;
        }
    }

    private async getOrCreateTopic(topicName: string): Promise<number> {
        const client = await pool.connect();
        try {
            const topicResult = await client.query(
                'SELECT id FROM problem_topics WHERE name = $1',
                [topicName]
            );

            if (topicResult.rows.length > 0) {
                return topicResult.rows[0].id;
            }

            // Create new topic
            const insertResult = await client.query(
                'INSERT INTO problem_topics (name) VALUES ($1) RETURNING id',
                [topicName]
            );
            
            return insertResult.rows[0].id;
        } finally {
            client.release();
        }
    }

    public async seedProblems(req: Request, res: Response): Promise<void> {
        const client = await pool.connect();
        
        try {
            const { filePath } = req.body;
            
            if (!filePath) {
                res.status(400).json({ error: 'File path is required' });
                return;
            }

            // Read JSON file
            const fullPath = path.resolve(filePath);
            
            if (!fs.existsSync(fullPath)) {
                res.status(404).json({ error: 'File not found' });
                return;
            }

            const jsonData = JSON.parse(fs.readFileSync(fullPath, 'utf8'));
            
            if (!Array.isArray(jsonData)) {
                res.status(400).json({ error: 'JSON file must contain an array of problems' });
                return;
            }

            await client.query('BEGIN');

            const seededProblems = [];

            for (const problemData of jsonData as ProblemData[]) {
                try {
                    // Validate required fields
                    if (!problemData.title || !problemData.slug || !problemData.description || 
                            !problemData.difficulty || !problemData.topic) {
                        console.warn(`Skipping problem with missing required fields: ${problemData.title || 'Unknown'}`);
                        continue;
                    }

                    // Get or create topic
                    const topicId = await this.getOrCreateTopic(problemData.topic);

                    // Calculate XP
                    const xp = this.getXPForDifficulty(problemData.difficulty);

                    // Prepare constraints text
                    const constraintsText = Array.isArray(problemData.constraints) 
                        ? problemData.constraints.join('\n') 
                        : problemData.constraints || '';

                    // Insert problem
                    const problemResult = await client.query(`
                        INSERT INTO coding_problems 
                        (id, title, description, constraints, difficulty, time_complexity, space_complexity, hints, xp)
                        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
                        ON CONFLICT (id) DO UPDATE SET
                            title = EXCLUDED.title,
                            description = EXCLUDED.description,
                            constraints = EXCLUDED.constraints,
                            difficulty = EXCLUDED.difficulty,
                            time_complexity = EXCLUDED.time_complexity,
                            space_complexity = EXCLUDED.space_complexity,
                            hints = EXCLUDED.hints,
                            xp = EXCLUDED.xp
                        RETURNING id
                    `, [
                        problemData.slug,
                        problemData.title,
                        problemData.description,
                        constraintsText,
                        problemData.difficulty,
                        problemData.time_complexity || 'O(1)',
                        problemData.space_complexity || 'O(1)',
                        problemData.hints || [],
                        xp
                    ]);

                    const problemId = problemResult.rows[0].id;

                    // Link problem to topic
                    await client.query(`
                        INSERT INTO coding_problem_topics (problem_id, topic_id)
                        VALUES ($1, $2)
                        ON CONFLICT (problem_id, topic_id) DO NOTHING
                    `, [problemId, topicId]);

                    // Insert test cases from examples
                    if (problemData.examples && Array.isArray(problemData.examples)) {
                        for (const example of problemData.examples) {
                            await client.query(`
                                INSERT INTO coding_problem_testcases (problem_id, input, expected_output, is_sample)
                                VALUES ($1, $2, $3, $4)
                            `, [problemId, example.input, example.output, true]);
                        }
                    }

                    seededProblems.push({
                        id: problemId,
                        title: problemData.title,
                        difficulty: problemData.difficulty,
                        topic: problemData.topic
                    });

                } catch (error) {
                    console.error(`Error seeding problem ${problemData.title}:`, error);
                    // Continue with next problem instead of failing entire operation
                }
            }

            await client.query('COMMIT');

            res.json({
                success: true,
                message: `Successfully seeded ${seededProblems.length} problems`,
                seededProblems
            });

        } catch (error) {
            await client.query('ROLLBACK');
            console.error('Error seeding problems:', error);
            res.status(500).json({ 
                error: 'Failed to seed problems',
                details: error instanceof Error ? error.message : 'Unknown error'
            });
        } finally {
            client.release();
        }
    }

    // Controller method to check seeded problems
    public async getProblemStatus(req: Request, res: Response): Promise<void> {
        try {
            const result = await pool.query(`
                SELECT 
                    cp.id,
                    cp.title,
                    cp.difficulty,
                    pt.name as topic,
                    COUNT(cpt.problem_id) as test_case_count
                FROM coding_problems cp
                LEFT JOIN coding_problem_topics cpt_link ON cp.id = cpt_link.problem_id
                LEFT JOIN problem_topics pt ON cpt_link.topic_id = pt.id
                LEFT JOIN coding_problem_testcases cpt ON cp.id = cpt.problem_id
                GROUP BY cp.id, cp.title, cp.difficulty, pt.name
                ORDER BY cp.created_at DESC
            `);

            res.json({
                totalProblems: result.rows.length,
                problems: result.rows
            });
        } catch (error) {
            console.error('Error fetching seeded problems:', error);
            res.status(500).json({ error: 'Failed to fetch problems status' });
        }
    }
}