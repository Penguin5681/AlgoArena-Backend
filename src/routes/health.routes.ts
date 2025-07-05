import express from 'express';
import pool from '../config/db';

const router = express.Router();

// Debug endpoint that doesn't require DB
router.get('/debug', (req, res) => {
    console.log('Debug endpoint called!');
    res.status(200).json({
        status: 'debug endpoint reached',
        timestamp: new Date().toISOString()
    });
});

router.get('/health', async (req, res) => {
    try {
        await pool.query('SELECT 1');
        
        res.status(200).json({
            status: 'healthy',
            timestamp: new Date().toISOString(),
            services: {
                database: 'connected',
                server: 'running'
            }
        });
    } catch (error) {
        res.status(503).json({
            status: 'unhealthy',
            timestamp: new Date().toISOString(),
            error: error instanceof Error ? error.message : 'Unknown error'
        });
    }
});

export default router;