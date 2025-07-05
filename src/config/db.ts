import dotenv from 'dotenv'
import {Pool} from 'pg';

dotenv.config();

const isDocker = process.env.DEV_DB_URL?.includes('@postgres:');

const pool = new Pool({
    connectionString: process.env.DEV_DB_URL,
    ssl: isDocker ? false : {
        rejectUnauthorized: false,
    }
});

export default pool;