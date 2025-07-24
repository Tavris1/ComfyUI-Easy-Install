#!/bin/bash

# Set colors
green="\033[92m"
yellow="\033[93m"
reset="\033[0m"

# Navigate to ComfyUI-Easy-Install directory
cd /root/ComfyUI-Easy-Install

echo -e "${green}::::::::::::::: Installing ${yellow}ComfyUI-nunchaku ${green}::::::::::::::${reset}"
echo ""
git clone https://github.com/mit-han-lab/ComfyUI-nunchaku /root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI/custom_nodes/ComfyUI-nunchaku
echo ""

echo -e "${green}::::::::::::::: Installing ${yellow}Required Dependencies${green} ::::::::::::::${reset}"
echo ""

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${yellow}Python 3 not found. Installing Python 3...${reset}"
    apt update
    apt install -y python3 python3-pip python3-venv
fi

# Install pylatexenc for kokoro
echo "Installing pylatexenc..."
python3 -m pip install pylatexenc

# Install onnxruntime
echo "Installing onnxruntime..."
python3 -m pip install onnxruntime

# Install flet
echo "Installing flet..."
python3 -m pip install flet

# Install Nunchaku
echo "Installing Nunchaku..."
# For Linux, we need to find the appropriate wheel or install from source
# First, try to find a compatible wheel
TORCH_VERSION=$(python3 -c "import torch; print(torch.__version__.split('+')[0])" 2>/dev/null || echo "unknown")
PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
ARCH=$(uname -m)

echo "Detected: Python ${PYTHON_VERSION}, PyTorch ${TORCH_VERSION}, Architecture ${ARCH}"

# Try to install the latest version from GitHub
if [ "$ARCH" = "x86_64" ]; then
    # Try to find a compatible wheel for x86_64 Linux
    echo "Attempting to install Nunchaku from wheel..."
    python3 -m pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp311-cp311-linux_x86_64.whl || \
    python3 -m pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp310-cp310-linux_x86_64.whl || \
    python3 -m pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp39-cp39-linux_x86_64.whl || \
    echo "Could not find a compatible wheel. You may need to build from source."
elif [ "$ARCH" = "aarch64" ]; then
    # Try to find a compatible wheel for ARM64 Linux
    echo "Attempting to install Nunchaku from wheel for ARM64..."
    python3 -m pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp311-cp311-linux_aarch64.whl || \
    python3 -m pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp310-cp310-linux_aarch64.whl || \
    python3 -m pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp39-cp39-linux_aarch64.whl || \
    echo "Could not find a compatible wheel. You may need to build from source."
else
    echo "Unsupported architecture: ${ARCH}. You may need to build from source."
fi

# Check if nunchaku was installed successfully
if python3 -c "import nunchaku" &> /dev/null; then
    echo -e "${green}Nunchaku installed successfully!${reset}"
else
    echo -e "${yellow}Warning: Nunchaku may not have been installed correctly.${reset}"
    echo "You may need to build it from source or find a compatible wheel."
    echo "Check the Nunchaku GitHub repository for more information: https://github.com/nunchaku-tech/nunchaku"
fi

echo ""
echo -e "${green}Installation complete!${reset}"
echo "You may need to restart ComfyUI for the changes to take effect."
echo ""
