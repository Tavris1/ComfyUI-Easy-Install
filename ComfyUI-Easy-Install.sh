#!/bin/bash

# Title ComfyUI-Easy-Install  NEXT by ivo v2.01.4
# Pixaroma Community Edition
# macOS and Linux conversion by VenimK

# Set colors
WARNING='\033[33m'
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BOLD='\033[1m'
RESET='\033[0m'

PYTHON_VERSION="3.12"
# And modify the version check to only allow 3.12
if [ "$PYTHON_VERSION" != "3.12" ]; then
    echo ""
    echo -e "${WARNING}WARNING: ${RED}Only Python 3.12 is supported.${RESET}"
    echo ""
    read -p "Press any key to exit"
    exit 1
fi

# Set Ignoring Large File Storage
export GIT_LFS_SKIP_SMUDGE=1
export GIT_TERMINAL_PROMPT=0

# Set arguments
PIP_ARGS="--no-cache-dir --no-warn-script-location --timeout=1000 --retries 10"
CURL_ARGS="--retry 200 --retry-all-errors"
UV_ARGS="--no-cache --link-mode=copy"

# Check for Existing ComfyUI Folder
if [ -d "ComfyUI-Easy-Install" ]; then
    echo -e "${WARNING}WARNING:${RESET} '${BOLD}ComfyUI-Easy-Install${RESET}' folder already exists!"
    echo -e "${GREEN}Move this file to another folder and run it again.${RESET}"
    read -p "Press any key to Exit..."
    exit 1
fi

# Check for Existing Helper-CEI
HLPR_NAME="Helper-CEI-NEXT-unix.zip"
if [ ! -f "$HLPR_NAME" ]; then
    echo -e "${WARNING}WARNING:${RESET} '${BOLD}${HLPR_NAME}${RESET}' not exists!"
    echo -e "${GREEN}Unzip the entire package and try again.${RESET}"
    read -p "Press any key to Exit..."
    exit 1
fi

# Capture the start time
START_TIME=$(date +%s)

# Clear Pip and uv Cache
clear_pip_uv_cache() {
    if [ -d "$HOME/.cache/pip" ]; then
        rm -rf "$HOME/.cache/pip" && mkdir -p "$HOME/.cache/pip"
    fi
    if [ -d "$HOME/.cache/uv" ]; then
        rm -rf "$HOME/.cache/uv" && mkdir -p "$HOME/.cache/uv"
    fi
    echo -e "${GREEN}::::::::::::::: Clearing Pip and uv Cache ${YELLOW}Done${GREEN} :::::::::::::::${RESET}"
    echo ""
}

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${WARNING}WARNING:${RESET} ${BOLD}'git'${RESET} is NOT installed"
    echo -e "Please install ${BOLD}'git'${RESET} manually and run this installer again"
    read -p "Press any key to Exit..."
    exit 1
else
    echo -e "${BOLD}git${RESET} ${YELLOW}is installed${RESET}"
    echo ""
fi

# System folder?
mkdir ComfyUI-Easy-Install
if [ ! -d "ComfyUI-Easy-Install" ]; then
    clear
    echo -e "${WARNING}WARNING:${RESET} Cannot create folder ${YELLOW}ComfyUI-Easy-Install${RESET}"
    echo -e "Make sure you have write permissions in the current directory."
    echo -e "${GREEN}Move this file to another folder and run it again.${RESET}"
    read -p "Press any key to Exit..."
    exit 1
fi
cd ComfyUI-Easy-Install

