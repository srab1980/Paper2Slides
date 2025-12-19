# ⚠️ IMPORTANT: Coolify Build Configuration

## Critical Configuration Requirement

**Paper2Slides MUST be deployed with Docker Compose, NOT Nixpacks!**

### The Problem

When deploying Paper2Slides to Coolify, you might see this in the logs:

```
Found application type: python.
If you need further customization, please check the documentation of Nixpacks
```

This means Coolify is using **Nixpacks** (automatic buildpack detection) instead of **Docker Compose**. 

### Why This Fails

Paper2Slides is a **multi-service application** that requires:
1. **Backend service** (FastAPI/Python) 
2. **Frontend service** (React/Nginx)
3. **Shared networking** between services
4. **Volume mounts** for data persistence

Nixpacks can only build single-service applications. It will detect Paper2Slides as a Python app, build only the backend, and fail to set up the frontend properly.

### The Solution

#### When Creating the Application in Coolify:

1. **Click**: `+ New Resource` → `Public Repository` or `Private Repository`
2. **Enter** your repository URL
3. **CRITICAL STEP**: When asked to select a build pack, choose: **`Docker Compose`**
4. **Set** Docker Compose Location to: `/docker-compose.yml`

#### Diagram of Correct Configuration:

```
Coolify Application Settings
├─ Build Pack: [Docker Compose] ✓ ← MUST SELECT THIS
│
├─ Docker Compose Location: /docker-compose.yml
│
└─ Branch: main
```

#### If You Already Created the Application:

1. Go to your application in Coolify dashboard
2. Click **Settings** or **General** tab
3. Look for **Build Pack** setting
4. Change it from `Nixpacks` to `Docker Compose`
5. Set **Docker Compose Location** to `/docker-compose.yml`
6. Click **Save**
7. **Redeploy** the application

### How to Verify Correct Configuration

#### ✅ Correct Configuration (Docker Compose):

Deployment logs should show:
```
Using Docker Compose
Building services: backend, frontend
Successfully built paper2slides-backend
Successfully built paper2slides-frontend
```

#### ❌ Wrong Configuration (Nixpacks):

Deployment logs will show:
```
Found application type: python.
Generating nixpacks configuration
```

### Additional Notes

- The `Procfile` in the repository root will cause deployment to fail intentionally if Nixpacks is used
- This prevents confusion from a "successful" deployment that doesn't actually work
- If you see the error message from `Procfile`, it means you need to switch to Docker Compose

### Quick Links

- 📚 [Quick Start Guide](../QUICKSTART_COOLIFY.md) - Step-by-step deployment
- 📖 [Full Deployment Guide](../DEPLOYMENT.md) - Comprehensive instructions
- ✅ [Deployment Checklist](./CHECKLIST.md) - Verify all steps

### Still Having Issues?

1. **Check** that both backend and frontend containers are running: `docker ps`
2. **Verify** Docker Compose config is valid: `docker compose config`
3. **Review** deployment logs in Coolify dashboard
4. **Test** health endpoints:
   - Backend: `curl http://your-domain:8000/health`
   - Frontend: `curl http://your-domain:5173/` (or port 80 if using Coolify's domain)

### Support

- 🐛 [Report Issues](https://github.com/HKUDS/Paper2Slides/issues)
- 💬 [Coolify Discord](https://coolify.io/discord)
- 📚 [Coolify Documentation](https://coolify.io/docs)

---

**Remember**: Always use **Docker Compose** as the build pack in Coolify! 🚀
