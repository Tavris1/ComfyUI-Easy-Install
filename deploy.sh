#!/bin/bash

# ComfyUI Easy Install Deployment Script for Coolify
# This script helps with deployment and setup

set -e

echo "🚀 ComfyUI Easy Install - Coolify Deployment"
echo "============================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create required directories
echo "📁 Creating required directories..."
mkdir -p models output input temp user custom_nodes

# Set proper permissions
echo "🔐 Setting permissions..."
chmod 755 models output input temp user custom_nodes

# Build and start the container
echo "🔨 Building and starting ComfyUI Easy Install..."
docker-compose up -d --build

# Wait for the container to be ready
echo "⏳ Waiting for ComfyUI to start..."
sleep 30

# Check if the container is running
if docker-compose ps | grep -q "Up"; then
    echo "✅ ComfyUI Easy Install is running!"
    echo ""
    echo "🌐 Access ComfyUI at: http://localhost:8188"
    echo ""
    echo "📊 Container status:"
    docker-compose ps
    echo ""
    echo "📝 View logs: docker-compose logs -f"
    echo "🛑 Stop: docker-compose down"
    echo "🔄 Restart: docker-compose restart"
else
    echo "❌ Failed to start ComfyUI Easy Install"
    echo "📝 Check logs: docker-compose logs"
    exit 1
fi
