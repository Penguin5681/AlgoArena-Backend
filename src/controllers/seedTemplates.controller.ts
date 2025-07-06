import { Request, Response } from 'express';
import pool from '../config/db';
import fs from 'fs';
import path from 'path';

export class SeedTemplatesController {
  
  // Get template for a specific problem and language
  public async getTemplate(req: Request, res: Response): Promise<void> {
    try {
      const { problemId, language } = req.params;

      if (!problemId || !language) {
        res.status(400).json({ 
          success: false, 
          error: 'Problem ID and language are required' 
        });
        return;
      }

      const result = await pool.query(
        'SELECT * FROM coding_problem_templates WHERE problem_id = $1 AND language = $2',
        [problemId, language]
      );

      if (result.rows.length === 0) {
        res.status(404).json({ 
          success: false, 
          error: 'Template not found' 
        });
        return;
      }

      const template = result.rows[0];
      
      // Return template in base64 format
      const templateCode = template.is_base64_encoded 
        ? template.template 
        : Buffer.from(template.template).toString('base64');

      res.json({
        success: true,
        data: {
          id: template.id,
          problemId: template.problem_id,
          language: template.language,
          template: templateCode,
          isBase64Encoded: true,
          createdAt: template.created_at
        }
      });

    } catch (error) {
      console.error('Error fetching template:', error);
      res.status(500).json({ 
        success: false, 
        error: 'Failed to fetch template' 
      });
    }
  }

  // Get all templates for a specific problem
  public async getProblemTemplates(req: Request, res: Response): Promise<void> {
    try {
      const { problemId } = req.params;

      if (!problemId) {
        res.status(400).json({ 
          success: false, 
          error: 'Problem ID is required' 
        });
        return;
      }

      const result = await pool.query(
        'SELECT * FROM coding_problem_templates WHERE problem_id = $1',
        [problemId]
      );

      const templates = result.rows.map(template => ({
        id: template.id,
        problemId: template.problem_id,
        language: template.language,
        template: template.is_base64_encoded 
          ? template.template 
          : Buffer.from(template.template).toString('base64'),
        isBase64Encoded: true,
        createdAt: template.created_at
      }));

      res.json({
        success: true,
        data: {
          templates
        }
      });

    } catch (error) {
      console.error('Error fetching templates:', error);
      res.status(500).json({ 
        success: false, 
        error: 'Failed to fetch templates' 
      });
    }
  }

  // Create or update a template
  public async createOrUpdateTemplate(req: Request, res: Response): Promise<void> {
    try {
      const { problemId, language } = req.params;
      let { template, isBase64Encoded = false } = req.body;

      if (!problemId || !language || !template) {
        res.status(400).json({ 
          success: false, 
          error: 'Problem ID, language, and template are required' 
        });
        return;
      }

      // Verify problem exists
      const problemResult = await pool.query(
        'SELECT id FROM coding_problems WHERE id = $1',
        [problemId]
      );

      if (problemResult.rows.length === 0) {
        res.status(404).json({ 
          success: false, 
          error: 'Problem not found' 
        });
        return;
      }

      // Check if template already exists
      const existingTemplate = await pool.query(
        'SELECT id FROM coding_problem_templates WHERE problem_id = $1 AND language = $2',
        [problemId, language]
      );

      let result;
      if (existingTemplate.rows.length > 0) {
        // Update existing template
        result = await pool.query(
          `UPDATE coding_problem_templates 
           SET template = $1, is_base64_encoded = $2 
           WHERE problem_id = $3 AND language = $4
           RETURNING *`,
          [template, isBase64Encoded, problemId, language]
        );
      } else {
        // Create new template
        result = await pool.query(
          `INSERT INTO coding_problem_templates (problem_id, language, template, is_base64_encoded)
           VALUES ($1, $2, $3, $4)
           RETURNING *`,
          [problemId, language, template, isBase64Encoded]
        );
      }

      const savedTemplate = result.rows[0];
      
      res.json({
        success: true,
        data: {
          id: savedTemplate.id,
          problemId: savedTemplate.problem_id,
          language: savedTemplate.language,
          template: isBase64Encoded 
            ? savedTemplate.template 
            : Buffer.from(savedTemplate.template).toString('base64'),
          isBase64Encoded: true,
          createdAt: savedTemplate.created_at
        }
      });

    } catch (error) {
      console.error('Error saving template:', error);
      res.status(500).json({ 
        success: false, 
        error: 'Failed to save template' 
      });
    }
  }

