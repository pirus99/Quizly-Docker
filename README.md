# Coderr Platform - Docker Deployment

Complete Docker deployment setup for the Coderr platform with Traefik reverse proxy, Django backend, and static frontend.

## 🚀 Quick Start

### Windows (PowerShell)
```powershell
.\deploy.ps1
```

### Windows (CMD)
```cmd
deploy.bat
```

### Linux/macOS
```bash
chmod +x deploy.sh
./deploy.sh
```

## 📁 Project Structure

```
.
├── Dockerfile.backend       # Backend container configuration
├── Dockerfile.frontend      # Frontend container configuration
├── entrypoint.backend.sh    # Backend startup script with auto-migrations
├── entrypoint.frontend.sh   # Frontend startup script with config injection
├── docker-compose.yml       # Main Docker Compose configuration
├── .env.example             # Environment variables template
├── .dockerignore            # Files to exclude from Docker builds
├── DEPLOYMENT.md            # Detailed deployment documentation
├── deploy.*                 # Quick-start deployment scripts
└── Makefile                 # Convenience commands
```

**Note:** This is a standalone Docker deployment repository. The actual application code is cloned from:
- Backend: https://github.com/Gokudoma/Coderr-Backend.git
- Frontend: https://github.com/Gokudoma/Coderr-Frontend.git

## 🏗️ Architecture

- **Traefik**: Reverse proxy with automatic routing
- **Backend**: Django REST API with PostgreSQL
- **Frontend**: Nginx serving static files
- **Database**: PostgreSQL 16

## 🌐 Routing

| Path | Destination | Purpose |
|------|-------------|---------|
| `/api/*` | Backend | REST API endpoints |
| `/admin/*` | Backend | Django admin panel |
| `/static/*` | Backend | Static files (CSS/JS/images) |
| `/*` | Frontend | All other routes (HTML pages) |

## ⚙️ Configuration

All important settings are configured via environment variables in `.env`:

- Repository URLs (clone from GitHub during build)
- Django settings (SECRET_KEY, DEBUG, etc.)
- Database credentials
- Traefik settings
- Network ports

See [.env.example](.env.example) for all available options.

## 📖 Documentation

For detailed instructions including:
- Portainer deployment
- Production recommendations
- Manual setup steps
- Troubleshooting
- Common tasks

See **[DEPLOYMENT.md](DEPLOYMENT.md)**

## 🔧 Requirements

- Docker Engine 20.10+
- Docker Compose 2.0+
- Git (for repository cloning inside containers)

## 📝 License

This deployment configuration is provided for the Coderr platform.
