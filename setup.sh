#!/bin/bash

echo "🚀 Setting up the development environment..."

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

if [ ! -f "init-db/01-schema.sql" ]; then
    echo "⚠️  Database schema not found. Running export script..."
    if [ -f "export-schema.sh" ]; then
        chmod +x export-schema.sh
        ./export-schema.sh
    else
        echo "❌ export-schema.sh not found. Please run it manually first."
        exit 1
    fi
fi

echo "🧹 Cleaning up existing containers..."
docker-compose down -v

echo "🏗️  Building and starting services..."
docker-compose up --build -d

echo "⏳ Waiting for services to be ready..."
sleep 30

echo "🔍 Checking service status..."
docker-compose ps

echo "🔍 Testing database connection..."
docker-compose exec -T postgres psql -U penguin -d rds_clone -c "SELECT 'Database connection successful!' as status;"

if [ $? -eq 0 ]; then
    echo "✅ Database connection test passed!"
else
    echo "❌ Database connection test failed. Check logs:"
    docker-compose logs postgres
    exit 1
fi


echo "✅ Setup complete!"
echo ""
echo "📊 Service URLs:"
echo "   Backend API: http://localhost:5001"
echo "   PostgreSQL: localhost:5432"
echo "   Kafka: localhost:9092"
echo "   Zookeeper: localhost:2181"
echo ""
echo "🔧 Useful commands:"
echo "   View logs: docker-compose logs -f"
echo "   Stop services: docker-compose down"
echo "   Restart services: docker-compose restart"
echo "   View running containers: docker-compose ps"
echo "   Test database: node test-db-connection.js"
echo "   Connect to database: docker-compose exec postgres psql -U penguin -d rds_clone"