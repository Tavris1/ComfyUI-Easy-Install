#!/bin/bash
# Script to install PyTorch 2.8.0 in the ComfyUI virtual environment

# Set colors
green="\033[92m"
yellow="\033[93m"
red="\033[91m"
reset="\033[0m"

# Create a temporary script with the exact commands that work
cat > /tmp/install_pytorch_inside.sh << 'EOF'
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

# Check current PyTorch version
echo -e "\033[92mChecking current PyTorch version...\033[0m"
python -c "import torch; print(f'Current PyTorch version: {torch.__version__}')" 2>/dev/null || echo "PyTorch not installed"

# Uninstall current PyTorch
echo -e "\033[92mUninstalling current PyTorch...\033[0m"
pip uninstall -y torch torchvision torchaudio

# Install PyTorch 2.8.0
echo -e "\033[92mInstalling PyTorch 2.8.0 stable with compatible torchvision and torchaudio...\033[0m"

# Force install CUDA 12.8 version of PyTorch 2.8.0
echo -e "\033[92mInstalling PyTorch 2.8.0 with CUDA 12.8 support\033[0m"
pip install torch==2.8.0+cu128 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128

# Verify installation
echo -e "\033[92mVerifying PyTorch installation...\033[0m"
python -c "import torch; print(f'Installed PyTorch version: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}'); print(f'SDPA available: {hasattr(torch.nn.functional, \"scaled_dot_product_attention\")}')"

# Deactivate the virtual environment
deactivate

echo -e "\033[92mPyTorch 2.8.0 installation complete!\033[0m"
EOF

# Make the temporary script executable
chmod +x /tmp/install_pytorch_inside.sh

# Copy the script to the container
echo -e "${green}Copying installation script to container...${reset}"
pct push 100 /tmp/install_pytorch_inside.sh /root/install_pytorch_inside.sh --perms 755

# Execute the script inside the container
echo -e "${green}Executing installation script inside container...${reset}"
pct exec 100 -- bash -c '/root/install_pytorch_inside.sh'

# Clean up
rm /tmp/install_pytorch_inside.sh
echo -e "${green}PyTorch 2.8.0 installation process completed.${reset}"
