# Quick Start Guide - Coolify Deployment

## 🚀 Deploy in 5 Minutes

### Step 1: Prepare Your Repository
1. Fork or clone this repository to your GitHub account
2. Ensure all files are committed and pushed

### Step 2: Coolify Setup
1. Open your Coolify dashboard
2. Click **"New Application"** → **"Docker Compose"**
3. Select **"Git Repository"**

### Step 3: Configuration
- **Repository URL**: `https://github.com/YOUR_USERNAME/ComfyUI-Easy-Install.git`
- **Branch**: `main`
- **Build Pack**: `Docker Compose`
- **Port**: `8188`

### Step 4: Resource Allocation
- **Memory**: 8GB minimum (16GB recommended)
- **CPU**: 4 cores minimum
- **Storage**: 50GB minimum

### Step 5: Deploy
1. Click **"Deploy"**
2. Wait for build to complete (5-10 minutes)
3. Access at `http://your-domain:8188`

## 🎯 What You Get

✅ **ComfyUI** - Advanced AI image generation  
✅ **25+ Custom Nodes** - Extended functionality  
✅ **Model Manager** - Easy model installation  
✅ **Persistent Storage** - Models and outputs saved  
✅ **Health Monitoring** - Automatic health checks  

## 🔧 Quick Commands

```bash
# View logs
docker-compose logs -f

# Restart
docker-compose restart

# Update
docker-compose down && docker-compose up -d --build

# Stop
docker-compose down
```

## 📁 Directory Structure
```
models/          # AI models (persistent)
output/          # Generated images (persistent)
input/           # Input images (persistent)
temp/            # Temporary files
user/            # User configurations
custom_nodes/    # Custom node files
```

## 🆘 Need Help?

- **Documentation**: [COOLIFY_DEPLOYMENT.md](COOLIFY_DEPLOYMENT.md)
- **Issues**: GitHub Issues
- **Community**: [Pixaroma Discord](https://discord.com/invite/gggpkVgBf3)

---
**Ready to create amazing AI art? Deploy now! 🎨**
