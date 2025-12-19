# Coolify Configuration for Paper2Slides

This directory contains Coolify-specific configuration files for deploying Paper2Slides.

## ⚠️ CRITICAL: Build Pack Configuration

**IMPORTANT**: Paper2Slides MUST be deployed with **Docker Compose**, NOT Nixpacks!

If you see "Found application type: python" in deployment logs, you've misconfigured the build pack.

👉 **[Read the Build Configuration Guide](./IMPORTANT_BUILD_CONFIGURATION.md)** 👈

## Quick Start with Coolify

1. **Connect Repository**: Use the main repository URL in Coolify
2. **Build Pack**: **Docker Compose** ⚠️ (MUST select this, NOT Nixpacks!)
3. **Compose File**: `/docker-compose.yml` (root level)
4. **Environment Variables**: Set all required API keys in Coolify dashboard

## Required Environment Variables

Set these in Coolify's Environment Variables section:

```env
RAG_LLM_API_KEY=your_key
RAG_LLM_BASE_URL=https://api.openai.com/v1
IMAGE_GEN_API_KEY=your_key
IMAGE_GEN_BASE_URL=https://openrouter.ai/api/v1
IMAGE_GEN_MODEL=google/gemini-3-pro-image-preview
```

## Volume Mounts

Coolify will automatically handle:
- `./outputs` - Generated slides and posters
- `./paper2slides/.env` - API configuration (must be created)

## Ports

- Backend: 8000 (Coolify will proxy this)
- Frontend: 5173 (Coolify will proxy this)

## Health Checks

The application includes health checks:
- Backend: `GET /health`
- Frontend: Nginx responds on port 80

## Deployment Flow

1. Coolify pulls from Git repository
2. Builds backend and frontend containers
3. Starts services with environment variables
4. Sets up reverse proxy with SSL (if domain configured)
5. Application is accessible at your domain

## Monitoring

Check logs in Coolify dashboard:
- Backend logs: Python application logs
- Frontend logs: Nginx access logs

## Updates

- **Automatic**: Enable webhook in Coolify for auto-deployment on Git push
- **Manual**: Click "Redeploy" in Coolify dashboard

## Helper Scripts

This directory includes helpful scripts:

### validate-env.sh

Validates that all required environment variables are set:

```bash
# Run inside backend container
docker exec paper2slides-backend /app/.coolify/validate-env.sh
```

### healthcheck.sh

Checks if all services are running correctly:

```bash
# From host machine
bash .coolify/healthcheck.sh http://your-domain:8000 http://your-domain:5173

# Or with defaults (localhost)
bash .coolify/healthcheck.sh
```
