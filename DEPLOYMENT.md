# Docker Deployment Guide

This Docker setup provides a complete deployment solution for the Coderr platform with Traefik reverse proxy, Django backend, and static frontend.

## Architecture

The deployment consists of:

- **Traefik**: Reverse proxy handling routing and load balancing
- **Backend**: Django application with PostgreSQL database (cloned from GitHub)
- **Frontend**: Static HTML/JS/CSS served via Nginx (cloned from GitHub)
- **Database**: PostgreSQL 16

**Important:** This is a standalone Docker deployment repository. The actual application code is automatically cloned during the Docker build process from:
- Backend: https://github.com/Gokudoma/Coderr-Backend.git
- Frontend: https://github.com/Gokudoma/Coderr-Frontend.git

## Routing Configuration

Traefik automatically routes traffic based on URL paths:

| Path | Destination | Description |
|------|-------------|-------------|
| `/api/*` | Backend | API endpoints |
| `/admin/*` | Backend | Django admin interface |
| `/static/*` | Backend | Static files (CSS, JS, images) |
| `/*` | Frontend | All other paths (HTML pages) |

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+ (or docker-compose 1.29+)
- Git (for cloning repositories in containers)

## Quick Start

### 1. Environment Configuration

Copy the example environment file and customize it:

```bash
cp .env.example .env
```

Edit `.env` and configure the following **REQUIRED** variables:

```env
# Change these to secure values for production:
DJANGO_SECRET_KEY=your-secret-key-here
POSTGRES_PASSWORD=your-secure-database-password
```

### 2. Generate Django Secret Key

Generate a secure secret key:

```bash
# Using Python (if installed locally)
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'

# Or using Docker
docker run --rm python:3.11 python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'

# Or use an online generator
# https://djecrety.ir/
```

### 3. Deploy with Docker Compose

Build and start all services:

```bash
docker-compose up -d --build
```

The `--build` flag ensures Docker clones the latest code from the repositories.

### 4. Initialize the Database

Create database migrations and superuser:

```bash
# Run migrations
docker-compose exec backend python manage.py migrate

# Create Django superuser
docker-compose exec backend python manage.py createsuperuser
```

### 5. Access the Application

- **Frontend**: http://localhost
- **Django Admin**: http://localhost/admin/
- **API**: http://localhost/api/
- **Traefik Dashboard** (if enabled): http://localhost:8080

## Portainer Deployment

This docker-compose configuration is fully compatible with Portainer.

### Deploy via Portainer Stacks:

1. Log into Portainer
2. Go to **Stacks** → **Add Stack**
3. Name your stack (e.g., "coderr")
4. Choose **Upload** method and upload `docker-compose.yml`
5. Add environment variables:
   - Click **Add environment variable**
   - Add all variables from `.env.example`
   - Update sensitive values (SECRET_KEY, POSTGRES_PASSWORD)
6. Click **Deploy the stack**

### Deploy via Portainer Git Repository:

1. Go to **Stacks** → **Add Stack** → **Repository**
2. Enter your Git repository URL
3. Specify the Compose path: `docker-compose.yml`
4. Add environment variables in the UI
5. Click **Deploy the stack**

## Configuration Variables

### Repository Settings

| Variable | Description | Default |
|----------|-------------|---------|
| `BACKEND_REPO_URL` | Git URL for backend repository | `https://github.com/Gokudoma/Coderr-Backend.git` |
| `BACKEND_REPO_BRANCH` | Branch to clone | `main` |
| `FRONTEND_REPO_URL` | Git URL for frontend repository | `https://github.com/Gokudoma/Coderr-Frontend.git` |
| `FRONTEND_REPO_BRANCH` | Branch to clone | `main` |

### Network Settings

| Variable | Description | Default |
|----------|-------------|---------|
| `DOMAIN` | Domain name for the application | `localhost` |
| `HTTP_PORT` | HTTP port | `80` |
| `HTTPS_PORT` | HTTPS port | `443` |

### Django Settings

| Variable | Description | Default |
|----------|-------------|---------|
| `DJANGO_SECRET_KEY` | Django secret key | **REQUIRED** |
| `DJANGO_DEBUG` | Enable debug mode | `False` |
| `ALLOWED_HOSTS` | Allowed hosts | `*` |

### Database Settings

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_DB` | Database name | `coderr_db` |
| `POSTGRES_USER` | Database user | `coderr_user` |
| `POSTGRES_PASSWORD` | Database password | **REQUIRED** |

### Traefik Settings

| Variable | Description | Default |
|----------|-------------|---------|
| `TRAEFIK_DASHBOARD` | Enable dashboard | `false` |
| `TRAEFIK_DASHBOARD_PORT` | Dashboard port | `8080` |
| `TRAEFIK_LOG_LEVEL` | Log level | `INFO` |

## Common Tasks

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f traefik
```

### Restart Services

```bash
# Restart all
docker-compose restart

# Restart specific service
docker-compose restart backend
```

### Update Code from Repositories

To pull the latest code:

```bash
# Rebuild with latest code
docker-compose up -d --build

# Or rebuild specific service
docker-compose up -d --build backend
```

### Execute Django Management Commands

```bash
# Run migrations
docker-compose exec backend python manage.py migrate

# Create superuser
docker-compose exec backend python manage.py createsuperuser

# Collect static files
docker-compose exec backend python manage.py collectstatic --noinput

# Shell access
docker-compose exec backend python manage.py shell
```

### Database Backup

```bash
# Backup
docker-compose exec db pg_dump -U coderr_user coderr_db > backup.sql

# Restore
cat backup.sql | docker-compose exec -T db psql -U coderr_user coderr_db
```

### Stop and Remove Everything

```bash
# Stop services
docker-compose down

# Stop and remove volumes (CAUTION: deletes database!)
docker-compose down -v
```

## Production Recommendations

### Security

1. **Change default passwords**: Update `DJANGO_SECRET_KEY` and `POSTGRES_PASSWORD`
2. **Disable debug mode**: Set `DJANGO_DEBUG=False`
3. **Configure ALLOWED_HOSTS**: Replace `*` with your actual domain
4. **Use HTTPS**: Configure SSL certificates with Traefik
5. **Disable Traefik dashboard**: Set `TRAEFIK_DASHBOARD=false`

### Performance

1. **Adjust worker count**: Modify gunicorn workers in backend Dockerfile
2. **Enable caching**: Add Redis for Django caching
3. **Database tuning**: Optimize PostgreSQL settings
4. **Static file CDN**: Consider using a CDN for static assets

### Monitoring

1. **Enable access logs**: Set `TRAEFIK_ACCESS_LOG=true`
2. **Set up health checks**: Monitor service health
3. **Log aggregation**: Use ELK stack or similar
4. **Metrics**: Add Prometheus and Grafana

## Troubleshooting

### Backend won't start

Check database connection:
```bash
docker-compose logs db
docker-compose logs backend
```

### Frontend shows 502 errors

Verify backend is running:
```bash
docker-compose ps
docker-compose logs backend
```

### Traefik routing issues

Check Traefik dashboard (if enabled):
```
http://localhost:8080
```

### Database connection errors

Ensure database is healthy:
```bash
docker-compose exec db pg_isready -U coderr_user
```

## Support

For issues and questions:
- Backend: https://github.com/Gokudoma/Coderr-Backend
- Frontend: https://github.com/Gokudoma/Coderr-Frontend
