#!/bin/bash
# Nunchaku installer for ComfyUI Easy Install - Linux version
# Converted from Windows batch script
# Pixaroma Community Edition

node_name="Nunchaku"
echo "Installing '$node_name' for 'ComfyUI Easy Install' by ivo"
echo ":: Pixaroma Community Edition ::"
echo

# Set colors
warning="\033[33m"
red="\033[91m"
green="\033[92m"
yellow="\033[93m"
bold="\033[1m"
reset="\033[0m"

# Set pip arguments
PIPargs="--no-cache-dir --no-warn-script-location --timeout=1000 --retries 200 --use-pep517"

# Function to check if we're in the correct directory structure
check_directory() {
    # Check if we're in a ComfyUI-Easy-Install directory structure
    if [ -f "../ComfyUI/main.py" ] && [ -d "../venv" ]; then
        echo -e "${green}::::::::::::::: Found ComfyUI installation${reset}"
        return 0
    elif [ -f "ComfyUI/main.py" ] && [ -d "venv" ]; then
        echo -e "${green}::::::::::::::: Found ComfyUI installation in current directory${reset}"
        return 0
    else
        echo -e "${red}::::::::::::::: Run this file from the ComfyUI-Easy-Install directory or its subdirectory${reset}"
        echo -e "${green}::::::::::::::: Press any key to exit...${reset}"
        read -n 1
        exit 1
    fi
}

# Function to activate virtual environment
activate_venv() {
    if [ -f "../venv/bin/activate" ]; then
        echo -e "${green}::::::::::::::: Activating virtual environment...${reset}"
        source ../venv/bin/activate
        PYTHON_PATH="python3"
        COMFYUI_PATH="../ComfyUI"
    elif [ -f "venv/bin/activate" ]; then
        echo -e "${green}::::::::::::::: Activating virtual environment...${reset}"
        source venv/bin/activate
        PYTHON_PATH="python3"
        COMFYUI_PATH="ComfyUI"
    else
        echo -e "${red}::::::::::::::: Virtual environment not found${reset}"
        exit 1
    fi
    
    if [ -z "$VIRTUAL_ENV" ]; then
        echo -e "${red}::::::::::::::: Failed to activate virtual environment${reset}"
        exit 1
    fi
}

# Function to clear pip cache
clear_pip_cache() {
    echo -e "${green}::::::::::::::: Clearing Pip Cache${reset}"
    pip cache purge 2>/dev/null || true
    echo -e "${green}::::::::::::::: Clearing Pip Cache ${yellow}Done${reset}"
    echo
}

