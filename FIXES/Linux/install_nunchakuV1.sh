#!/bin/bash
# Linux script adapted from the successful Windows batch script.
# This script installs a specific wheel and forces a numpy version.

# Set colors
green="\033[92m"
yellow="\033[93m"
red="\033[91m"
reset="\033[0m"

# Navigate to the correct directory
cd /root/ComfyUI-Easy-Install/ComfyUI-Easy-Install || {
    echo -e "${red}Failed to change directory. Aborting.${reset}"
    exit 1
}

echo -e "${green}Current directory: $(pwd)${reset}"

# Activate the virtual environment
echo -e "${green}Activating virtual environment...${reset}"
source venv/bin/activate
if [ -z "$VIRTUAL_ENV" ]; then
    echo -e "${red}Failed to activate virtual environment. Aborting.${reset}"
    exit 1
fi
echo -e "${green}Virtual environment activated.${reset}"

# Define paths
COMFYUI_DIR="$(pwd)/ComfyUI"
CUSTOM_NODES_DIR="$COMFYUI_DIR/custom_nodes"
NUNCHAKU_NODE_DIR="$CUSTOM_NODES_DIR/ComfyUI-nunchaku"

# Set pip arguments, similar to the Windows script
PIP_ARGS="--no-cache-dir --no-warn-script-location --timeout=1000 --retries 20"

# Step 1: Clean up old installations
echo -e "${yellow}Removing old ComfyUI-nunchaku plugin...${reset}"
rm -rf "$NUNCHAKU_NODE_DIR"
echo -e "${yellow}Uninstalling any previous nunchaku backend...${reset}"
pip uninstall -y nunchaku

# Step 2: Clone the correct plugin repository
echo -e "${green}Cloning the correct ComfyUI-nunchaku plugin...${reset}"
git clone https://github.com/nunchaku-tech/ComfyUI-nunchaku.git "$NUNCHAKU_NODE_DIR"

# Step 3: Install the specific Nunchaku wheel for Linux
echo -e "${green}Installing specific Nunchaku wheel for Linux (v1.0.0 for PyTorch 2.8, Python 3.11)...${reset}"
pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v1.0.0/nunchaku-1.0.0+torch2.8-cp311-cp311-linux_x86_64.whl $PIP_ARGS

# Step 4: Force reinstall numpy version, as done in the Windows script
echo -e "${green}Forcing reinstallation of numpy to version 1.26.4...${reset}"
pip install --force-reinstall numpy==1.26.4 $PIP_ARGS

# Step 5: Verification
echo -e "${green}Verifying Nunchaku backend installation...${reset}"
# Use pip show to verify the version
if pip show nunchaku | grep -q "Version: 1.0.0"; then
    echo -e "${green}✓ Nunchaku v1.0.0 installed successfully!${reset}"
else
    echo -e "${red}Verification failed. Nunchaku v1.0.0 was not installed correctly.${reset}"
    echo -e "${yellow}Please review the output for errors.${reset}"
    exit 1
fi

# Step 6: Install other dependencies
if [ -f "$NUNCHAKU_NODE_DIR/requirements.txt" ]; then
    echo -e "${green}Installing node-specific requirements...${reset}"
    pip install -r "$NUNCHAKU_NODE_DIR/requirements.txt" $PIP_ARGS
fi

echo -e "${green}Windows-adapted installation complete!${reset}"
echo -e "${green}Please restart ComfyUI for the changes to take effect.${reset}"

deactivate