# Install ComfyUI
install_comfyui() {
    echo -e "${GREEN}::::::::::::::: Installing${YELLOW} ComfyUI ${GREEN}:::::::::::::::${RESET}"
    echo ""
    if [ -d "ComfyUI" ]; then
        rm -rf ComfyUI
    fi
    git config --global credential.helper ""
    git clone https://github.com/Comfy-Org/ComfyUI ComfyUI
    if [ ! -d "ComfyUI" ]; then
        echo -e "${RED}Failed to clone ComfyUI. Please check your internet connection and git setup.${RESET}"
        exit 1
    fi

    # Set Python version and directories
    PYTHON_VER="3.12.10"
    PYTHON_EMBED_DIR="python_embeded"
    PYTHON_EMBED_URL="https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}-embed-$(uname -m).tgz"
    PYTHON_SRC_URL="https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz"
    
    echo -e "${GREEN}::::::::::::::: Setting up Python ${PYTHON_VER} Embedded :::::::::::::::${RESET}"
    
    # Remove existing directory if it exists
    rm -rf "$PYTHON_EMBED_DIR"
    
    # Create and enter the directory
    mkdir -p "$PYTHON_EMBED_DIR"
    cd "$PYTHON_EMBED_DIR"
    
    # Download Python embedded
    echo "Downloading Python ${PYTHON_VER} embedded..."
    EMBED_TAR_OK=0
    if curl -L "$PYTHON_EMBED_URL" -o python-embed.tgz; then
        if tar -tzf python-embed.tgz >/dev/null 2>&1; then
            EMBED_TAR_OK=1
        fi
    fi

    if [ "$EMBED_TAR_OK" -eq 1 ]; then
        # Extract embedded Python
        echo "Extracting Python embedded..."
        tar -xzf python-embed.tgz
        rm python-embed.tgz
        
        # Set up Python path configuration
        echo "Configuring Python environment..."
        PYTHON_CMD="$(pwd)/python3"
        if [ -x "$PYTHON_CMD" ]; then
            cat > python << 'EOL'
#!/usr/bin/env sh
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
exec "$SCRIPT_DIR/python3" "$@"
EOL
            chmod +x python
            PYTHON_CMD="$(pwd)/python"
        fi
        
        # Create python312._pth
        cat > python312._pth << 'EOL'
../ComfyUI
python312.zip
.
Lib/site-packages
Lib
Scripts
# import site
EOL

        # Install pip
        echo "Installing pip..."
        curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        $PYTHON_CMD -I get-pip.py
        rm get-pip.py
    else
        echo -e "${YELLOW}Embedded Python archive not available/valid for this platform, falling back to building from source${RESET}"
        rm -f python-embed.tgz

        echo "Downloading Python ${PYTHON_VER} source..."
        if ! curl -L "$PYTHON_SRC_URL" -o Python-${PYTHON_VER}.tgz; then
            echo -e "${RED}Failed to download Python ${PYTHON_VER} source${RESET}"
            exit 1
        fi

        echo "Installing system dependencies for Python build..."
        if [ "$(uname -s)" = "Linux" ]; then
            if command -v apt-get >/dev/null 2>&1; then
                # Debian/Ubuntu
                echo "Detected apt package manager, installing dependencies..."
                sudo apt-get update
                sudo apt-get install -y build-essential zlib1g-dev libncurses5-dev \
                    libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev \
                    liblzma-dev libbz2-dev libsqlite3-dev libffi-dev
            elif command -v yum >/dev/null 2>&1; then
                # RHEL/CentOS
                echo "Detected yum package manager, installing dependencies..."
                sudo yum groupinstall -y "Development Tools"
                sudo yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel \
                    sqlite-devel readline-devel xz-devel libffi-devel
            elif command -v dnf >/dev/null 2>&1; then
                # Fedora
                echo "Detected dnf package manager, installing dependencies..."
                sudo dnf groupinstall -y "Development Tools"
                sudo dnf install -y zlib-devel bzip2-devel openssl-devel ncurses-devel \
                    sqlite-devel readline-devel xz-devel libffi-devel
            elif command -v pacman >/dev/null 2>&1; then
                # Arch Linux
                echo "Detected pacman package manager, installing dependencies..."
                sudo pacman -S --needed --noconfirm base-devel zlib bzip2 openssl \
                    ncurses sqlite readline xz libffi
            else
                echo "Warning: Could not determine package manager. You may need to install build dependencies manually."
                echo "Required packages: build-essential, zlib1g-dev, liblzma-dev, libbz2-dev, libsqlite3-dev, libffi-dev"
            fi
        fi

        echo "Extracting and building Python..."
        tar -xzf Python-${PYTHON_VER}.tgz
        cd Python-${PYTHON_VER}

        echo "Configuring Python build..."
        ./configure --prefix="$(pwd)/.." --enable-optimizations --with-ensurepip=install \
            --with-system-ffi --with-system-libm

        echo "Building Python (this may take a while)..."
        MAKE_JOBS="$(getconf _NPROCESSORS_ONLN 2>/dev/null || true)"
        if [ -z "$MAKE_JOBS" ]; then
            MAKE_JOBS="$(nproc 2>/dev/null || echo 1)"
        fi
        make -j"$MAKE_JOBS"
        make install

        cd ..
        rm -rf Python-${PYTHON_VER} Python-${PYTHON_VER}.tgz
        REAL_PYTHON="$(pwd)/bin/python3"
        if [ ! -x "$REAL_PYTHON" ]; then
            echo -e "${RED}Python build did not produce expected binary: $REAL_PYTHON${RESET}"
            exit 1
        fi

        cat > python << 'EOL'
#!/usr/bin/env sh
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
exec "$SCRIPT_DIR/bin/python3" "$@"
EOL
        chmod +x python

        cat > python3 << 'EOL'
#!/usr/bin/env sh
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
exec "$SCRIPT_DIR/bin/python3" "$@"
EOL
        chmod +x python3

        PYTHON_CMD="$(pwd)/python"
    fi

    if [ ! -x "$PYTHON_CMD" ]; then
        echo -e "${RED}Python setup failed: $PYTHON_CMD not found or not executable${RESET}"
        exit 1
    fi

    $PYTHON_CMD -m ensurepip --upgrade >/dev/null 2>&1 || true
    $PYTHON_CMD -m pip install $PIP_ARGS --upgrade pip

    # Set the full path to the embedded Python
    EMBEDDED_PYTHON="$PYTHON_CMD"
    
    # Return to the original directory
    cd ..
    
    echo -e "${GREEN}Python ${PYTHON_VER} setup complete${RESET}"
    echo -e "Using Python from: $EMBEDDED_PYTHON"

    # Install required packages using the embedded Python
    echo "Installing required packages..."
    $EMBEDDED_PYTHON -m pip install $PIP_ARGS uv==0.9.7
    $EMBEDDED_PYTHON -m pip install $PIP_ARGS torch==2.9.1 torchvision==0.24.1 torchaudio==2.9.1 --index-url https://download.pytorch.org/whl/cu130
    $EMBEDDED_PYTHON -m uv pip install $UV_ARGS pygit2
    
    # Install ComfyUI requirements
    echo "Installing ComfyUI requirements..."
    cd ComfyUI
    $EMBEDDED_PYTHON -m uv pip install -r requirements.txt $UV_ARGS
    cd ..
    echo ""
}

