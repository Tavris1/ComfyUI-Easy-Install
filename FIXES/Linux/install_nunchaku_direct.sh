#!/bin/bash
# Direct script to install ComfyUI-nunchaku and its dependencies
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

# Define paths
COMFYUI_DIR="$(pwd)/ComfyUI"
CUSTOM_NODES_DIR="$COMFYUI_DIR/custom_nodes"
NUNCHAKU_DIR="$CUSTOM_NODES_DIR/ComfyUI-nunchaku"

# Create custom_nodes directory if it doesn't exist
if [ ! -d "$CUSTOM_NODES_DIR" ]; then
    echo -e "${green}Creating custom_nodes directory${reset}"
    mkdir -p "$CUSTOM_NODES_DIR"
fi

# Clone or update the repository
if [ ! -d "$NUNCHAKU_DIR" ]; then
    echo -e "${green}Cloning ComfyUI-nunchaku repository${reset}"
    git clone https://github.com/mit-han-lab/ComfyUI-nunchaku "$NUNCHAKU_DIR"
else
    echo -e "${green}Updating existing ComfyUI-nunchaku repository${reset}"
    cd "$NUNCHAKU_DIR" && git pull
    cd - > /dev/null
fi

# Install dependencies
echo -e "${green}Installing dependencies...${reset}"
pip install pylatexenc
pip install onnxruntime
pip install flet

# Check PyTorch version
TORCH_VERSION=$(python -c "import torch; print(torch.__version__.split('+')[0])" 2>/dev/null)
echo -e "${green}Detected PyTorch version: ${TORCH_VERSION}${reset}"

# Install Nunchaku Python package
echo -e "${green}Installing Nunchaku Python package...${reset}"
ARCH=$(uname -m)
PYTHON_VERSION=$(python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo -e "${green}Detected: Python ${PYTHON_VERSION}, Architecture ${ARCH}${reset}"

# Try to install pre-built wheels first
WHEEL_INSTALLED=false

if [ "$ARCH" = "x86_64" ]; then
    echo -e "${green}Trying pre-built wheels for x86_64...${reset}"
    pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp311-cp311-linux_x86_64.whl && WHEEL_INSTALLED=true || \
    pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp310-cp310-linux_x86_64.whl && WHEEL_INSTALLED=true || \
    pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp39-cp39-linux_x86_64.whl && WHEEL_INSTALLED=true || \
    echo -e "${yellow}Could not install pre-built wheels${reset}"
elif [ "$ARCH" = "aarch64" ]; then
    echo -e "${green}Trying pre-built wheels for aarch64...${reset}"
    pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp311-cp311-linux_aarch64.whl && WHEEL_INSTALLED=true || \
    pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp310-cp310-linux_aarch64.whl && WHEEL_INSTALLED=true || \
    pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp39-cp39-linux_aarch64.whl && WHEEL_INSTALLED=true || \
    echo -e "${yellow}Could not install pre-built wheels${reset}"
fi

# If wheels failed, try to install from source
if [ "$WHEEL_INSTALLED" = "false" ]; then
    echo -e "${green}Attempting to install Nunchaku from source...${reset}"
    
    # Clone the Nunchaku repository
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    git clone https://github.com/nunchaku-tech/nunchaku.git
    cd nunchaku
    
    # Install from source
    echo -e "${green}Building and installing Nunchaku from source...${reset}"
    pip install -e .
    
    # Return to original directory
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
fi

# Install the ComfyUI-nunchaku node
echo -e "${green}Installing ComfyUI-nunchaku node...${reset}"
if [ -d "$NUNCHAKU_DIR" ]; then
    cd "$NUNCHAKU_DIR"
    
    # Install any requirements for the node
    if [ -f "requirements.txt" ]; then
        echo -e "${green}Installing node requirements...${reset}"
        pip install -r requirements.txt --use-pep517
    fi
    
    # Run any setup script if it exists
    if [ -f "setup.py" ]; then
        echo -e "${green}Running setup.py...${reset}"
        pip install -e .
    fi
    
    # Return to the original directory
    cd - > /dev/null
    
    echo -e "${green}ComfyUI-nunchaku node installed successfully!${reset}"
else
    echo -e "${red}Failed to find ComfyUI-nunchaku directory${reset}"
fi

# Check if Nunchaku was installed
if python -c "import nunchaku" 2>/dev/null; then
    echo -e "${green}Nunchaku Python package was installed successfully!${reset}"
    
    # Print version information
    echo -e "${green}Nunchaku version information:${reset}"
    python -c "import nunchaku; print(f'Nunchaku version: {nunchaku.__version__}')" 2>/dev/null || echo "Version information not available"
else
    echo -e "${yellow}Warning: Nunchaku Python package may not have been installed correctly${reset}"
fi

# Deactivate the virtual environment
deactivate

echo -e "${green}Installation complete!${reset}"
echo -e "${green}You may need to restart ComfyUI for the changes to take effect.${reset}"
