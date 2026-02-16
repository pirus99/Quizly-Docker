# Coderr Docker Deployment - Quick Start
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Coderr Docker Deployment - Quick Start" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check if .env exists
if (-not (Test-Path .env)) {
    Write-Host "⚙️  Creating .env file from .env.example..." -ForegroundColor Yellow
    Copy-Item .env.example .env
    
    # Generate Django secret key
    Write-Host "🔑 Generating Django secret key..." -ForegroundColor Yellow
    $secretKey = docker run --rm python:3.11 python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
    
    # Update .env file with generated secret key
    (Get-Content .env) -replace 'DJANGO_SECRET_KEY=change-me-to-a-secure-random-string-in-production', "DJANGO_SECRET_KEY=$secretKey" | Set-Content .env
    
    Write-Host "✅ .env file created with generated secret key" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  IMPORTANT: Please edit .env and update POSTGRES_PASSWORD before deploying to production!" -ForegroundColor Red
    Write-Host ""
} else {
    Write-Host "✅ .env file already exists" -ForegroundColor Green
    Write-Host ""
}

# Prompt to continue
Write-Host "Press Enter to start deployment or Ctrl+C to cancel..." -ForegroundColor Yellow
Read-Host

# Build and start containers
Write-Host ""
Write-Host "🐳 Building and starting Docker containers..." -ForegroundColor Cyan
docker-compose up -d --build

Write-Host ""
Write-Host "⏳ Waiting for services to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Check service health
Write-Host ""
Write-Host "🔍 Checking service status..." -ForegroundColor Cyan
docker-compose ps

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "✅ Deployment Complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "🌍 Access your application:" -ForegroundColor Cyan
Write-Host "   Frontend:      http://localhost" -ForegroundColor White
Write-Host "   Django Admin:  http://localhost/admin/" -ForegroundColor White
Write-Host "   API:           http://localhost/api/" -ForegroundColor White
Write-Host ""
Write-Host "📋 Useful commands:" -ForegroundColor Cyan
Write-Host "   View logs:           docker-compose logs -f" -ForegroundColor White
Write-Host "   Stop services:       docker-compose down" -ForegroundColor White
Write-Host "   Restart services:    docker-compose restart" -ForegroundColor White
Write-Host "   Create superuser:    docker-compose exec backend python manage.py createsuperuser" -ForegroundColor White
Write-Host ""
Write-Host "📖 For more information, see DEPLOYMENT.md" -ForegroundColor Cyan
Write-Host ""
