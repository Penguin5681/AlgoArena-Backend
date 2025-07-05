-- This script runs before the schema import
-- It ensures the penguin user exists and has the right permissions

-- Create the penguin user if it doesn't exist (it should already exist from POSTGRES_USER)
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'penguin') THEN
        CREATE ROLE penguin LOGIN PASSWORD '02022005';
    END IF;
END
$$;

-- Grant necessary privileges
ALTER USER penguin CREATEDB;
ALTER USER penguin WITH SUPERUSER;

-- Ensure the database exists
SELECT 'CREATE DATABASE rds_clone OWNER penguin'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'rds_clone')\gexec

-- Connect to the database and grant privileges
\c rds_clone;
GRANT ALL PRIVILEGES ON DATABASE rds_clone TO penguin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO penguin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO penguin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO penguin;

-- Set default privileges for future objects
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO penguin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO penguin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO penguin;
