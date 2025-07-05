# PowerShell Setup Script for AlgoArena Backend

param(
    [switch]$SkipPause = $false
)

# Function to pause if not running in automated mode
function Pause-IfInteractive {
    if (-not $SkipPause) {
        Write-Host "Press any key to continue..." -ForegroundColor Yellow
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        Write-Host ""
    }
}

# Function to pause on error
function Pause-OnError {
    if (-not $SkipPause) {
        Write-Host "Press any key to exit..." -ForegroundColor Red
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

Write-Host "🚀 Setting up the development environment..." -ForegroundColor Green
Write-Host ""

# Check if Docker is installed
Write-Host "🔍 Checking Docker installation..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker is installed: $dockerVersion" -ForegroundColor Green
    } else {
        throw "Docker not found"
    }
} catch {
    Write-Host "❌ Docker is not installed. Please install Docker Desktop first." -ForegroundColor Red
    Write-Host "   Download from: https://www.docker.com/products/docker-desktop" -ForegroundColor Cyan
    Pause-OnError
    exit 1
}

# Check if Docker Compose is installed
Write-Host "🔍 Checking Docker Compose installation..." -ForegroundColor Yellow
try {
    $composeVersion = docker-compose --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker Compose is installed: $composeVersion" -ForegroundColor Green
    } else {
        throw "Docker Compose not found"
    }
} catch {
    Write-Host "❌ Docker Compose is not installed. Please install Docker Compose first." -ForegroundColor Red
    Write-Host "   Usually comes with Docker Desktop on Windows" -ForegroundColor Cyan
    Pause-OnError
    exit 1
}

# Check if Docker Desktop is running
Write-Host "🔍 Checking if Docker Desktop is running..." -ForegroundColor Yellow
try {
    docker info | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker Desktop is running" -ForegroundColor Green
    } else {
        throw "Docker Desktop not running"
    }
} catch {
    Write-Host "❌ Docker Desktop is not running. Please start Docker Desktop first." -ForegroundColor Red
    Pause-OnError
    exit 1
}

# Check if schema export exists
Write-Host "🔍 Checking for database schema..." -ForegroundColor Yellow
if (!(Test-Path "init-db\01-schema.sql")) {
    Write-Host "⚠️  Database schema not found. Looking for export script..." -ForegroundColor Yellow
    
    if (Test-Path "export-schema.ps1") {
        Write-Host "📜 Running export-schema.ps1..." -ForegroundColor Yellow
        try {
            & .\export-schema.ps1
            if ($LASTEXITCODE -ne 0) {
                throw "Export script failed"
            }
        } catch {
            Write-Host "❌ Failed to run export-schema.ps1" -ForegroundColor Red
            Pause-OnError
            exit 1
        }
    } elseif (Test-Path "export-schema.bat") {
        Write-Host "📜 Running export-schema.bat..." -ForegroundColor Yellow
        try {
            & cmd /c "export-schema.bat"
            if ($LASTEXITCODE -ne 0) {
                throw "Export script failed"
            }
        } catch {
            Write-Host "❌ Failed to run export-schema.bat" -ForegroundColor Red
            Pause-OnError
            exit 1
        }
    } elseif (Test-Path "export-schema.sh") {
        Write-Host "⚠️  Found export-schema.sh but this is Windows." -ForegroundColor Yellow
        Write-Host "   Please run export-schema.sh manually in WSL or Git Bash," -ForegroundColor Cyan
        Write-Host "   or create export-schema.ps1 or export-schema.bat" -ForegroundColor Cyan
        Pause-OnError
        exit 1
    } else {
        Write-Host "❌ No export schema script found. Please create the database schema manually." -ForegroundColor Red
        Write-Host "   Expected: export-schema.ps1, export-schema.bat, or export-schema.sh" -ForegroundColor Cyan
        Pause-OnError
        exit 1
    }
} else {
    Write-Host "✅ Database schema found: init-db\01-schema.sql" -ForegroundColor Green
}

Write-Host ""

# Stop and remove existing containers
Write-Host "🧹 Cleaning up existing containers..." -ForegroundColor Yellow
try {
    docker-compose down -v
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Cleanup completed" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Cleanup had warnings (this is normal if no containers were running)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Failed to clean up containers" -ForegroundColor Red
    Pause-OnError
    exit 1
}

