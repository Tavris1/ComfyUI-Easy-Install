#!/bin/bash
# Direct script to install PyTorch 2.8.0 in the ComfyUI virtual environment
# Run this script directly inside the LXC container

# Set colors
green="\033[92m"
yellow="\033[93m"
red="\033[91m"
reset="\033[0m"

# Change to the correct directory
cd /root/ComfyUI-Easy-Install/ComfyUI-Easy-Install || {
    echo -e "${red}Failed to change directory to /root/ComfyUI-Easy-Install/ComfyUI-Easy-Install${reset}"
    exit 1
}

echo -e "${green}Current directory: $(pwd)${reset}"

# Activate the virtual environment
echo -e "${green}Activating virtual environment...${reset}"
source venv/bin/activate

# Verify activation
if [ -z "$VIRTUAL_ENV" ]; then
    echo -e "${red}Failed to activate virtual environment${reset}"
    exit 1
fi
echo -e "${green}Virtual environment activated: $VIRTUAL_ENV${reset}"

# Check current PyTorch version
echo -e "${green}Checking current PyTorch version...${reset}"
python -c "import torch; print(f'Current PyTorch version: {torch.__version__}')" 2>/dev/null || echo "PyTorch not installed"

# Uninstall current PyTorch
echo -e "${green}Uninstalling current PyTorch...${reset}"
pip uninstall -y torch torchvision torchaudio

# Install PyTorch 2.8.0
echo -e "${green}Installing PyTorch 2.8.0 stable with compatible torchvision and torchaudio...${reset}"

# Force install CUDA 12.8 version of PyTorch 2.8.0
echo -e "${green}Installing PyTorch 2.8.0 with CUDA 12.8 support${reset}"
pip install torch==2.8.0+cu128 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128

# Verify installation
echo -e "${green}Verifying PyTorch installation...${reset}"
python -c "import torch; print(f'Installed PyTorch version: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}'); print(f'SDPA available: {hasattr(torch.nn.functional, \"scaled_dot_product_attention\")}')"

# Deactivate the virtual environment
deactivate

echo -e "${green}PyTorch 2.8.0 installation complete!${reset}"
