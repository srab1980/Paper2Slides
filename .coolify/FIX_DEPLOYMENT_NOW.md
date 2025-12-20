# 🚨 URGENT: Fix Coolify Deployment "Degraded (Unhealthy)" Status

## The Problem

Your Paper2Slides deployment on Coolify is showing **"Degraded (unhealthy)"** status because Coolify is using the **wrong build pack**.

### What Happened

From your deployment logs:
```
Found application type: python.
Generating nixpacks configuration
...
Building docker image completed.
New container started.
Status: Degraded (unhealthy)
```

**Coolify auto-detected your repository as a "Python" project and used Nixpacks** instead of Docker Compose. This is incorrect because:
- **Nixpacks can only build single-service applications**
- **Paper2Slides has 2 services**: Backend (Python/FastAPI) + Frontend (React/Nginx)
- When Nixpacks is used, only one service gets deployed, causing health check failures

## The Solution (Takes 2 Minutes)

You need to **manually change the build pack to Docker Compose** in Coolify:

### Step-by-Step Fix:

1. **Open Coolify Dashboard** at `http://your-vps-ip:8000`

2. **Navigate to Your Application**
   - Find "My first project" → "production"
   - Click on the Paper2Slides application

3. **Open Settings**
   - Click on "General" or "Settings" tab (depends on Coolify version)

4. **Change Build Pack**
   - Find the "Build Pack" dropdown
   - Currently shows: "Nixpacks" or "Python"
   - **Change to**: **"Docker Compose"**

5. **Set Docker Compose Location**
   - Find "Docker Compose Location" field
   - Enter: `/docker-compose.yml`

6. **Save and Redeploy**
   - Click "Save" button
   - Click "Redeploy" button

### What You Should See After Fix

After redeploying with Docker Compose, your logs should show:

```
Using Docker Compose
Building services: backend, frontend
Successfully built paper2slides-backend
Successfully built paper2slides-frontend
...
Status: Healthy ✅
```

Both services will be running:
- Backend on port 8000
- Frontend on port 80 (or your configured port)

## Why This Happened

Coolify's auto-detection saw:
- ✓ `requirements.txt` (Python files) → Selected "Python/Nixpacks"
- ✓ `docker-compose.yml` (Docker Compose) → **Should have selected this!**

Some versions of Coolify prioritize language detection over Docker Compose detection, causing the wrong build pack to be selected.

## Prevention for Future

After this fix, Coolify will remember your build pack selection. If you:
- Delete and recreate the application → Need to manually select Docker Compose again
- Clone the repo to a new Coolify project → Need to manually select Docker Compose again

## Additional Safety Mechanisms

The latest version of this repository now includes:

1. **`nixpacks.toml`** - If Nixpacks is used, it will fail with a clear error message
2. **`Procfile`** - Prevents Procfile-based deployments with error message
3. **Updated Documentation** - All guides now emphasize manual build pack selection

If you redeploy after pulling the latest changes, Nixpacks builds will fail immediately with:
```
❌ ERROR: Nixpacks Cannot Build Paper2Slides
[Instructions to fix...]
exit 1
```

## Need Help?

- 📖 [Quick Start Guide](../QUICKSTART_COOLIFY.md) - Step-by-step deployment
- 📚 [Full Deployment Guide](../DEPLOYMENT.md) - Comprehensive instructions
- 🔧 [Build Configuration](./IMPORTANT_BUILD_CONFIGURATION.md) - Detailed explanation

## Summary

**What to do NOW:**
1. Go to Coolify dashboard
2. Change Build Pack to "Docker Compose"
3. Set location to "/docker-compose.yml"
4. Save and Redeploy
5. Verify status shows "Healthy" ✅

**Time required**: 2 minutes

**Status after fix**: Both backend and frontend running, healthy status ✅

---

*This is a configuration issue in Coolify, not a bug in Paper2Slides. The manual build pack selection is required and is a one-time setup.*
