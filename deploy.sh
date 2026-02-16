#!/bin/bash

echo "========================================="
echo "Coderr Docker Deployment - Quick Start"
echo "========================================="
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚙️  Creating .env file from .env.example..."
    cp .env.example .env
    
    # Generate Django secret key
    echo "🔑 Generating Django secret key..."
    SECRET_KEY=$(docker run --rm python:3.11 python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())')
    
    # Update .env file with generated secret key (cross-platform sed)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s|DJANGO_SECRET_KEY=change-me-to-a-secure-random-string-in-production|DJANGO_SECRET_KEY=$SECRET_KEY|g" .env
    else
        # Linux
        sed -i "s|DJANGO_SECRET_KEY=change-me-to-a-secure-random-string-in-production|DJANGO_SECRET_KEY=$SECRET_KEY|g" .env
    fi
    
    echo "✅ .env file created with generated secret key"
    echo ""
    echo "⚠️  IMPORTANT: Please edit .env and update POSTGRES_PASSWORD before deploying to production!"
    echo ""
else
    echo "✅ .env file already exists"
    echo ""
fi

# Prompt to continue
read -p "Press Enter to start deployment or Ctrl+C to cancel..."

# Build and start containers
echo ""
echo "🐳 Building and starting Docker containers..."
docker-compose up -d --build

echo ""
echo "⏳ Waiting for services to start..."
sleep 10

# Check service health
echo ""
echo "🔍 Checking service status..."
docker-compose ps

echo ""
echo "========================================="
echo "✅ Deployment Complete!"
echo "========================================="
echo ""
echo "🌍 Access your application:"
echo "   Frontend:      http://localhost"
echo "   Django Admin:  http://localhost/admin/"
echo "   API:           http://localhost/api/"
echo ""
echo "📋 Useful commands:"
echo "   View logs:           docker-compose logs -f"
echo "   Stop services:       docker-compose down"
echo "   Restart services:    docker-compose restart"
echo "   Create superuser:    docker-compose exec backend python manage.py createsuperuser"
echo ""
echo "📖 For more information, see DEPLOYMENT.md"
echo ""
