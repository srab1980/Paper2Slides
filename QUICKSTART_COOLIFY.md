# Quick Start: Deploy Paper2Slides with Coolify

Deploy Paper2Slides on your Hostinger VPS using Coolify in 5 minutes!

## Prerequisites

- ✅ Hostinger VPS (KVM 2 or higher: 2 vCPU, 4GB RAM minimum)
- ✅ Coolify installed on your VPS
- ✅ API keys ready (OpenAI/DeepSeek + Image Generation)

## Step 1: Access Coolify (2 minutes)

```bash
# SSH into your Hostinger VPS
ssh root@your-vps-ip

# If Coolify not installed, install it:
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

# Access Coolify at: http://your-vps-ip:8000
```

Create your admin account if it's your first time.

## Step 2: Create New Application (1 minute)

1. **Click**: `+ New` → `Project` → Give it a name (e.g., "paper2slides")
2. **Click**: `+ New Resource` → `Public Repository` (or Private if forked)
3. **Enter Repository URL**: 
   ```
   https://github.com/HKUDS/Paper2Slides.git
   ```
   Or your fork: `https://github.com/YOUR_USERNAME/Paper2Slides.git`
4. **Branch**: `main`
5. **Build Pack**: ⚠️ **IMPORTANT** - You **MUST** select **`Docker Compose`**
   - Coolify may auto-detect this as "Python" - DO NOT use that
   - Manually select "Docker Compose" from the dropdown
6. **Docker Compose Location**: `/docker-compose.yml`

