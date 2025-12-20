# Deployment Guide: Paper2Slides on Hostinger with Coolify

This guide explains how to deploy Paper2Slides on Hostinger using Coolify, a self-hosted Heroku/Netlify alternative.

## Prerequisites

1. **Hostinger VPS** with root access
2. **Coolify installed** on your Hostinger VPS
3. **Domain name** (optional, but recommended)
4. **API Keys**:
   - OpenAI or DeepSeek API key (for RAG/LLM)
   - Image generation API key (OpenRouter or Google Gemini)

## Server Requirements

- **CPU**: 2+ cores (recommended 4+)
- **RAM**: 4GB minimum (8GB+ recommended)
- **Storage**: 20GB+ free space
- **OS**: Ubuntu 20.04+ or Debian 11+

## Step 1: Install Coolify on Hostinger VPS

If Coolify is not already installed:

```bash
# SSH into your Hostinger VPS
ssh root@your-vps-ip

# Install Coolify (one-command installation)
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

Wait for installation to complete. Access Coolify at `http://your-vps-ip:8000`

## Step 2: Initial Coolify Setup

1. Open Coolify in your browser: `http://your-vps-ip:8000`
2. Create your admin account
3. Complete the initial setup wizard
4. Add your server (localhost) if not already added

## Step 3: Create a New Project in Coolify

1. In Coolify dashboard, click **"+ New"** → **"Project"**
2. Give it a name: `paper2slides`
3. Add an environment (e.g., "Production")

## Step 4: Deploy from GitHub

> **⚠️ CRITICAL**: You MUST select "Docker Compose" as the build pack. If you select or allow Nixpacks to auto-detect, the deployment will fail. Paper2Slides is a multi-service application that requires Docker Compose. See [.coolify/IMPORTANT_BUILD_CONFIGURATION.md](./.coolify/IMPORTANT_BUILD_CONFIGURATION.md) for details.

### Option A: Deploy from Public Repository

1. In your project, click **"+ New Resource"** → **"Public Repository"**
2. Repository URL: `https://github.com/HKUDS/Paper2Slides.git`
   - Or your fork: `https://github.com/YOUR_USERNAME/Paper2Slides.git`
3. Branch: `main` (or your preferred branch)
4. Build Pack: Select **"Docker Compose"** ⚠️ **MUST be Docker Compose, NOT Nixpacks!**
5. Docker Compose Location: `/docker-compose.yml` (root level)

### Option B: Deploy from Private Repository

1. In your project, click **"+ New Resource"** → **"Private Repository (GitHub)**
2. Connect your GitHub account
3. Select the Paper2Slides repository
4. Configure as above

## Step 5: Configure Environment Variables

In Coolify, go to your application's **Environment Variables** section and add:

### Required Variables

```env
# LLM Configuration
RAG_LLM_API_KEY=your_openai_or_deepseek_api_key
RAG_LLM_BASE_URL=https://api.openai.com/v1
RAG_LLM_MAX_TOKENS=16000

# Image Generation
IMAGE_GEN_PROVIDER=openrouter
IMAGE_GEN_API_KEY=your_image_gen_api_key
IMAGE_GEN_BASE_URL=https://openrouter.ai/api/v1
IMAGE_GEN_MODEL=google/gemini-3-pro-image-preview
IMAGE_GEN_RESPONSE_MIME_TYPE=image/png

# Optional: Google Gemini
GOOGLE_GENAI_BASE_URL=https://generativelanguage.googleapis.com/v1beta
```

### Port Configuration (Optional)

Coolify automatically manages ports, but you can customize:

```env
BACKEND_PORT=8000
FRONTEND_PORT=5173
```

## Step 6: Configure Domain (Optional)

