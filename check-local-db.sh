#!/bin/bash

echo "🔍 Checking local PostgreSQL setup..."

# Check if PostgreSQL is running
if ! pgrep -x "postgres" > /dev/null; then
    echo "❌ PostgreSQL is not running locally."
    echo "Please start PostgreSQL first."
    exit 1
fi

echo "✅ PostgreSQL is running"

# Try to connect as default user (usually postgres or your system user)
echo ""
echo "🔍 Checking available databases and users..."

# Try different common users
for user in postgres $USER penguin; do
    echo "Trying user: $user"
    
    # List databases
    PGPASSWORD="02022005" psql -h localhost -U $user -l 2>/dev/null || \
    psql -h localhost -U $user -l 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully connected as user: $user"
        echo ""
        echo "📊 Available databases:"
        PGPASSWORD="02022005" psql -h localhost -U $user -l 2>/dev/null || \
        psql -h localhost -U $user -l 2>/dev/null
        
        echo ""
        echo "👥 Available users/roles:"
        PGPASSWORD="02022005" psql -h localhost -U $user -c "\du" 2>/dev/null || \
        psql -h localhost -U $user -c "\du" 2>/dev/null
        
        echo ""
        echo "🎯 To export database 'rds_clone' with user '$user', use:"
        echo "   PGPASSWORD='02022005' pg_dump -h localhost -U $user -d rds_clone > init-db/01-schema.sql"
        echo "   OR"
        echo "   pg_dump -h localhost -U $user -d rds_clone > init-db/01-schema.sql"
        
        break
    else
        echo "❌ Failed to connect as user: $user"
    fi
    echo ""
done

echo ""
echo "💡 If none of the above worked, try:"
echo "1. Connect to PostgreSQL as superuser: sudo -u postgres psql"
echo "2. Check what databases exist: \\l"
echo "3. Check what users exist: \\du"
echo "4. Find the correct database name that contains your tables"
