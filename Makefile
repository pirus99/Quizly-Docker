.PHONY: help build up down restart logs clean migrate superuser shell

# Default target
help:
	@echo "Coderr Docker Deployment - Available Commands"
	@echo "=============================================="
	@echo ""
	@echo "  make build        - Build all containers"
	@echo "  make up           - Start all services"
	@echo "  make down         - Stop all services"
	@echo "  make restart      - Restart all services"
	@echo "  make logs         - View logs (all services)"
	@echo "  make logs-backend - View backend logs"
	@echo "  make logs-frontend- View frontend logs"
	@echo "  make migrate      - Run Django migrations"
	@echo "  make superuser    - Create Django superuser"
	@echo "  make shell        - Open Django shell"
	@echo "  make clean        - Stop and remove all containers & volumes"
	@echo "  make rebuild      - Clean, rebuild and start"
	@echo "  make status       - Show service status"
	@echo ""

# Build containers
build:
	docker-compose build

# Start services
up:
	docker-compose up -d

# Stop services
down:
	docker-compose down

# Restart services
restart:
	docker-compose restart

# View logs
logs:
	docker-compose logs -f

logs-backend:
	docker-compose logs -f backend

logs-frontend:
	docker-compose logs -f frontend

logs-traefik:
	docker-compose logs -f traefik

# Django management commands
migrate:
	docker-compose exec backend python manage.py migrate

superuser:
	docker-compose exec backend python manage.py createsuperuser

shell:
	docker-compose exec backend python manage.py shell

# Database commands
db-backup:
	docker-compose exec db pg_dump -U $${POSTGRES_USER:-coderr_user} $${POSTGRES_DB:-coderr_db} > backup_$$(date +%Y%m%d_%H%M%S).sql

db-shell:
	docker-compose exec db psql -U $${POSTGRES_USER:-coderr_user} $${POSTGRES_DB:-coderr_db}

# Clean up
clean:
	docker-compose down -v
	@echo "⚠️  All containers and volumes have been removed!"

# Rebuild everything
rebuild: clean build up
	@echo "✅ Rebuild complete!"

# Show status
status:
	docker-compose ps

# Development helpers
dev-logs:
	docker-compose logs -f backend frontend

dev-restart:
	docker-compose restart backend frontend
