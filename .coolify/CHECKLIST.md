# Coolify Deployment Checklist

Use this checklist to ensure a smooth deployment of Paper2Slides on Hostinger using Coolify.

## Pre-Deployment Checklist

### 1. Server Preparation
- [ ] Hostinger VPS is provisioned (KVM 2 minimum: 2 vCPU, 4GB RAM)
- [ ] SSH access to VPS is working: `ssh root@your-vps-ip`
- [ ] Server has at least 20GB free disk space: `df -h`
- [ ] Server has Docker installed: `docker --version`
- [ ] Coolify is installed and accessible at `http://your-vps-ip:8000`

### 2. API Keys Preparation
- [ ] OpenAI or DeepSeek API key obtained
- [ ] Image generation API key obtained (OpenRouter or Google Gemini)
- [ ] API keys tested and working
- [ ] API keys stored securely (password manager, etc.)

### 3. Domain Setup (Optional but Recommended)
- [ ] Domain name registered
- [ ] DNS A record created pointing to VPS IP
- [ ] DNS propagated (check with `nslookup yourdomain.com`)
- [ ] Subdomain chosen (e.g., `paper2slides.yourdomain.com`)

## Coolify Configuration Checklist

### 4. Create Project
- [ ] Logged into Coolify dashboard
- [ ] Created new project: `+ New` → `Project`
- [ ] Named project (e.g., "paper2slides")
- [ ] Added environment (e.g., "Production")

### 5. Add Repository
- [ ] Clicked `+ New Resource` → `Public Repository` (or Private)
- [ ] Entered repository URL: `https://github.com/HKUDS/Paper2Slides.git`
- [ ] Selected branch: `main`
- [ ] Chose build pack: `Docker Compose`
- [ ] Set Docker Compose location: `/docker-compose.yml`

### 6. Environment Variables
- [ ] Navigated to **Environment Variables** tab
- [ ] Added `RAG_LLM_API_KEY`
- [ ] Added `RAG_LLM_BASE_URL` (e.g., `https://api.openai.com/v1`)
- [ ] Added `RAG_LLM_MAX_TOKENS` (e.g., `16000`)
- [ ] Added `IMAGE_GEN_PROVIDER` (`openrouter` or `google`)
- [ ] Added `IMAGE_GEN_API_KEY`
- [ ] Added `IMAGE_GEN_BASE_URL`
- [ ] Added `IMAGE_GEN_MODEL`
- [ ] Added `IMAGE_GEN_RESPONSE_MIME_TYPE` (e.g., `image/png`)
- [ ] Added `GOOGLE_GENAI_BASE_URL` (if using Google provider)

### 7. Volume/Storage Configuration
- [ ] Created `/app/paper2slides/.env` file via Coolify File Manager or SSH
- [ ] Verified `.env` file contains all required API keys
- [ ] Set file permissions to `0600` (read/write for owner only)
- [ ] Confirmed outputs volume is configured (automatic via docker-compose.yml)

### 8. Domain Configuration (Optional)
- [ ] Navigated to **Domains** tab in Coolify
- [ ] Added domain: `paper2slides.yourdomain.com`
- [ ] Verified Coolify shows SSL certificate status
- [ ] Confirmed reverse proxy is configured

## Deployment Checklist

### 9. Initial Deployment
- [ ] Clicked **Deploy** button in Coolify
- [ ] Monitored build logs for errors
- [ ] Waited for backend container to start (check health)
- [ ] Waited for frontend container to start
- [ ] Verified both services show as "running" in Coolify

### 10. Post-Deployment Verification

#### Backend Verification
- [ ] Backend health check passes: `curl http://your-vps-ip:8000/health`
- [ ] Backend API root accessible: `curl http://your-vps-ip:8000/`
- [ ] API documentation loads: `http://your-vps-ip:8000/docs`

#### Frontend Verification
- [ ] Frontend loads in browser: `http://your-vps-ip:5173`
- [ ] Frontend UI displays correctly
- [ ] No console errors in browser developer tools

#### Integration Verification
- [ ] File upload works
- [ ] Can start a generation task
- [ ] Can view generation status
- [ ] Can download generated outputs

### 11. Security Verification
- [ ] SSL/TLS certificate is active (if using domain)
- [ ] HTTP redirects to HTTPS (if using domain)
- [ ] API keys are not exposed in logs or responses
- [ ] Firewall rules are configured (if using custom firewall)

### 12. Performance Check
- [ ] Server resource usage is acceptable: `docker stats`
- [ ] Backend responds quickly to API calls
- [ ] Frontend loads quickly
- [ ] File uploads complete successfully
- [ ] Generation tasks complete without timeout

## Optional: Advanced Configuration

### 13. Monitoring Setup
- [ ] Set up uptime monitoring (e.g., UptimeRobot)
- [ ] Configure log aggregation (if needed)
- [ ] Set up alerts for service downtime
- [ ] Enable Coolify webhooks for deployment notifications

### 14. Backup Configuration
- [ ] Configured backup for outputs volume
- [ ] Backed up environment variables
- [ ] Documented API keys in secure location
- [ ] Created disaster recovery plan

### 15. Continuous Integration
- [ ] Added Coolify webhook to GitHub repository
- [ ] Tested automatic deployment on Git push
- [ ] Verified webhook notifications work
- [ ] Set up staging environment (optional)

## Troubleshooting Checklist

If deployment fails, check:

### Build Failures
- [ ] Docker and Docker Compose are installed
- [ ] Dockerfile paths are correct
- [ ] Server has enough disk space
- [ ] Network connectivity is stable

### Runtime Failures
- [ ] All environment variables are set correctly
- [ ] `/app/paper2slides/.env` file exists and is readable
- [ ] API keys are valid and working
- [ ] Ports are not already in use
- [ ] Server has enough RAM (check with `free -h`)

### Connection Issues
- [ ] Backend container is running: `docker ps`
- [ ] Frontend container is running: `docker ps`
- [ ] Both services are on same network
- [ ] Firewall allows traffic on required ports
- [ ] DNS is resolving correctly (if using domain)

## Maintenance Checklist

### Regular Maintenance
- [ ] Monitor server resource usage weekly
- [ ] Check application logs for errors
- [ ] Review API usage and costs
- [ ] Update Docker images monthly
- [ ] Test backup and restore procedures

### Updates
- [ ] Pull latest changes from Git repository
- [ ] Review changelog for breaking changes
- [ ] Test in staging environment (if available)
- [ ] Deploy to production via Coolify
- [ ] Verify all features work after update

## Success Criteria

Your deployment is successful if:
- ✅ Backend health endpoint returns 200 OK
- ✅ Frontend loads without errors
- ✅ File upload and processing works
- ✅ Generated outputs are accessible
- ✅ SSL/TLS is configured (if using domain)
- ✅ Application is accessible from the internet

## Support Resources

If you need help:
- 📖 [Full Deployment Guide](../DEPLOYMENT.md)
- 🚀 [Quick Start Guide](../QUICKSTART_COOLIFY.md)
- 🐛 [Report Issues](https://github.com/HKUDS/Paper2Slides/issues)
- 💬 [Coolify Discord](https://coolify.io/discord)
- 📚 [Coolify Documentation](https://coolify.io/docs)

---

**Last Updated**: December 2024

Save this checklist and mark items as you complete them for a smooth deployment experience!
