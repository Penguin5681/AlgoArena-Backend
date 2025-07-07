import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import morgan from 'morgan';
import authRoutes from './routes/auth.routes';
import teamRoutes from './routes/team.routes';
import seedRoutes from "./routes/seed.routes";
import learnRoutes from "./routes/learn.routes";
import codeRoutes from './routes/code.routes';
import healthRoutes from './routes/health.routes';
import adminRoutes from './routes/admin.routes';
import seedProblemRoutes from './routes/seedProblems.routes';
import { initializeKafka } from './config/kafka';
import { startCodeExecutor } from './workers/codeExecutor';
import codeExecutionRoutes from './routes/codeExecution.routes';
import analysisRoutes from './routes/analysis.routes';

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

if (process.env.NODE_ENV === 'development') {
    morgan.token('body', (req: any) => {
        if (['POST', 'PUT', 'PATCH'].includes(req.method) && req.body) {
            const sanitizedBody = { ...req.body };
            const sensitiveFields = ['password', 'token', 'secret', 'key'];
            sensitiveFields.forEach(field => {
                if (sanitizedBody[field]) {
                    sanitizedBody[field] = '***HIDDEN***';
                }
            });
            return JSON.stringify(sanitizedBody);
        }
        return '';
    });

    const logFormat = '🌐 :method :url | Status: :status | :response-time ms | IP: :remote-addr | Body: :body';
    
    app.use(morgan(logFormat));
}

app.use('/api/auth', authRoutes);
app.use('/api/team', teamRoutes);
app.use('/api/admin', seedRoutes);
app.use('/api/learn', learnRoutes);
app.use('/api/code', codeRoutes);
app.use('/api/admin', adminRoutes)
app.use('/api/seed', seedProblemRoutes);
app.use('/api/code-execution', codeExecutionRoutes);
app.use('/api/analysis', analysisRoutes);
app.use('/', healthRoutes);

const PORT = 5001;

const startServer = async () => {
    try {
        await initializeKafka();
        await startCodeExecutor();
        app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
    } catch (error) {
        console.error('Failed to start server:', error);
        process.exit(1);
    }
};

startServer();