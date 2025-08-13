#!/bin/bash
# Adapted for Proxmox LXC ComfyUI installation

# Set colors
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
RED='\033[0;91m'
RESET='\033[0m'

# Set arguments
PIP_ARGS="--no-cache-dir --no-warn-script-location --timeout=1000 --retries 200"

# --- Configuration ---
# Define installation paths
COMFYUI_EASY_INSTALL_DIR="/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install"
VENV_DIR="$COMFYUI_EASY_INSTALL_DIR/venv"
COMFYUI_DIR="$COMFYUI_EASY_INSTALL_DIR/ComfyUI"

# --- Sanity Checks ---
echo -e "${YELLOW}Verifying installation paths...${RESET}"
if [ ! -d "$COMFYUI_EASY_INSTALL_DIR" ]; then
    echo -e "${RED}Error: ComfyUI base directory not found at $COMFYUI_EASY_INSTALL_DIR${RESET}"
    exit 1
fi
if [ ! -f "$VENV_DIR/bin/activate" ]; then
    echo -e "${RED}Error: Python virtual environment not found at $VENV_DIR${RESET}"
    exit 1
fi
echo -e "${GREEN}Paths verified.${RESET}"

# --- Main Script ---
# Activate the virtual environment
echo -e "${YELLOW}Activating Python virtual environment...${RESET}"
source "$VENV_DIR/bin/activate"
echo -e "${GREEN}Virtual environment activated.${RESET}"

# Clear Pip Cache
if [ -d "$HOME/.cache/pip" ]; then
    echo -e "${YELLOW}Clearing Pip cache...${RESET}"
    rm -rf "$HOME/.cache/pip"
    mkdir -p "$HOME/.cache/pip"
    echo -e "${GREEN}Pip cache cleared.${RESET}"
fi

# Installing Triton
echo -e "${GREEN}::::::::::::::: Installing/Updating${YELLOW} Triton ${GREEN}:::::::::::::::${RESET}"
echo
python3 -m pip install --upgrade --force-reinstall triton==3.3.1 ${PIP_ARGS}
echo

# Installing SageAttention for Linux
echo -e "${GREEN}::::::::::::::: Installing${YELLOW} SageAttention ${GREEN}:::::::::::::::${RESET}"
echo
# Check if a local wheel file path is provided as the first argument
if [ -n "$1" ] && [ -f "$1" ]; then
    echo -e "${YELLOW}Installing from local wheel file: $1${RESET}"
    python3 -m pip install --upgrade --force-reinstall "$1" ${PIP_ARGS}
else
    echo -e "${YELLOW}No local wheel file provided. Installing from public repository.${RESET}"
    python3 -m pip install sageattention ${PIP_ARGS}
fi
echo

# Creating run_nvidia_gpu_SageAttention.sh file
LAUNCHER_SCRIPT_PATH="/root/ComfyUI-Easy-Install/run_nvidia_gpu_SageAttention.sh"
echo -e "${YELLOW}Creating launcher script at $LAUNCHER_SCRIPT_PATH...${RESET}"
cat > "$LAUNCHER_SCRIPT_PATH" <<EOL
#!/bin/bash
# Launcher for ComfyUI with SageAttention

COMFYUI_DIR="/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI"
VENV_DIR="/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/venv"

# Activate venv and launch ComfyUI
source "\$VENV_DIR/bin/activate"
cd "\$COMFYUI_DIR"

# Use --listen to allow access from other computers on the network
python main.py --use-sage-attention --listen 
EOL

chmod +x "$LAUNCHER_SCRIPT_PATH"

echo -e "${GREEN}Installation and setup complete.${RESET}"
echo -e "You can now run ComfyUI with SageAttention using the new script:
${YELLOW}${LAUNCHER_SCRIPT_PATH}${RESET}"
echo -e "${GREEN}:::::::::::::::::::::: Installation Complete :::::::::::::::::::::${RESET}"
echo
echo -e "${YELLOW}:::::::::::::::::::::: You can now run 'run_nvidia_gpu_SageAttention.sh' :::::::::::::::::::::${RESET}"
echo -e "${YELLOW}:::::::::::::::::::::: Press any key to exit :::::::::::::::::::::${RESET}"
read -n 1 -s
exit 0
