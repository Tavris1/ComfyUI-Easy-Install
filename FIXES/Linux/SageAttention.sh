#!/bin/bash
# SageAttention installer for ComfyUI Easy Install - Linux version
# Converted from Windows batch script
# Pixaroma Community Edition

node_name="SageAttention"
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
        BASE_PATH=".."
    elif [ -f "venv/bin/activate" ]; then
        echo -e "${green}::::::::::::::: Activating virtual environment...${reset}"
        source venv/bin/activate
        PYTHON_PATH="python3"
        COMFYUI_PATH="ComfyUI"
        BASE_PATH="."
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
    echo -e "${green}::::::::::::::: Checking ${yellow}Python, Torch, CUDA ${green}versions${reset}"
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

# Main installation process
check_directory
activate_venv
clear_pip_cache
get_versions

# Installing Triton
echo -e "${green}::::::::::::::: Installing${yellow} Triton${reset}"
echo
$PYTHON_PATH -m pip install --upgrade --force-reinstall triton $PIPargs
echo

# Installing SageAttention
echo -e "${green}::::::::::::::: Installing${yellow} $node_name${reset}"
echo

# For Linux, we have two options:
# 1. Install stable version 1.0.6 from PyPI (faster, stable)
# 2. Compile latest version 2.2.0 from source (slower, latest features)

echo -e "${yellow}SageAttention installation options for Linux:${reset}"
echo -e "${yellow}1. Stable version 1.0.6 from PyPI (recommended for most users)${reset}"
echo -e "${yellow}2. Latest version 2.2.0 compiled from source (advanced users)${reset}"
echo

# Check if user wants to compile from source
if [[ "$1" == "--compile-source" ]]; then
    echo -e "${green}::::::::::::::: Compiling SageAttention 2.2.0 from source${reset}"
    echo -e "${yellow}This may take several minutes...${reset}"
    
    # Install build dependencies
    $PYTHON_PATH -m pip install ninja $PIPargs
    
    # Clone and compile
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    git clone https://github.com/thu-ml/SageAttention.git
    cd SageAttention
    
    # Set compilation flags for faster build
    export EXT_PARALLEL=4
    export NVCC_APPEND_FLAGS="--threads 8"
    export MAX_JOBS=8
    
    # Install
    $PYTHON_PATH setup.py install
    
    # Clean up
    cd /
    rm -rf "$TEMP_DIR"
    
    echo -e "${green}::::::::::::::: SageAttention 2.2.0 compiled and installed${reset}"
else
    echo -e "${green}::::::::::::::: Installing SageAttention 1.0.6 from PyPI${reset}"
    echo -e "${yellow}Note: For latest version 2.2.0, run with --compile-source flag${reset}"
    $PYTHON_PATH -m pip install --upgrade --force-reinstall sageattention==1.0.6 $PIPargs
fi

# Creating run_nvidia_gpu_SageAttention.sh file
echo
echo -e "${green}::::::::::::::: Creating${yellow} run_nvidia_gpu_SageAttention.sh${reset}"
echo

# Create the launcher script
cat > "$BASE_PATH/run_nvidia_gpu_SageAttention.sh" << 'EOL'
#!/bin/bash
# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || exit

# Check if ComfyUI directory exists
if [ ! -d "ComfyUI" ]; then
    echo "Error: ComfyUI directory not found!"
    echo "Please run this script from the ComfyUI-Easy-Install directory."
    exit 1
fi

# Activate virtual environment
if [ -f "venv/bin/activate" ]; then
    source venv/bin/activate
else
    echo "Error: Virtual environment not found!"
    exit 1
fi

# Run ComfyUI with SageAttention
echo "Starting ComfyUI with SageAttention..."
python ComfyUI/main.py --use-sage-attention --listen 0.0.0.0 --port 8188 "$@"
EOL

# Make the script executable
chmod +x "$BASE_PATH/run_nvidia_gpu_SageAttention.sh"

# Final Messages
echo
echo -e "${green}:::::::::::::::${yellow} $node_name ${green}Installation Complete${reset}"
echo

if [ "$1" = "" ]; then
    echo -e "${green}::::::::::::::: ${yellow}Press any key to exit${reset}"
    read -n 1
fi