# Build and start services
Write-Host "🏗️  Building and starting services..." -ForegroundColor Yellow
Write-Host "   This may take a few minutes on first run..." -ForegroundColor Cyan
try {
    docker-compose up --build -d
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Services started successfully" -ForegroundColor Green
    } else {
        throw "Failed to start services"
    }
} catch {
    Write-Host "❌ Failed to build and start services" -ForegroundColor Red
    Write-Host "   Check the logs above for details" -ForegroundColor Cyan
    Pause-OnError
    exit 1
}

# Wait for services to be ready
Write-Host "⏳ Waiting for services to be ready..." -ForegroundColor Yellow
Write-Host "   Please wait 30 seconds..." -ForegroundColor Cyan
Start-Sleep -Seconds 30

# Check if services are running
Write-Host "🔍 Checking service status..." -ForegroundColor Yellow
try {
    $serviceStatus = docker-compose ps
    Write-Host $serviceStatus -ForegroundColor White
} catch {
    Write-Host "❌ Failed to check service status" -ForegroundColor Red
}

# Test database connection
Write-Host "🔍 Testing database connection..." -ForegroundColor Yellow
try {
    $dbTest = docker-compose exec -T postgres psql -U penguin -d rds_clone -c "SELECT 'Database connection successful!' as status;" 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Database connection test passed!" -ForegroundColor Green
        Write-Host $dbTest -ForegroundColor White
    } else {
        throw "Database connection failed"
    }
} catch {
    Write-Host "❌ Database connection test failed. Checking logs..." -ForegroundColor Red
    Write-Host "--- PostgreSQL Logs ---" -ForegroundColor Yellow
    docker-compose logs postgres
    Write-Host "--- End of PostgreSQL Logs ---" -ForegroundColor Yellow
    Pause-OnError
    exit 1
}

Write-Host ""
Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host ""

# Display service information
Write-Host "📊 Service URLs:" -ForegroundColor Cyan
Write-Host "   🌐 Backend API: " -NoNewline -ForegroundColor White
Write-Host "http://localhost:5001" -ForegroundColor Green
Write-Host "   🗄️  PostgreSQL: " -NoNewline -ForegroundColor White
Write-Host "localhost:5432" -ForegroundColor Green
Write-Host "   📨 Kafka: " -NoNewline -ForegroundColor White
Write-Host "localhost:9092" -ForegroundColor Green
Write-Host "   🔗 Zookeeper: " -NoNewline -ForegroundColor White
Write-Host "localhost:2181" -ForegroundColor Green
Write-Host ""

# Display useful commands
Write-Host "🔧 Useful commands:" -ForegroundColor Cyan
Write-Host "   View logs: " -NoNewline -ForegroundColor White
Write-Host "docker-compose logs -f" -ForegroundColor Yellow
Write-Host "   Stop services: " -NoNewline -ForegroundColor White
Write-Host "docker-compose down" -ForegroundColor Yellow
Write-Host "   Restart services: " -NoNewline -ForegroundColor White
Write-Host "docker-compose restart" -ForegroundColor Yellow
Write-Host "   View running containers: " -NoNewline -ForegroundColor White
Write-Host "docker-compose ps" -ForegroundColor Yellow
Write-Host "   Test database: " -NoNewline -ForegroundColor White
Write-Host "node test-db-connection.js" -ForegroundColor Yellow
Write-Host "   Connect to database: " -NoNewline -ForegroundColor White
Write-Host "docker-compose exec postgres psql -U penguin -d rds_clone" -ForegroundColor Yellow
Write-Host ""

# Test API endpoint
Write-Host "🔍 Testing API endpoint..." -ForegroundColor Yellow
try {
    Start-Sleep -Seconds 5  # Give the API a moment to start
    $apiResponse = Invoke-WebRequest -Uri "http://localhost:5001/api/health" -Method GET -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
    if ($apiResponse.StatusCode -eq 200) {
        Write-Host "✅ API is responding on http://localhost:5001" -ForegroundColor Green
    } else {
        Write-Host "⚠️  API responded with status code: $($apiResponse.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️  API endpoint test failed. The API might still be starting up." -ForegroundColor Yellow
    Write-Host "   Try accessing http://localhost:5001/api/health in a few minutes" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "🎉 Development environment is ready!" -ForegroundColor Green
Write-Host ""

if (-not $SkipPause) {
    Write-Host "Press any key to exit..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}