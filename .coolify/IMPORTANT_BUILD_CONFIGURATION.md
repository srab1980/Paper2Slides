# ⚠️ IMPORTANT: Coolify Build Configuration

## Automatic Docker Compose Detection

**Paper2Slides should automatically be detected as a Docker Compose application by Coolify.**

When you deploy Paper2Slides to Coolify, it should automatically detect the `docker-compose.yml` file and use Docker Compose as the build pack. 

### Why Docker Compose is Required

Paper2Slides is a **multi-service application** that requires:
1. **Backend service** (FastAPI/Python) 
2. **Frontend service** (React/Nginx)
3. **Shared networking** between services
4. **Volume mounts** for data persistence

Docker Compose is the only supported deployment method because it properly orchestrates all these services.

### Expected Behavior

#### When Creating the Application in Coolify:

Coolify should automatically:
1. Detect the `docker-compose.yml` file in the repository root
2. Select **Docker Compose** as the build pack
3. Set Docker Compose Location to `/docker-compose.yml`

You should see in the deployment logs:
```
Using Docker Compose
Building services: backend, frontend
Successfully built paper2slides-backend
Successfully built paper2slides-frontend
```

### If Auto-Detection Doesn't Work

If Coolify doesn't automatically detect Docker Compose, you can manually configure it:

#### When Creating the Application:

1. **Click**: `+ New Resource` → `Public Repository` or `Private Repository`
2. **Enter** your repository URL
3. **Select Build Pack**: Choose **`Docker Compose`**
4. **Docker Compose Location**: Set to `/docker-compose.yml`
5. **Branch**: `main`

#### If You Already Created the Application:

1. Go to your application in Coolify dashboard
2. Click **Settings** or **General** tab
3. Look for **Build Pack** setting
4. Change it to `Docker Compose`
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

#### ❌ Incorrect Configuration (Nixpacks):

If Coolify tries to use Nixpacks, the deployment will fail because Paper2Slides requires multiple services (backend + frontend) that can only be orchestrated with Docker Compose.

### Why This Matters

- **Docker Compose** properly orchestrates multi-service applications
- **Nixpacks** is designed for single-service applications and cannot properly deploy Paper2Slides
- The repository structure (with `docker-compose.yml` as the only deployment configuration) should trigger automatic Docker Compose detection in Coolify

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
