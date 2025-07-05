// Test database connection script
import pkg from 'pg';
const { Pool } = pkg;

// Test connection to Docker PostgreSQL
const testConnection = async () => {
    const pool = new Pool({
        connectionString: 'postgres://penguin:02022005@localhost:5432/rds_clone',
        ssl: false // No SSL for Docker
    });

    try {
        console.log('🔍 Testing database connection...');
        
        // Test basic connection
        const client = await pool.connect();
        console.log('✅ Successfully connected to PostgreSQL');
        
        // Test database exists
        const dbResult = await client.query('SELECT current_database()');
        console.log(`📊 Connected to database: ${dbResult.rows[0].current_database}`);
        
        // Test user
        const userResult = await client.query('SELECT current_user');
        console.log(`👤 Connected as user: ${userResult.rows[0].current_user}`);
        
        // List tables
        const tablesResult = await client.query(`
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public'
        `);
        
        console.log(`📋 Found ${tablesResult.rows.length} tables in public schema:`);
        tablesResult.rows.forEach(row => {
            console.log(`   - ${row.table_name}`);
        });
        
        client.release();
        await pool.end();
        
        console.log('🎉 Database connection test completed successfully!');
        
    } catch (error) {
        console.error('❌ Database connection failed:', error.message);
        console.error('\n🔧 Troubleshooting steps:');
        console.error('1. Make sure Docker containers are running: docker-compose ps');
        console.error('2. Check PostgreSQL logs: docker-compose logs postgres');
        console.error('3. Verify the database was initialized: docker-compose exec postgres psql -U penguin -d rds_clone -c "\\dt"');
        process.exit(1);
    }
};

testConnection();