> **⚠️ CRITICAL**: Paper2Slides is a multi-service app (backend + frontend) that **requires Docker Compose**. If Coolify selects "Nixpacks" or "Python", the deployment will fail or show as "degraded/unhealthy". You **MUST** manually select "Docker Compose" as the build pack.
> 
> If you accidentally deployed with the wrong build pack, see the [Troubleshooting section](#troubleshooting) below for how to fix it.

## Step 3: Set Environment Variables (1 minute)

In Coolify, go to **Environment Variables** tab and add:

### Essential Variables (Required)

```env
RAG_LLM_API_KEY=sk-your-openai-or-deepseek-key
RAG_LLM_BASE_URL=https://api.openai.com/v1
RAG_LLM_MAX_TOKENS=16000

IMAGE_GEN_PROVIDER=openrouter
IMAGE_GEN_API_KEY=sk-or-v1-your-openrouter-key
IMAGE_GEN_BASE_URL=https://openrouter.ai/api/v1
IMAGE_GEN_MODEL=google/gemini-3-pro-image-preview
IMAGE_GEN_RESPONSE_MIME_TYPE=image/png
```

### Alternative: Using Google Gemini for Images

```env
IMAGE_GEN_PROVIDER=google
IMAGE_GEN_API_KEY=your-google-gemini-key
GOOGLE_GENAI_BASE_URL=https://generativelanguage.googleapis.com/v1beta
IMAGE_GEN_MODEL=models/gemini-1.5-flash
```

## Step 4: Create .env File for Backend (1 minute)

**Important**: The Paper2Slides Python module needs its own `.env` file.

### Option A: Use Coolify File Manager (Recommended)

1. In Coolify, go to **Storage** tab
2. Click **Add Persistent Storage**
3. Choose **File** type
4. **Source**: Create file with this content:
   ```env
   RAG_LLM_API_KEY=your-key-here
   RAG_LLM_BASE_URL=https://api.openai.com/v1
   RAG_LLM_MAX_TOKENS=16000
   IMAGE_GEN_PROVIDER=openrouter
   IMAGE_GEN_API_KEY=your-key-here
   IMAGE_GEN_BASE_URL=https://openrouter.ai/api/v1
   IMAGE_GEN_MODEL=google/gemini-3-pro-image-preview
   IMAGE_GEN_RESPONSE_MIME_TYPE=image/png
   GOOGLE_GENAI_BASE_URL=https://generativelanguage.googleapis.com/v1beta
   ```
4. **Destination**: `/app/paper2slides/.env`
5. **Permissions**: `0600` (read/write for owner only)

### Option B: SSH and Create Manually

```bash
# SSH to your VPS
ssh root@your-vps-ip

# Find your app directory
cd /data/coolify/applications/YOUR_APP_UUID

# Create the file
cat > paper2slides/.env << 'EOF'
RAG_LLM_API_KEY=your-key-here
RAG_LLM_BASE_URL=https://api.openai.com/v1
RAG_LLM_MAX_TOKENS=16000
IMAGE_GEN_PROVIDER=openrouter
IMAGE_GEN_API_KEY=your-key-here
IMAGE_GEN_BASE_URL=https://openrouter.ai/api/v1
IMAGE_GEN_MODEL=google/gemini-3-pro-image-preview
IMAGE_GEN_RESPONSE_MIME_TYPE=image/png
GOOGLE_GENAI_BASE_URL=https://generativelanguage.googleapis.com/v1beta
EOF

chmod 600 paper2slides/.env
```

## Step 5: Deploy! (3-5 minutes)

1. Click **Deploy** button in Coolify
2. Watch the build logs
3. Wait for both services to start:
   - ✅ Backend (paper2slides-backend)
   - ✅ Frontend (paper2slides-frontend)

## Step 6: Access Your Application

Coolify will show you the URLs:

- **Frontend**: `http://your-vps-ip:5173`
- **Backend API**: `http://your-vps-ip:8000`
- **API Docs**: `http://your-vps-ip:8000/docs`

### Test Health

```bash
curl http://your-vps-ip:8000/health
# Expected: {"status":"healthy"}
```

## Optional: Add Custom Domain

1. In Coolify, go to **Domains** tab
2. Add your domain: `paper2slides.yourdomain.com`
3. Coolify automatically:
   - Sets up reverse proxy
   - Gets SSL certificate (Let's Encrypt)
   - Enables HTTPS

**Don't forget**: Point your domain's DNS A record to your VPS IP!

## Troubleshooting

### Deployment Shows "Found application type: python" or "Degraded (unhealthy)"

**Problem**: Coolify is using Nixpacks instead of Docker Compose.

**Symptoms:**
- Deployment logs show "Found application type: python"
- OR build completes but status shows "Degraded (unhealthy)"
- OR build fails with "Nixpacks Cannot Build Paper2Slides" error

**Why This Happens:**
Coolify auto-detected the repository as a Python project and selected Nixpacks build pack. Paper2Slides is a multi-service application (backend + frontend) that requires Docker Compose. Nixpacks can only build single-service apps.

**Solution - Fix Build Pack in Coolify:**

1. **Open Coolify Dashboard** → Go to your Paper2Slides application
2. **Click "Settings"** or **"General"** tab
3. **Find "Build Pack"** setting
4. **Change to**: `Docker Compose` (NOT "Nixpacks" or "Python")
5. **Set "Docker Compose Location"**: `/docker-compose.yml`
6. **Click "Save"**
7. **Click "Redeploy"**

**Verify Success:**
After redeploying, the logs should show:
```
Using Docker Compose
Building services: backend, frontend
Successfully built paper2slides-backend
Successfully built paper2slides-frontend
Status: Healthy ✅
```

**Why?** Paper2Slides is a multi-service application (backend + frontend) that requires Docker Compose. Nixpacks only supports single-service deployments.

For detailed explanation, see [.coolify/IMPORTANT_BUILD_CONFIGURATION.md](./.coolify/IMPORTANT_BUILD_CONFIGURATION.md)



**Why?** Paper2Slides is a multi-service application (backend + frontend) that requires Docker Compose. Nixpacks only supports single-service deployments.

### Build Failed?

**Check**: 
- Docker is running: `docker ps`
- Enough disk space: `df -h`
- View logs in Coolify

### Backend Can't Start?

**Check**:
- `.env` file exists: `/app/paper2slides/.env`
- Environment variables are set correctly
- API keys are valid

### Frontend Can't Connect to Backend?

**Check**:
- Both containers are running: `docker ps`
- Backend health: `curl http://backend:8000/health` (from inside network)
- Check Coolify logs for both services

### Out of Memory?

**Solution**: Add swap space

```bash
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

## Automatic Updates

Enable webhook for auto-deployment:

1. In Coolify, go to **Settings** → **Webhooks**
2. Copy the webhook URL
3. Add to GitHub:
   - Repo → Settings → Webhooks → Add webhook
   - Paste URL, select "Just the push event"

Now every Git push triggers a deployment! 🚀

## What's Next?

- 📚 Read the full [DEPLOYMENT.md](./DEPLOYMENT.md) for advanced configuration
- 🔧 Customize styles and themes
- 📊 Monitor logs and performance
- 🔐 Set up backups

## Need Help?

- 📖 [Full Deployment Guide](./DEPLOYMENT.md)
- 🐛 [Report Issues](https://github.com/HKUDS/Paper2Slides/issues)
- 💬 [Coolify Discord](https://coolify.io/discord)

---

**🎉 Congratulations!** Your Paper2Slides is now live on Hostinger with Coolify!

Transform papers to slides at: `http://your-vps-ip:5173` 🚀
