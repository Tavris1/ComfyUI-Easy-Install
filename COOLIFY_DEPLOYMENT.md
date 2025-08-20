# ComfyUI Easy Install - Coolify Deployment Guide

This guide will help you deploy ComfyUI Easy Install via Coolify, providing a comprehensive AI image generation environment with multiple custom nodes.

## Prerequisites

- Coolify instance running
- Docker and Docker Compose installed on your server
- At least 8GB RAM available for the container
- GPU support (optional but recommended for better performance)

## Quick Deployment

### Option 1: Using Coolify UI (Recommended)

1. **Create New Application in Coolify**
   - Log into your Coolify dashboard
   - Click "New Application" → "Docker Compose"
   - Choose "Git Repository" as source

2. **Repository Configuration**
   - Repository URL: `https://github.com/your-username/ComfyUI-Easy-Install.git`
   - Branch: `main` (or your preferred branch)
   - Build Pack: `Docker Compose`

3. **Environment Variables** (Optional)
   ```
   PYTHONUNBUFFERED=1
   PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512
   ```

4. **Resource Allocation**
   - Memory: 8GB minimum (16GB recommended)
   - CPU: 4 cores minimum
   - Storage: 50GB minimum for models

5. **Port Configuration**
   - Port: `8188`
   - Protocol: `HTTP`

6. **Deploy**
   - Click "Deploy" and wait for the build to complete
   - Access ComfyUI at `http://your-domain:8188`

### Option 2: Manual Docker Compose

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/ComfyUI-Easy-Install.git
   cd ComfyUI-Easy-Install
   ```

2. **Create Required Directories**
   ```bash
   mkdir -p models output input temp user custom_nodes
   ```

3. **Build and Run**
   ```bash
   docker-compose up -d --build
   ```

4. **Access ComfyUI**
   - Open your browser to `http://your-server-ip:8188`

## Configuration

### GPU Support

To enable GPU support, uncomment the following lines in `docker-compose.yml`:

```yaml
# runtime: nvidia
# environment:
#   - NVIDIA_VISIBLE_DEVICES=all
#   - NVIDIA_DRIVER_CAPABILITIES=compute,utility
```

### Model Management

Models are stored in the `./models` directory and are automatically mounted into the container. You can:

1. **Download Models via ComfyUI Manager**
   - Access ComfyUI web interface
   - Go to "Manager" tab
   - Install models from the community

2. **Manual Model Installation**
   - Place model files in the `./models` directory
   - Restart the container: `docker-compose restart`

### Custom Nodes

The installation includes many custom nodes from the Pixaroma community:
- ComfyUI Manager
- WAS Node Suite
- Easy Use
- ControlNet Aux
- Comfyroll Studio
- Crystools
- And many more...

## Monitoring and Maintenance

### Health Checks
The container includes health checks that monitor ComfyUI availability:
- Interval: 30 seconds
- Timeout: 10 seconds
- Retries: 3
- Start period: 60 seconds

### Logs
View container logs:
```bash
docker-compose logs -f comfyui-easy-install
```

### Updates
To update ComfyUI and custom nodes:
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## Troubleshooting

### Common Issues

1. **Out of Memory Errors**
   - Increase container memory limit in Coolify
   - Reduce batch sizes in workflows
   - Use smaller models

2. **GPU Not Detected**
   - Ensure NVIDIA Docker runtime is installed
   - Check GPU drivers are up to date
   - Verify `nvidia-smi` works on host

3. **Slow Performance**
   - Enable GPU support
   - Increase CPU allocation
   - Use SSD storage for models

4. **Port Already in Use**
   - Change port in docker-compose.yml
   - Update Coolify port configuration

### Performance Optimization

1. **Memory Management**
   ```yaml
   environment:
     - PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512
   ```

2. **Storage Optimization**
   - Use SSD storage for models
   - Regular cleanup of output directory
   - Compress old outputs

3. **Network Optimization**
   - Use local model storage
   - Configure proper DNS resolution

## Security Considerations

1. **Network Security**
   - Use reverse proxy (Nginx/Traefik)
   - Enable SSL/TLS
   - Configure firewall rules

2. **Access Control**
   - Implement authentication if needed
   - Restrict network access
   - Regular security updates

3. **Data Protection**
   - Regular backups of models and outputs
   - Secure storage of sensitive data
   - Monitor resource usage

## Support

For issues specific to ComfyUI Easy Install:
- GitHub Issues: [ComfyUI-Easy-Install](https://github.com/Tavris1/ComfyUI-Easy-Install/issues)
- Discord: [Pixaroma Community](https://discord.com/invite/gggpkVgBf3)

For Coolify-specific issues:
- Coolify Documentation: [docs.coolify.io](https://docs.coolify.io)
- Coolify Discord: [discord.gg/coolify](https://discord.gg/coolify)
