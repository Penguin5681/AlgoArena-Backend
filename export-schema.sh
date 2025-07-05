#!/bin/bash

DB_NAME="rds_clone"
DB_USER="thechillguy69"
DB_HOST="localhost"
DB_PORT="5432"
DB_PASSWORD="02022005"

mkdir -p init-db

echo "Exporting PostgreSQL schema and data..."
export PGPASSWORD="$DB_PASSWORD"

pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME \
  --no-owner \
  --no-privileges \
  --clean \
  --if-exists \
  > init-db/01-schema.sql

if [ $? -eq 0 ]; then
    echo "✅ Schema exported to init-db/01-schema.sql"
    echo "This file will be automatically executed when PostgreSQL container starts"
    echo ""
    echo "Files in init-db directory:"
    ls -la init-db/
else
    echo "❌ Error exporting schema. Please check your database connection."
    echo "Make sure PostgreSQL is running and credentials are correct."
fi

unset PGPASSWORD