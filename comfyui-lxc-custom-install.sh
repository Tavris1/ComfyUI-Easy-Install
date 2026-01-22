#!/bin/bash

# ComfyUI LXC Installation with Custom PyTorch/CUDA Support
# Based on your comfyui-lxc-standalone.sh with enhanced options

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration Options
PYTORCH_VERSION="2.9.1"
TORCHVISION_VERSION="0.24.1"
TORCHAUDIO_VERSION="2.9.1"
CUDA_VERSION="cu130"  # Options: cu130, cu121, cu118, cpu
INSTALL_FLASH_ATTN="yes"
GPU_PASSTHROUGH="yes"

echo -e "${BLUE}=== ComfyUI LXC Custom Installation ===${NC}"
echo ""

# PyTorch Configuration
echo -e "${YELLOW}PyTorch Configuration:${NC}"
echo "1. Default (PyTorch $PYTORCH_VERSION, CUDA $CUDA_VERSION)"
echo "2. CUDA 12.1 (PyTorch 2.5.1)"
echo "3. CPU Only (PyTorch latest)"
echo "4. Custom version"

read -p "Select PyTorch option [1-4]: " TORCH_CHOICE

case $TORCH_CHOICE in
    1)
        # Use defaults
        ;;
    2)
        PYTORCH_VERSION="2.5.1"
        TORCHVISION_VERSION="0.20.1"
        TORCHAUDIO_VERSION="2.5.1"
        CUDA_VERSION="cu121"
        ;;
    3)
        PYTORCH_VERSION="latest"
        CUDA_VERSION="cpu"
        ;;
    4)
        read -p "Enter PyTorch version (e.g., 2.9.1): " PYTORCH_VERSION
        read -p "Enter Torchvision version (e.g., 0.24.1): " TORCHVISION_VERSION
        read -p "Enter CUDA version (cu130/cu121/cu118/cpu): " CUDA_VERSION
        ;;
esac

echo -e "${GREEN}✓ Selected: PyTorch $PYTORCH_VERSION, CUDA $CUDA_VERSION${NC}"

# Flash Attention
read -p "Install Flash Attention? [y/N]: " FLASH_CHOICE
if [[ $FLASH_CHOICE =~ ^[Yy]$ ]]; then
    INSTALL_FLASH_ATTN="yes"
else
    INSTALL_FLASH_ATTN="no"
fi

# GPU Passthrough
read -p "Configure GPU passthrough? [Y/n]: " GPU_CHOICE
if [[ $GPU_CHOICE =~ ^[Nn]$ ]]; then
    GPU_PASSTHROUGH="no"
fi

echo ""
echo -e "${BLUE}=== Installation Summary ===${NC}"
echo "PyTorch: $PYTORCH_VERSION"
echo "CUDA: $CUDA_VERSION"
echo "Flash Attention: $INSTALL_FLASH_ATTN"
echo "GPU Passthrough: $GPU_PASSTHROUGH"
echo ""

# Create installation script for container
cat > install_comfyui_custom.sh << 'EOF'
#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Updating system...${NC}"
apt-get update
apt-get upgrade -y

echo -e "${BLUE}Installing system dependencies...${NC}"
apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    cmake \
    software-properties-common \
    gnupg2 \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev

echo -e "${BLUE}Creating Python environment...${NC}"
python3 -m venv /opt/comfyui/venv
source /opt/comfyui/venv/bin/activate

echo -e "${BLUE}Installing uv for faster installs...${NC}"
pip install uv==0.9.7

echo -e "${BLUE}Installing PyTorch...${NC}"
if [ "$PYTORCH_VERSION" = "latest" ]; then
    if [ "$CUDA_VERSION" = "cpu" ]; then
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
    else
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
    fi
else
    pip install torch==$PYTORCH_VERSION torchvision==$TORCHVISION_VERSION torchaudio==$TORCHAUDIO_VERSION --index-url https://download.pytorch.org/whl/$CUDA_VERSION
fi

echo -e "${BLUE}Installing ComfyUI...${NC}"
cd /opt/comfyui
git clone https://github.com/Comfy-Org/ComfyUI.git
cd ComfyUI

echo -e "${BLUE}Installing ComfyUI requirements...${NC}"
uv pip install -r requirements.txt

echo -e "${BLUE}Installing additional packages...${NC}"
uv pip install pygit2
uv pip install av==16.0.1

if [ "$INSTALL_FLASH_ATTN" = "yes" ]; then
    echo -e "${BLUE}Installing Flash Attention...${NC}"
    uv pip install flash-attn --no-build-isolation
fi

echo -e "${BLUE}Installing custom nodes...${NC}"
# ComfyUI Manager
git clone https://github.com/Comfy-Org/ComfyUI-Manager custom_nodes/ComfyUI-Manager
# Add other custom nodes as needed

echo -e "${BLUE}Creating systemd service...${NC}"
cat > /etc/systemd/system/comfyui.service << 'SERVICE'
[Unit]
Description=ComfyUI Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/comfyui/ComfyUI
Environment=PATH=/opt/comfyui/venv/bin
ExecStart=/opt/comfyui/venv/bin/python main.py --listen 0.0.0.0 --port 8188
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable comfyui

echo -e "${GREEN}✓ ComfyUI installation complete!${NC}"
echo -e "${YELLOW}Start with: systemctl start comfyui${NC}"
echo -e "${YELLOW}Access at: http://$(hostname -I | awk '{print $1}'):8188${NC}"
EOF

# Make the script executable
chmod +x install_comfyui_custom.sh

echo -e "${GREEN}✓ Installation script created: install_comfyui_custom.sh${NC}"
echo -e "${YELLOW}Run this inside your LXC container to install ComfyUI${NC}"
echo ""

# Export variables for the installation script
export PYTORCH_VERSION
export TORCHVISION_VERSION  
export TORCHAUDIO_VERSION
export CUDA_VERSION
export INSTALL_FLASH_ATTN

echo -e "${BLUE}=== Next Steps ===${NC}"
echo "1. Create LXC container or use existing one"
echo "2. Copy install_comfyui_custom.sh to container"
echo "3. Run: bash install_comfyui_custom.sh"
echo "4. Configure GPU passthrough if needed"
echo ""