  // Seed templates from a JSON file
  public async seedTemplatesFromFile(req: Request, res: Response): Promise<void> {
    try {
      const { filePath } = req.body;

      if (!filePath) {
        res.status(400).json({ 
          success: false, 
          error: 'File path is required' 
        });
        return;
      }

      const fullPath = path.resolve(filePath);
      
      // Check if file exists
      if (!fs.existsSync(fullPath)) {
        res.status(404).json({ 
          success: false, 
          error: 'File not found' 
        });
        return;
      }

      // Read and parse JSON file
      const fileContent = fs.readFileSync(fullPath, 'utf8');
      const templates = JSON.parse(fileContent);

      if (!Array.isArray(templates)) {
        res.status(400).json({ 
          success: false, 
          error: 'Invalid file format. Expected an array of templates.' 
        });
        return;
      }

      const results = await this.processSeedTemplates(templates);
      
      res.json({
        success: true,
        data: {
          message: 'Templates seeded successfully',
          summary: results
        }
      });

    } catch (error) {
      console.error('Error seeding templates:', error);
      res.status(500).json({ 
        success: false, 
        error: 'Failed to seed templates',
        details: error instanceof Error ? error.message : String(error)
      });
    }
  }

  // Seed templates directly from request body
  public async seedTemplatesFromBody(req: Request, res: Response): Promise<void> {
    try {
      const { templates } = req.body;

      if (!templates || !Array.isArray(templates)) {
        res.status(400).json({ 
          success: false, 
          error: 'Templates array is required' 
        });
        return;
      }

      const results = await this.processSeedTemplates(templates);
      
      res.json({
        success: true,
        data: {
          message: 'Templates seeded successfully',
          summary: results
        }
      });

    } catch (error) {
      console.error('Error seeding templates:', error);
      res.status(500).json({ 
        success: false, 
        error: 'Failed to seed templates',
        details: error instanceof Error ? error.message : String(error)
      });
    }
  }

  // Helper method to process templates seeding
  private async processSeedTemplates(templates: any[]): Promise<any> {
    const results: {
      successful: number;
      failed: number;
      errors: string[];
    } = {
      successful: 0,
      failed: 0,
      errors: []
    };

    // Begin transaction
    const client = await pool.connect();
    try {
      await client.query('BEGIN');

      for (const template of templates) {
        const { problemId, language, template: code, isBase64Encoded = false } = template;
        
        if (!problemId || !language || !code) {
          results.failed++;
          results.errors.push(`Missing required fields for template: ${JSON.stringify(template)}`);
          continue;
        }

        // Check if problem exists
        const problemCheck = await client.query(
          'SELECT id FROM coding_problems WHERE id = $1',
          [problemId]
        );

        if (problemCheck.rows.length === 0) {
          results.failed++;
          results.errors.push(`Problem with ID ${problemId} does not exist`);
          continue;
        }

        // Check if template already exists
        const existingTemplate = await client.query(
          'SELECT id FROM coding_problem_templates WHERE problem_id = $1 AND language = $2',
          [problemId, language]
        );

        if (existingTemplate.rows.length > 0) {
          // Update existing template
          await client.query(
            `UPDATE coding_problem_templates 
             SET template = $1, is_base64_encoded = $2 
             WHERE problem_id = $3 AND language = $4`,
            [code, isBase64Encoded, problemId, language]
          );
        } else {
          // Create new template
          await client.query(
            `INSERT INTO coding_problem_templates (problem_id, language, template, is_base64_encoded)
             VALUES ($1, $2, $3, $4)`,
            [problemId, language, code, isBase64Encoded]
          );
        }

        results.successful++;
      }

      await client.query('COMMIT');
      return results;

    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }

  // Delete a template
  public async deleteTemplate(req: Request, res: Response): Promise<void> {
    try {
      const { problemId, language } = req.params;

      if (!problemId || !language) {
        res.status(400).json({ 
          success: false, 
          error: 'Problem ID and language are required' 
        });
        return;
      }

      const result = await pool.query(
        'DELETE FROM coding_problem_templates WHERE problem_id = $1 AND language = $2 RETURNING id',
        [problemId, language]
      );

      if (result.rows.length === 0) {
        res.status(404).json({ 
          success: false, 
          error: 'Template not found' 
        });
        return;
      }

      res.json({
        success: true,
        message: 'Template deleted successfully'
      });

    } catch (error) {
      console.error('Error deleting template:', error);
      res.status(500).json({ 
        success: false, 
        error: 'Failed to delete template' 
      });
    }
  }
}