# Get Node
get_node() {
    GIT_URL=$1
    GIT_FOLDER=$2
    echo -e "${GREEN}::::::::::::::: Installing${YELLOW} ${GIT_FOLDER} ${GREEN}:::::::::::::::${RESET}"
    echo ""
    git clone "$GIT_URL" "ComfyUI/custom_nodes/${GIT_FOLDER}"

    if [ -f "./ComfyUI/custom_nodes/${GIT_FOLDER}/requirements.txt" ]; then
        if [ -s "./ComfyUI/custom_nodes/${GIT_FOLDER}/requirements.txt" ]; then
            $EMBEDDED_PYTHON -m uv pip install -r "./ComfyUI/custom_nodes/${GIT_FOLDER}/requirements.txt" $UV_ARGS
        fi
    fi

    if [ -f "./ComfyUI/custom_nodes/${GIT_FOLDER}/install.py" ]; then
        if [ -s "./ComfyUI/custom_nodes/${GIT_FOLDER}/install.py" ]; then
            $EMBEDDED_PYTHON "./ComfyUI/custom_nodes/${GIT_FOLDER}/install.py"
        fi
    fi
    echo ""
}

# Copy files
copy_files() {
    if [ -f "../$1" ]; then
        if [ -d "./$2" ]; then
            cp "../$1" "./$2/"
        fi
    fi
}

# Main script execution
clear_pip_uv_cache
install_comfyui

echo -e "${GREEN}::::::::::::::: ${YELLOW}Pre-installation of required modules${GREEN} :::::::::::::::${RESET}"
echo ""
$EMBEDDED_PYTHON -m uv pip install scikit-build-core $UV_ARGS
$EMBEDDED_PYTHON -m uv pip install onnxruntime-gpu $UV_ARGS
$EMBEDDED_PYTHON -m uv pip install onnx $UV_ARGS
$EMBEDDED_PYTHON -m uv pip install flet $UV_ARGS
# Install working version of stringzilla
$EMBEDDED_PYTHON -m uv pip install stringzilla==3.12.6 $UV_ARGS
echo ""