1. In Coolify, go to your application's **Domains** section
2. Add your domain: `paper2slides.yourdomain.com`
3. Coolify will automatically:
   - Configure reverse proxy (Traefik)
   - Set up SSL/TLS certificates (Let's Encrypt)
   - Handle HTTPS redirection

**Important**: Update your domain's DNS settings:
- Add an A record pointing to your VPS IP
- Wait for DNS propagation (can take up to 24 hours)

## Step 7: Create .env File for paper2slides Module

Coolify environment variables work for Docker Compose, but Paper2Slides also needs a `.env` file in the `paper2slides/` directory:

1. In Coolify, go to **Storage** → **Add Persistent Storage**
2. Create a volume for the `.env` file:
   - Source: Create a new file with your API keys (see below)
   - Destination: `/app/paper2slides/.env`
   - Or use the existing volume mount in docker-compose.yml

**Alternative**: SSH into your server and create the file manually:

```bash
# SSH into your VPS
ssh root@your-vps-ip

# Find your app's directory (Coolify stores apps in /data/coolify/)
cd /data/coolify/applications/YOUR_APP_ID

# Create the .env file
mkdir -p paper2slides
cat > paper2slides/.env << 'EOF'
RAG_LLM_API_KEY=your_key_here
RAG_LLM_BASE_URL=https://api.openai.com/v1
RAG_LLM_MAX_TOKENS=16000
IMAGE_GEN_PROVIDER=openrouter
IMAGE_GEN_API_KEY=your_key_here
IMAGE_GEN_BASE_URL=https://openrouter.ai/api/v1
IMAGE_GEN_MODEL=google/gemini-3-pro-image-preview
IMAGE_GEN_RESPONSE_MIME_TYPE=image/png
GOOGLE_GENAI_BASE_URL=https://generativelanguage.googleapis.com/v1beta
EOF
```

## Step 8: Deploy

1. Click **"Deploy"** in Coolify
2. Monitor the build logs
3. Wait for both services to start (backend + frontend)

## Step 9: Verify Deployment

### Check Health

```bash
# Test backend health
curl http://your-domain-or-ip:8000/health

# Should return: {"status":"healthy"}
```

### Access the Application

- **Frontend**: `http://your-domain-or-ip:5173`
- **Backend API**: `http://your-domain-or-ip:8000`
- **API Docs**: `http://your-domain-or-ip:8000/docs`

If using a domain with Coolify:
- **Frontend**: `https://paper2slides.yourdomain.com`
- **Backend API**: `https://paper2slides.yourdomain.com/api`

## Troubleshooting

### Issue: Deployment Shows "Found application type: python" (CRITICAL)

**Problem:** Coolify is using Nixpacks instead of Docker Compose.

**Symptoms:**
```
Found application type: python.
Generating nixpacks configuration
...
Paper2Slides MUST be deployed with Docker Compose, NOT Nixpacks!
...
Building docker image failed.
```

**What Happened:**
Coolify may have auto-detected the repository as a Python/Nixpacks project instead of recognizing it as a Docker Compose application. Paper2Slides is a multi-service application that requires Docker Compose for proper orchestration.

**Solution:**
1. This is a **configuration issue** - Paper2Slides requires Docker Compose
2. Go to your application settings in Coolify
3. Change **Build Pack** to `Docker Compose`
4. Set **Docker Compose Location** to `/docker-compose.yml`
5. Save and **Redeploy**

📖 See [.coolify/IMPORTANT_BUILD_CONFIGURATION.md](./.coolify/IMPORTANT_BUILD_CONFIGURATION.md) for detailed explanation.

### Issue: Build Fails

**Solution:**
1. Check Coolify build logs
2. Ensure all environment variables are set
3. Verify Docker and Docker Compose are installed on the server
4. Check server resources (CPU, RAM, disk space)

### Issue: Backend Can't Find .env File

**Solution:**
1. Ensure `/app/paper2slides/.env` is mounted correctly
2. Check file permissions: `chmod 600 paper2slides/.env`
3. Verify the file contents match the required format

### Issue: Frontend Can't Connect to Backend

**Solution:**
1. Update `VITE_API_URL` environment variable to match your backend URL
2. If using a domain, ensure both services are behind the same domain
3. Check Coolify's reverse proxy (Traefik) configuration

### Issue: Out of Memory

**Solution:**
1. Increase VPS RAM (upgrade your Hostinger plan)
2. Add swap space:
```bash
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### Issue: Port Already in Use

**Solution:**
1. Coolify manages ports automatically
2. If needed, change `BACKEND_PORT` or `FRONTEND_PORT` in environment variables
3. Or let Coolify assign random ports (recommended)

### Issue: Deployment Shows "Degraded" or "Unhealthy" Status

**Symptoms:**
- Coolify shows deployment status as "degraded (unhealthy) or exited"
- Container health checks are failing
- Services appear to be running but marked as unhealthy in Coolify dashboard

**Solution:**
This issue has been fixed in the latest version. The frontend container's healthcheck was failing because `curl` wasn't installed in the nginx:alpine base image. Update to the latest version:

```bash
# SSH into your server
ssh root@your-vps-ip

# Navigate to your app directory
cd /data/coolify/applications/YOUR_APP_ID

# Pull latest changes
git pull

# Trigger redeploy in Coolify dashboard
```

**Verify Health:**
```bash
# Check container health status
docker ps --format "table {{.Names}}\t{{.Status}}"

# Test backend health endpoint
curl http://localhost:8000/health

# Test frontend
curl -I http://localhost:80
```

If both services return successful responses, the deployment is healthy.

## Updating the Application

### Automatic Updates (Webhook)

1. In Coolify, go to your application settings
2. Enable **"Automatic Deployment"**
3. Copy the webhook URL
4. Add webhook to your GitHub repository:
   - Go to your GitHub repo → Settings → Webhooks
   - Add the Coolify webhook URL
   - Select "Just the push event"

Now, every push to your branch will trigger an automatic deployment.

### Manual Updates

1. In Coolify dashboard, go to your application
2. Click **"Redeploy"**
3. Monitor the build logs

## Monitoring and Logs

### View Logs in Coolify

1. Go to your application in Coolify
2. Click **"Logs"** tab
3. Select service (backend or frontend)
4. View real-time logs

### SSH Access to Containers

```bash
# Find container IDs
docker ps

# Access backend container
docker exec -it paper2slides-backend bash

# Access frontend container
docker exec -it paper2slides-frontend sh
```

### Check Resource Usage

```bash
# Docker stats
docker stats

# System resources
htop
```

## Scaling

### Vertical Scaling (More Resources)

1. Upgrade your Hostinger VPS plan
2. Restart the application in Coolify

### Horizontal Scaling (Multiple Instances)

For high-traffic scenarios:

1. **Backend**: Configure multiple backend replicas in docker-compose.yml
2. **Load Balancer**: Use Coolify's built-in load balancing
3. **Shared Storage**: Configure external storage for outputs (S3, etc.)

## Backup

### Backup Outputs Volume

```bash
# Create backup directory
mkdir -p /backups

# Backup outputs
docker run --rm -v paper2slides_outputs:/data -v /backups:/backup alpine tar czf /backup/outputs-$(date +%Y%m%d).tar.gz -C /data .
```

### Backup Environment Variables

Export from Coolify dashboard or backup the `.env` file.

## Security Best Practices

1. **API Keys**: Never commit API keys to Git
2. **Firewall**: Use Hostinger's firewall to restrict access
3. **SSL/TLS**: Always use HTTPS (Coolify handles this automatically)
4. **Updates**: Keep Coolify and Docker updated
5. **Monitoring**: Set up uptime monitoring (UptimeRobot, etc.)

## Cost Estimation

**Hostinger VPS Pricing** (as of 2024):
- **KVM 2**: $5.99/month (2 vCPU, 4GB RAM) - Minimum
- **KVM 4**: $11.99/month (4 vCPU, 8GB RAM) - Recommended
- **KVM 8**: $23.99/month (8 vCPU, 16GB RAM) - Heavy usage

**API Costs** (varies by usage):
- OpenAI API: ~$0.01-0.10 per document
- DeepSeek API: Lower cost alternative
- Image Generation: Varies by provider

## Support

For deployment issues:
1. Check Coolify documentation: https://coolify.io/docs
2. Coolify Discord: https://coolify.io/discord
3. Paper2Slides issues: https://github.com/HKUDS/Paper2Slides/issues

## Additional Resources

- [Coolify Documentation](https://coolify.io/docs)
- [Hostinger VPS Guide](https://www.hostinger.com/tutorials/vps)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Paper2Slides Repository](https://github.com/HKUDS/Paper2Slides)

---

**🎉 Congratulations!** Your Paper2Slides application is now deployed on Hostinger using Coolify!
