# ⚠️ IMPORTANT: Coolify Build Configuration

## You MUST Manually Select Docker Compose

**Paper2Slides requires Docker Compose as the build pack in Coolify.**

### The Problem

When creating a new application in Coolify, it may auto-detect Paper2Slides as a "Python" project and select "Nixpacks" as the build pack. This is **incorrect** and will cause deployment failures or "degraded (unhealthy)" status.

### Why Docker Compose is Required

Paper2Slides is a **multi-service application** that requires:
1. **Backend service** (FastAPI/Python on port 8000)
2. **Frontend service** (React/Nginx on port 80)
3. **Shared networking** between services
4. **Volume mounts** for data persistence

Docker Compose is the only supported deployment method because it properly orchestrates all these services. Nixpacks can only build single-service applications.

### Manual Configuration Required

**When Creating the Application:**

1. **Click**: `+ New Resource` → `Public Repository` or `Private Repository`
2. **Enter** your repository URL
3. **⚠️ Build Pack**: Manually select **`Docker Compose`** (NOT "Nixpacks" or "Python")
4. **Docker Compose Location**: Set to `/docker-compose.yml`
5. **Branch**: `main`

**If You Already Created the Application with Wrong Build Pack:**

1. Go to your application in Coolify dashboard
2. Click **Settings** or **General** tab
3. Look for **Build Pack** setting
4. Change it from "Nixpacks" to **`Docker Compose`**
5. Set **Docker Compose Location** to `/docker-compose.yml`
6. Click **Save**
7. Click **Redeploy** button

### How to Identify the Problem

#### ❌ Wrong Configuration (Nixpacks):

Deployment logs show:
```
Found application type: python.
Generating nixpacks configuration
```

**Result**: Either build fails with error, OR build succeeds but shows "Degraded (unhealthy)" status.

#### ✅ Correct Configuration (Docker Compose):

Deployment logs should show:
```
Using Docker Compose
Building services: backend, frontend
Successfully built paper2slides-backend
Successfully built paper2slides-frontend
```

**Result**: Both services running, status shows "Healthy" ✅

### Why Auto-Detection May Fail

Coolify's auto-detection looks at repository files:
- Sees `requirements.txt` → detects "Python"
- Sees `package.json` → detects "Node"
- Sees `docker-compose.yml` → detects "Docker Compose"

Some versions of Coolify prioritize language detection over Docker Compose, causing incorrect auto-selection.

### Safety Mechanisms in This Repository

To help prevent incorrect deployments, this repository includes:

1. **nixpacks.toml** - Fails immediately with clear error if Nixpacks is used
2. **Procfile** - Shows error message if Procfile deployment is attempted
3. **Clear documentation** - Multiple guides explaining the requirement

However, these are **fail-safes only** - you still **must manually select Docker Compose** in Coolify.

### Quick Links

- 📚 [Quick Start Guide](../QUICKSTART_COOLIFY.md) - Step-by-step deployment
- 📖 [Full Deployment Guide](../DEPLOYMENT.md) - Comprehensive instructions
- ✅ [Deployment Checklist](./.coolify/CHECKLIST.md) - Verify all steps

### Still Having Issues?

1. **Verify Build Pack** is set to "Docker Compose" in Coolify settings
2. **Check deployment logs** - should say "Using Docker Compose"
3. **Verify both services running**: `docker ps` should show both backend and frontend
4. **Test health endpoints**:
   - Backend: `curl http://localhost:8000/health`
   - Frontend: `curl http://localhost:80/`

### Support

- 🐛 [Report Issues](https://github.com/HKUDS/Paper2Slides/issues)
- 💬 [Coolify Discord](https://coolify.io/discord)
- 📚 [Coolify Documentation](https://coolify.io/docs)

---

**Remember**: You **MUST** manually select **Docker Compose** as the build pack in Coolify! 🚀