# Install Pixaroma's Related Nodes
# Use the already set PYTHON_CMD
get_node https://github.com/Comfy-Org/ComfyUI-Manager comfyui-manager
get_node https://github.com/yolain/ComfyUI-Easy-Use ComfyUI-Easy-Use
get_node https://github.com/Fannovel16/comfyui_controlnet_aux comfyui_controlnet_aux
get_node https://github.com/rgthree/rgthree-comfy rgthree-comfy
get_node https://github.com/MohammadAboulEla/ComfyUI-iTools comfyui-itools
get_node https://github.com/city96/ComfyUI-GGUF ComfyUI-GGUF
get_node https://github.com/gseth/ControlAltAI-Nodes controlaltai-nodes
get_node https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch comfyui-inpaint-cropandstitch
get_node https://github.com/1038lab/ComfyUI-RMBG comfyui-rmbg
get_node https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite comfyui-videohelpersuite
get_node https://github.com/welltop-cn/ComfyUI-TeaCache teacache
get_node https://github.com/shiimizu/ComfyUI-TiledDiffusion ComfyUI-TiledDiffusion
get_node https://github.com/kijai/ComfyUI-KJNodes comfyui-kjnodes
get_node https://github.com/kijai/ComfyUI-WanVideoWrapper ComfyUI-WanVideoWrapper
get_node https://github.com/1038lab/ComfyUI-QwenVL ComfyUI-QwenVL

# INSTALLING Add-Ons :::
# Installing Nunchaku ::
# bash Add-Ons/Nunchaku-NEXT.sh NoPause
# Installing Insightface ::
# bash Add-Ons/Insightface-NEXT.sh NoPause
# Installing SageAttention ::
# bash Add-Ons/SageAttention-NEXT.sh NoPause

echo -e "${GREEN}::::::::::::::: Installing ${YELLOW}Required Dependencies${GREEN} :::::::::::::::${RESET}"
echo ""

# Install llama-cpp-python for Searge
$EMBEDDED_PYTHON -m uv pip install llama-cpp-python $UV_ARGS
# Install pylatexenc for kokoro
$EMBEDDED_PYTHON -m uv pip install pylatexenc $UV_ARGS
# Install onnxruntime
$EMBEDDED_PYTHON -m uv pip install onnxruntime $UV_ARGS
$EMBEDDED_PYTHON -m uv pip install onnx $UV_ARGS
# Install flet for REMBG
$EMBEDDED_PYTHON -m uv pip install flet $UV_ARGS
# Install ffmpeg
$EMBEDDED_PYTHON -m uv pip install python-ffmpeg $UV_ARGS

# Extracting helper folders
cd ../
unzip -o ./"$HLPR_NAME" -d ./
cd ComfyUI-Easy-Install

# Remove Windows-specific embedded Python directories
if [ -d "python_embeded_3.11" ]; then
    rm -rf "python_embeded_3.11"
fi
if [ -d "python_embeded_3.12" ]; then
    rm -rf "python_embeded_3.12"
fi

# Remove all .bat files after extraction
find . -type f -name "*.bat" -delete

# Make all .sh files executable
find . -type f -name "*.sh" -exec chmod +x {} +

# Copy additional files if they exist
copy_files run_nvidia_gpu.sh .
copy_files run_nvidia_gpu_SageAttention.sh .
copy_files extra_model_paths.yaml ComfyUI
copy_files comfy.settings.json ComfyUI/user/default
copy_files rgthree_config.json ComfyUI/custom_nodes/rgthree-comfy

# Capture the end time
END_TIME=$(date +%s)
DIFF=$(($END_TIME - $START_TIME))

# Final Messages
echo ""
echo -e "${GREEN}::::::::::::::: Installation Complete :::::::::::::::${RESET}"
echo -e "${GREEN}::::::::::::::: Total Running Time:${RED} ${DIFF} ${GREEN}seconds${RESET}"
read -p "Press any key to exit"
