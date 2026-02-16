@echo off
setlocal enabledelayedexpansion

echo =========================================
echo Coderr Docker Deployment - Quick Start
echo =========================================
echo.

REM Check if .env exists
if not exist .env (
    echo Creating .env file from .env.example...
    copy .env.example .env >nul
    
    echo Generating Django secret key...
    for /f "delims=" %%i in ('docker run --rm python:3.11 python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"') do set SECRET_KEY=%%i
    
    REM Update .env file with generated secret key
    powershell -Command "(Get-Content .env) -replace 'DJANGO_SECRET_KEY=change-me-to-a-secure-random-string-in-production', 'DJANGO_SECRET_KEY=!SECRET_KEY!' | Set-Content .env"
    
    echo .env file created with generated secret key
    echo.
    echo WARNING: Please edit .env and update POSTGRES_PASSWORD before deploying to production!
    echo.
) else (
    echo .env file already exists
    echo.
)

REM Prompt to continue
pause

REM Build and start containers
echo.
echo Building and starting Docker containers...
docker-compose up -d --build

echo.
echo Waiting for services to start...
timeout /t 10 /nobreak >nul

REM Check service health
echo.
echo Checking service status...
docker-compose ps

echo.
echo =========================================
echo Deployment Complete!
echo =========================================
echo.
echo Access your application:
echo    Frontend:      http://localhost
echo    Django Admin:  http://localhost/admin/
echo    API:           http://localhost/api/
echo.
echo Useful commands:
echo    View logs:           docker-compose logs -f
echo    Stop services:       docker-compose down
echo    Restart services:    docker-compose restart
echo    Create superuser:    docker-compose exec backend python manage.py createsuperuser
echo.
echo For more information, see DEPLOYMENT.md
echo.

pause
