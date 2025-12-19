# Coolify Deployment - Summary

This document provides an overview of the Coolify deployment configuration for Paper2Slides.

## What Was Added

The repository has been prepared for deployment on Hostinger using Coolify with the following additions:

### 1. Production Docker Compose Configuration
- **File**: `/docker-compose.yml` (root level)
- **Purpose**: Production-ready compose file optimized for Coolify
- **Features**:
  - Health checks for both services
  - Environment variable configuration
  - Proper service dependencies
  - Volume management for outputs
  - Network isolation

### 2. Environment Configuration
- **File**: `/.env.example` (root level)
- **Purpose**: Template for environment variables needed in Coolify
- **Contains**: API keys, ports, and configuration for LLM and image generation

### 3. Comprehensive Documentation
- **DEPLOYMENT.md**: Full deployment guide with troubleshooting
- **QUICKSTART_COOLIFY.md**: 5-minute quick start guide
- **README.md**: Updated with deployment section

### 4. Coolify-Specific Files (`.coolify/` directory)
- **README.md**: Quick reference for Coolify deployment
- **CHECKLIST.md**: Step-by-step deployment checklist
- **validate-env.sh**: Script to validate environment variables
- **healthcheck.sh**: Script to verify deployment health
- **SUMMARY.md**: This file

## Deployment Architecture

```
┌─────────────────────────────────────────────────┐
│           Coolify (PaaS Platform)               │
│  ┌──────────────────────────────────────────┐  │
│  │      Traefik Reverse Proxy (SSL/TLS)     │  │
│  └────────────┬───────────────┬─────────────┘  │
│               │               │                 │
│  ┌────────────▼──────────┐ ┌──▼──────────────┐ │
│  │  Frontend Container   │ │ Backend Container│ │
│  │  (Nginx + React)      │ │ (FastAPI/Python) │ │
│  │  Port: 80 → 5173      │ │ Port: 8000       │ │
│  └───────────────────────┘ └──────────────────┘ │
│                                                  │
│  Volumes:                                        │
│  - outputs/  (generated slides/posters)          │
│  - paper2slides/.env  (API configuration)        │
└─────────────────────────────────────────────────┘
```

## Key Features

### 🔒 Security
- Environment variables managed by Coolify
- API keys stored securely
- Automatic SSL/TLS certificates
- Read-only .env file mounting

### 🏥 Health Checks
- Backend: `GET /health` endpoint
- Frontend: Nginx health check
- Dependency management (frontend waits for backend)

