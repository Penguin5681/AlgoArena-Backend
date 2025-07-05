@echo off
setlocal enabledelayedexpansion

echo 🚀 Setting up the development environment...

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker Desktop first.
    pause
    exit /b 1
)

REM Check if Docker Compose is installed
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose is not installed. Please install Docker Compose first.
    pause
    exit /b 1
)

REM Check if schema export exists
if not exist "init-db\01-schema.sql" (
    echo ⚠️  Database schema not found. Running export script...
    if exist "export-schema.bat" (
        call export-schema.bat
    ) else if exist "export-schema.sh" (
        echo ⚠️  Found export-schema.sh but this is Windows. Converting to batch...
        echo Please run export-schema.sh manually in WSL or Git Bash, or create export-schema.bat
        pause
        exit /b 1
    ) else (
        echo ❌ export-schema.bat not found. Please run it manually first.
        pause
        exit /b 1
    )
)

REM Stop and remove existing containers
echo 🧹 Cleaning up existing containers...
docker-compose down -v

REM Build and start services
echo 🏗️  Building and starting services...
docker-compose up --build -d

echo ⏳ Waiting for services to be ready...
timeout /t 30 /nobreak >nul

REM Check if services are running
echo 🔍 Checking service status...
docker-compose ps

REM Test database connection
echo 🔍 Testing database connection...
docker-compose exec -T postgres psql -U penguin -d rds_clone -c "SELECT 'Database connection successful!' as status;"

if %errorlevel% equ 0 (
    echo ✅ Database connection test passed!
) else (
    echo ❌ Database connection test failed. Check logs:
    docker-compose logs postgres
    pause
    exit /b 1
)

echo ✅ Setup complete!
echo.
echo 📊 Service URLs:
echo    Backend API: http://localhost:5001
echo    PostgreSQL: localhost:5432
echo    Kafka: localhost:9092
echo    Zookeeper: localhost:2181
echo.
echo 🔧 Useful commands:
echo    View logs: docker-compose logs -f
echo    Stop services: docker-compose down
echo    Restart services: docker-compose restart
echo    View running containers: docker-compose ps
echo    Test database: node test-db-connection.js
echo    Connect to database: docker-compose exec postgres psql -U penguin -d rds_clone
echo.
echo Press any key to exit...
pause >nul