#!/bin/bash

echo "🚀 Setting up the development environment..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if schema export exists
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

# Stop and remove existing containers
echo "🧹 Cleaning up existing containers..."
docker-compose down -v

# Build and start services
echo "🏗️  Building and starting services..."
docker-compose up --build -d

echo "⏳ Waiting for services to be ready..."
sleep 30

# Check if services are running
echo "🔍 Checking service status..."
docker-compose ps

# Test database connection
echo "🔍 Testing database connection..."
docker-compose exec -T postgres psql -U penguin -d rds_clone -c "SELECT 'Database connection successful!' as status;"

if [ $? -eq 0 ]; then
    echo "✅ Database connection test passed!"
else
    echo "❌ Database connection test failed. Check logs:"
    docker-compose logs postgres
    exit 1
fi

echo "🤖 Initializing Ollama models (this might take a few minutes)..."
docker-compose exec -T ollama ollama pull tinyllama

if [ $? -eq 0 ]; then
    echo "✅ Ollama model (tinyllama) pulled successfully!"
else
    echo "⚠️ Failed to pull tinyllama, trying alternative..."
    docker-compose exec -T ollama ollama pull tinyllama
    echo "✅ Ollama setup complete with tinyllama!"
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