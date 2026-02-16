# Important: Backend and Frontend Directories

This deployment repository contains **only Docker configuration files**.

The `backend/` and `frontend/` directories in this workspace are local clones for reference only and are excluded from version control (`.gitignore`).

## How It Works

When you run `docker-compose up --build`, the Docker build process:

1. **Backend**: Clones from https://github.com/Gokudoma/Coderr-Backend.git inside the container
2. **Frontend**: Clones from https://github.com/Gokudoma/Coderr-Frontend.git inside the container

## Repository Structure

This deployment repo should contain:
- `Dockerfile.backend` - Backend container definition
- `Dockerfile.frontend` - Frontend container definition
- `entrypoint.backend.sh` - Backend startup script
- `entrypoint.frontend.sh` - Frontend startup script
- `docker-compose.yml` - Orchestration configuration
- `.env.example` - Environment template
- Documentation and helper scripts

**Do NOT commit the `backend/` or `frontend/` directories to this repo.**

## Development Workflow

If you want to develop locally with mounted code:

1. Clone the repos manually:
   ```bash
   git clone https://github.com/Gokudoma/Coderr-Backend.git backend
   git clone https://github.com/Gokudoma/Coderr-Frontend.git frontend
   ```

2. Use `docker-compose.override.yml` to mount local directories:
   ```yaml
   services:
     backend:
       volumes:
         - ./backend:/app
     frontend:
       volumes:
         - ./frontend:/usr/share/nginx/html
   ```

See `docker-compose.override.example.yml` for a complete example.
