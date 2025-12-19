# Quick Reference: Coolify Deployment

## ⚡ TL;DR

```
⚠️  MUST select "Docker Compose" build pack in Coolify
❌  Do NOT use Nixpacks (auto-detect will fail)
📋  Docker Compose file location: /docker-compose.yml
```

## 🎯 Correct Configuration

| Setting | Value |
|---------|-------|
| **Build Pack** | `Docker Compose` ⚠️ |
| **Compose File** | `/docker-compose.yml` |
| **Branch** | `main` |

## ❓ How to Check

### ✅ Correct (Docker Compose)
```
Using Docker Compose
Building services: backend, frontend
```

### ❌ Wrong (Nixpacks)
```
Found application type: python.
Generating nixpacks configuration
```

## 🔧 How to Fix

If you see "Found application type: python":

1. Go to **Application Settings** in Coolify
2. Change **Build Pack** → `Docker Compose`
3. Set **Docker Compose Location** → `/docker-compose.yml`
4. Click **Save**
5. Click **Redeploy**

## 📚 Documentation Links

| Guide | Purpose |
|-------|---------|
| [QUICKSTART_COOLIFY.md](../QUICKSTART_COOLIFY.md) | 5-minute setup |
| [IMPORTANT_BUILD_CONFIGURATION.md](./IMPORTANT_BUILD_CONFIGURATION.md) | Why Docker Compose required |
| [DEPLOYMENT.md](../DEPLOYMENT.md) | Full deployment guide |
| [CHECKLIST.md](./CHECKLIST.md) | Step-by-step checklist |

## 🏥 Health Check

After deployment:

```bash
# Backend
curl http://your-domain:8000/health
# Expected: {"status":"healthy"}

# Frontend
curl http://your-domain:5173/
# (or port 80 if using Coolify's domain proxy)
# Expected: 200 OK
```

## 🆘 Quick Help

| Issue | Solution |
|-------|----------|
| "Found application type: python" | Change to Docker Compose |
| Build fails | Check logs, verify Docker Compose |
| .env file missing | Create `/app/paper2slides/.env` |
| Services not starting | Check environment variables |

## 📞 Support

- 🐛 [GitHub Issues](https://github.com/HKUDS/Paper2Slides/issues)
- 💬 [Coolify Discord](https://coolify.io/discord)

---

**Remember**: Always use **Docker Compose** as the build pack! 🚀
