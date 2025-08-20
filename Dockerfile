# ComfyUI Easy Install Dockerfile for Coolify
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    git \
    wget \
    curl \
    unzip \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    dnsutils \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy installation files
COPY ComfyUI-Easy-Install-Linux.sh ./
COPY Helper-CEI.zip ./

# Make script executable and run installation
RUN chmod +x ComfyUI-Easy-Install-Linux.sh && \
    ./ComfyUI-Easy-Install-Linux.sh

# Set working directory to ComfyUI installation
WORKDIR /app/ComfyUI-Easy-Install

# Create startup script with better error handling
RUN echo '#!/bin/bash\n\
set -e\n\
cd /app/ComfyUI-Easy-Install\n\
if [ ! -f "venv/bin/activate" ]; then\n\
    echo "Error: Virtual environment not found!"\n\
    exit 1\n\
fi\n\
source venv/bin/activate\n\
if [ ! -f "ComfyUI/main.py" ]; then\n\
    echo "Error: ComfyUI not found!"\n\
    exit 1\n\
fi\n\
echo "Starting ComfyUI..."\n\
exec python ComfyUI/main.py --listen 0.0.0.0 --port 8188 "$@"' > /app/start.sh && \
    chmod +x /app/start.sh

# Create directories for volume mounts
RUN mkdir -p /app/ComfyUI-Easy-Install/ComfyUI/models \
    /app/ComfyUI-Easy-Install/ComfyUI/output \
    /app/ComfyUI-Easy-Install/ComfyUI/input \
    /app/ComfyUI-Easy-Install/ComfyUI/temp \
    /app/ComfyUI-Easy-Install/ComfyUI/user \
    /app/ComfyUI-Easy-Install/ComfyUI/custom_nodes

# Expose port
EXPOSE 8188

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD curl -f http://localhost:8188/ || exit 1

# Start ComfyUI
CMD ["/app/start.sh"]
