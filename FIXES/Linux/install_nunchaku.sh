#!/bin/bash
# Script to install ComfyUI-nunchaku and its dependencies

# Set colors
green="\033[92m"
yellow="\033[93m"
red="\033[91m"
reset="\033[0m"

# Create a temporary script with the exact commands that work
cat > /tmp/install_nunchaku_inside.sh << 'EOF'
#!/bin/bash
# Colors
green="\033[92m"
yellow="\033[93m"
red="\033[91m"
reset="\033[0m"

# Change to the correct directory
cd /ComfyUI-Easy-Install/ComfyUI-Easy-Install || {
    echo -e "\033[91mFailed to change directory to /ComfyUI-Easy-Install/ComfyUI-Easy-Install\033[0m"
    exit 1
}

echo -e "\033[92mCurrent directory: $(pwd)\033[0m"

# Activate the virtual environment
echo -e "\033[92mActivating virtual environment...\033[0m"
source venv/bin/activate

# Verify activation
if [ -z "$VIRTUAL_ENV" ]; then
    echo -e "\033[91mFailed to activate virtual environment\033[0m"
    exit 1
fi
echo -e "\033[92mVirtual environment activated: $VIRTUAL_ENV\033[0m"

# Define paths
COMFYUI_DIR="$(pwd)/ComfyUI"
CUSTOM_NODES_DIR="$COMFYUI_DIR/custom_nodes"
NUNCHAKU_DIR="$CUSTOM_NODES_DIR/ComfyUI-nunchaku"

# Create custom_nodes directory if it doesn't exist
if [ ! -d "$CUSTOM_NODES_DIR" ]; then
    echo -e "\033[92mCreating custom_nodes directory\033[0m"
    mkdir -p "$CUSTOM_NODES_DIR"
fi

# Clone or update the repository
if [ ! -d "$NUNCHAKU_DIR" ]; then
    echo -e "\033[92mCloning ComfyUI-nunchaku repository\033[0m"
    git clone https://github.com/mit-han-lab/ComfyUI-nunchaku "$NUNCHAKU_DIR"
else
    echo -e "\033[92mUpdating existing ComfyUI-nunchaku repository\033[0m"
    cd "$NUNCHAKU_DIR" && git pull
    cd - > /dev/null
fi

# Install dependencies
echo -e "\033[92mInstalling dependencies...\033[0m"
pip install pylatexenc
pip install onnxruntime
pip install flet

# Install Nunchaku Python package
echo -e "\033[92mInstalling Nunchaku Python package...\033[0m"
ARCH=$(uname -m)
PYTHON_VERSION=$(python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo -e "\033[92mDetected: Python ${PYTHON_VERSION}, Architecture ${ARCH}\033[0m"

if [ "$ARCH" = "x86_64" ]; then
    pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp311-cp311-linux_x86_64.whl || \
    pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp310-cp310-linux_x86_64.whl || \
    pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp39-cp39-linux_x86_64.whl || \
    echo -e "\033[93mCould not find a compatible wheel\033[0m"
elif [ "$ARCH" = "aarch64" ]; then
    pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp311-cp311-linux_aarch64.whl || \
    pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp310-cp310-linux_aarch64.whl || \
    pip install https://github.com/nunchaku-tech/nunchaku/releases/download/v0.3.2dev20250715/nunchaku-0.3.2.dev20250715+torch2.7-cp39-cp39-linux_aarch64.whl || \
    echo -e "\033[93mCould not find a compatible wheel\033[0m"
fi

# Install the ComfyUI-nunchaku node
echo -e "\033[92mInstalling ComfyUI-nunchaku node...\033[0m"
if [ -d "$NUNCHAKU_DIR" ]; then
    cd "$NUNCHAKU_DIR"
    
    # Install any requirements for the node
    if [ -f "requirements.txt" ]; then
        echo -e "\033[92mInstalling node requirements...\033[0m"
        pip install -r requirements.txt --use-pep517
    fi
    
    # Run any setup script if it exists
    if [ -f "setup.py" ]; then
        echo -e "\033[92mRunning setup.py...\033[0m"
        pip install -e .
    fi
    
    # Return to the original directory
    cd - > /dev/null
    
    echo -e "\033[92mComfyUI-nunchaku node installed successfully!\033[0m"
else
    echo -e "\033[91mFailed to find ComfyUI-nunchaku directory\033[0m"
fi

# Check if Nunchaku was installed
if python -c "import nunchaku" 2>/dev/null; then
    echo -e "\033[92mNunchaku Python package was installed successfully!\033[0m"
else
    echo -e "\033[93mWarning: Nunchaku Python package may not have been installed correctly\033[0m"
fi

# Deactivate the virtual environment
deactivate

echo -e "\033[92mInstallation complete!\033[0m"
echo -e "\033[92mYou may need to restart ComfyUI for the changes to take effect.\033[0m"
EOF

# Make the temporary script executable
chmod +x /tmp/install_nunchaku_inside.sh

# Copy the script to the container
echo -e "${green}Copying installation script to container...${reset}"
pct push 100 /tmp/install_nunchaku_inside.sh /root/install_nunchaku_inside.sh --perms 755

# Execute the script inside the container
echo -e "${green}Executing installation script inside container...${reset}"
pct exec 100 -- bash -c '/root/install_nunchaku_inside.sh'

# Clean up
rm /tmp/install_nunchaku_inside.sh
echo -e "${green}Installation process completed.${reset}"