### 📦 Volume Management
- **outputs/**: Persistent storage for generated files
- **paper2slides/.env**: API configuration (needs manual creation)

### 🔄 CI/CD Ready
- Webhook support for auto-deployment
- Manual redeploy option in Coolify
- Environment-specific configurations

## Environment Variables Required

### Essential (Must Set in Coolify)
```env
RAG_LLM_API_KEY          # OpenAI/DeepSeek API key
RAG_LLM_BASE_URL         # LLM API endpoint
IMAGE_GEN_PROVIDER       # "openrouter" or "google"
IMAGE_GEN_API_KEY        # Image generation API key
IMAGE_GEN_BASE_URL       # Image API endpoint
IMAGE_GEN_MODEL          # Model name
```

### Optional (Have Defaults)
```env
RAG_LLM_MAX_TOKENS       # Default: 16000
IMAGE_GEN_RESPONSE_MIME_TYPE  # Default: image/png
GOOGLE_GENAI_BASE_URL    # For Google provider
BACKEND_PORT             # Default: 8000
FRONTEND_PORT            # Default: 5173
```

## File Structure

```
Paper2Slides/
├── docker-compose.yml           # Production compose file for Coolify
├── .env.example                 # Environment variable template
├── DEPLOYMENT.md                # Full deployment guide
├── QUICKSTART_COOLIFY.md        # 5-minute quick start
│
├── .coolify/                    # Coolify-specific files
│   ├── README.md               # Quick reference
│   ├── CHECKLIST.md            # Deployment checklist
│   ├── SUMMARY.md              # This file
│   ├── validate-env.sh         # Environment validation
│   └── healthcheck.sh          # Health check script
│
├── docker/                      # Docker configuration
│   ├── Dockerfile.backend      # Backend image
│   ├── Dockerfile.frontend     # Frontend image
│   ├── docker-compose.yml      # Development compose file
│   ├── nginx.conf              # Nginx configuration
│   └── README.md               # Docker documentation
│
└── paper2slides/
    └── .env.example             # Paper2Slides module env template
```

## Quick Links

### Getting Started
1. **New to Coolify?** → Start with [QUICKSTART_COOLIFY.md](../QUICKSTART_COOLIFY.md)
2. **Need Details?** → Read [DEPLOYMENT.md](../DEPLOYMENT.md)
3. **During Deployment?** → Follow [CHECKLIST.md](./CHECKLIST.md)

### Validation & Testing
- **Validate Config**: Run `.coolify/validate-env.sh` in backend container
- **Health Check**: Run `.coolify/healthcheck.sh` on host machine
- **Docker Compose**: `docker compose config` to validate syntax

### Troubleshooting
- Check Coolify logs in dashboard
- Verify environment variables are set
- Ensure `/app/paper2slides/.env` exists
- Run validation and health check scripts

## Deployment Flow

1. **Coolify Setup**
   - Create project and environment
   - Connect GitHub repository
   - Set build pack to Docker Compose

2. **Configuration**
   - Add environment variables in Coolify
   - Create `/app/paper2slides/.env` file
   - Configure domain (optional)

3. **Deploy**
   - Click Deploy in Coolify
   - Monitor build logs
   - Wait for services to start

4. **Verify**
   - Run health checks
   - Test file upload
   - Verify generation works

5. **Monitor**
   - Check logs in Coolify
   - Monitor resource usage
   - Set up uptime monitoring

## Support & Resources

### Documentation
- 📖 [Full Deployment Guide](../DEPLOYMENT.md)
- 🚀 [Quick Start Guide](../QUICKSTART_COOLIFY.md)
- ✅ [Deployment Checklist](./CHECKLIST.md)
- 🔧 [Docker Documentation](../docker/README.md)

### Tools
- 🔍 [validate-env.sh](./validate-env.sh) - Environment validation
- 🏥 [healthcheck.sh](./healthcheck.sh) - Health verification

### Community
- 🐛 [Report Issues](https://github.com/HKUDS/Paper2Slides/issues)
- 💬 [Coolify Discord](https://coolify.io/discord)
- 📚 [Coolify Docs](https://coolify.io/docs)

## Minimum Requirements

### Server
- **CPU**: 2+ cores (4+ recommended)
- **RAM**: 4GB minimum (8GB+ recommended)
- **Storage**: 20GB+ free space
- **OS**: Ubuntu 20.04+ or Debian 11+

### Software
- Docker 20.10+
- Coolify latest version
- Git (for repository connection)

### External Services
- OpenAI or DeepSeek API account
- Image generation API (OpenRouter or Google Gemini)

## Cost Estimation

### Hostinger VPS (Monthly)
- KVM 2 (2 vCPU, 4GB RAM): ~$5.99
- KVM 4 (4 vCPU, 8GB RAM): ~$11.99 (recommended)
- KVM 8 (8 vCPU, 16GB RAM): ~$23.99

### API Usage (Variable)
- OpenAI: ~$0.01-0.10 per document
- DeepSeek: Lower cost alternative
- Image Gen: Varies by provider

## Next Steps

After deployment:
1. ✅ Verify all services are running
2. ✅ Test with a sample document
3. ✅ Set up monitoring and alerts
4. ✅ Configure backups
5. ✅ Enable automatic deployments (webhook)
6. ✅ Document your specific configuration

## Change Log

### Version 1.0 (December 2024)
- Initial Coolify deployment configuration
- Production docker-compose.yml
- Comprehensive documentation
- Validation and health check scripts
- Step-by-step deployment checklist

---

**Last Updated**: December 19, 2024

For the latest version, visit: https://github.com/HKUDS/Paper2Slides
