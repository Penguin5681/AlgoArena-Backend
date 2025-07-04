import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import authRoutes from './routes/auth.routes';
import teamRoutes from './routes/team.routes';
import seedRoutes from "./routes/seed.routes";
import learnRoutes from "./routes/learn.routes";
import codeRoutes from './routes/code.routes';
import { initializeKafka } from './config/kafka';
import { startCodeExecutor } from './workers/codeExecutor';

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/team', teamRoutes);
app.use('/api/admin', seedRoutes);
app.use('/api/learn', learnRoutes);
app.use('/api/code', codeRoutes);

const PORT = process.env.PORT || 5000;
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