# Function to get versions
get_versions() {
    echo -e "${green}::::::::::::::: Checking ${yellow}Python, Torch and CUDA ${green}versions${reset}"
    echo
    
    # Python version
    PYTHON_VERSION=$($PYTHON_PATH -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    
    # Torch version
    TORCH_VERSION=$($PYTHON_PATH -c "import torch; print('.'.join(torch.__version__.split('.')[:2]))" 2>/dev/null || echo "unknown")
    
    # CUDA version
    CUDA_VERSION=$($PYTHON_PATH -c "import torch; print('.'.join(torch.version.cuda.split('.')[:2]) if torch.cuda.is_available() and torch.version.cuda else 'Not available')" 2>/dev/null || echo "Not available")
    
    echo -e "${green}::::::::::::::: Python Version:${yellow} $PYTHON_VERSION${reset}"
    echo -e "${green}::::::::::::::: Torch Version:${yellow} $TORCH_VERSION${reset}"
    echo -e "${green}::::::::::::::: CUDA Version:${yellow} $CUDA_VERSION${reset}"
    echo
    
    WARNINGS=0
    
    if [[ "$PYTHON_VERSION" != "3.11" && "$PYTHON_VERSION" != "3.12" ]]; then
        echo -e "${warning}WARNING: ${red}Python $PYTHON_VERSION is not supported. ${green}Supported versions: 3.11, 3.12${reset}"
        WARNINGS=1
    fi
    
    if [[ "$TORCH_VERSION" != "2.7" && "$TORCH_VERSION" != "2.8" ]]; then
        echo -e "${warning}WARNING: ${red}Torch $TORCH_VERSION is not supported. ${green}Supported versions: 2.7, 2.8${reset}"
        WARNINGS=1
    fi
    
    if [[ "$CUDA_VERSION" != "12.8" ]]; then
        echo -e "${warning}WARNING: ${red}CUDA $CUDA_VERSION is not supported. ${green}Supported version: 12.8${reset}"
        WARNINGS=1
    fi
    
    if [ $WARNINGS -eq 0 ]; then
        echo -e "${green}::::::::::::::: ${bold}All versions are supported!${reset}"
        echo
    else
        echo
        echo -e "${red}::::::::::::::: Press any key to exit${reset}"
        read -n 1
        exit 1
    fi
}

# Function to create nunchaku_versions.json
create_nunchaku_versions() {
    local NUNCHAKU_VERSIONS_JSON="$COMFYUI_PATH/custom_nodes/ComfyUI-nunchaku/nunchaku_versions.json"
    
    cat > "$NUNCHAKU_VERSIONS_JSON" << 'EOF'
{
  "versions": [
    "1.0.1",
    "1.0.0",
    "0.3.2",
    "0.3.1",
    "0.3.0",
    "0.2.0",
    "0.1.4",
    "0.1.3",
    "0.1.2"
  ],
  "dev_versions": [
    "1.0.1.dev20250930",
    "1.0.1.dev20250929",
    "1.0.1.dev20250926",
    "1.0.1.dev20250924",
    "1.0.1.dev20250923",
    "1.0.1.dev20250921",
    "1.0.1.dev20250920",
    "1.0.1.dev20250912",
    "1.0.0.dev20250904",
    "1.0.0.dev20250903",
    "1.0.0.dev20250902",
    "1.0.0.dev20250830",
    "1.0.0.dev20250823",
    "1.0.0.dev20250820",
    "1.0.0.dev20250816"
  ],
  "supported_torch": [
    "torch2.5",
    "torch2.6",
    "torch2.7",
    "torch2.8",
    "torch2.9"
  ],
  "supported_python": [
    "cp310",
    "cp311",
    "cp312",
    "cp313"
  ],
  "filename_template": "nunchaku-{version}+{torch_version}-{python_version}-{python_version}-{platform}.whl",
  "url_templates": {
    "github": "https://github.com/nunchaku-tech/nunchaku/releases/download/{version_tag}/{filename}",
    "huggingface": "https://huggingface.co/nunchaku-tech/nunchaku/resolve/main/{filename}",
    "modelscope": "https://modelscope.cn/models/nunchaku-tech/nunchaku/resolve/master/{filename}"
  }
}
EOF
}

# Main installation process
check_directory
activate_venv
clear_pip_cache
get_versions

# Installing Nunchaku
echo -e "${green}::::::::::::::: Installing${yellow} $node_name${reset}"
echo

# Remove existing installation
if [ -d "$COMFYUI_PATH/custom_nodes/ComfyUI-nunchaku" ]; then
    rm -rf "$COMFYUI_PATH/custom_nodes/ComfyUI-nunchaku"
fi

# Clone repository
git clone https://github.com/mit-han-lab/ComfyUI-nunchaku "$COMFYUI_PATH/custom_nodes/ComfyUI-nunchaku"

echo

# Install Nunchaku wheel
# Remove old nunchaku installations
pip uninstall -y nunchaku 2>/dev/null || true

# Determine wheel filename based on versions
if [[ "$PYTHON_VERSION" == "3.11" && "$TORCH_VERSION" == "2.7" ]]; then
    NUNCHAKU_WHL="nunchaku-1.0.1+torch2.7-cp311-cp311-linux_x86_64.whl"
elif [[ "$PYTHON_VERSION" == "3.11" && "$TORCH_VERSION" == "2.8" ]]; then
    NUNCHAKU_WHL="nunchaku-1.0.1+torch2.8-cp311-cp311-linux_x86_64.whl"
elif [[ "$PYTHON_VERSION" == "3.12" && "$TORCH_VERSION" == "2.7" ]]; then
    NUNCHAKU_WHL="nunchaku-1.0.1+torch2.7-cp312-cp312-linux_x86_64.whl"
elif [[ "$PYTHON_VERSION" == "3.12" && "$TORCH_VERSION" == "2.8" ]]; then
    NUNCHAKU_WHL="nunchaku-1.0.1+torch2.8-cp312-cp312-linux_x86_64.whl"
else
    echo -e "${red}::::::::::::::: No compatible wheel found for Python $PYTHON_VERSION and Torch $TORCH_VERSION${reset}"
    exit 1
fi

echo -e "${green}::::::::::::::: Installing wheel: $NUNCHAKU_WHL${reset}"
$PYTHON_PATH -m pip install "https://github.com/nunchaku-tech/nunchaku/releases/download/v1.0.1/$NUNCHAKU_WHL" $PIPargs

# Create nunchaku_versions.json
create_nunchaku_versions

# Force reinstall numpy
echo -e "${green}::::::::::::::: Force reinstalling numpy==1.26.4${reset}"
$PYTHON_PATH -m pip install --force-reinstall numpy==1.26.4 --no-deps $PIPargs

# Final Messages
echo
echo -e "${green}:::::::::::::::${yellow} $node_name ${green}Installation Complete${reset}"
echo

if [ "$1" = "" ]; then
    echo -e "${green}::::::::::::::: ${yellow}Press any key to exit${reset}"
    read -n 1
fi
