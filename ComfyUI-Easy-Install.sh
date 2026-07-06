#!/bin/bash

# Title ComfyUI-Easy-Install  NEXT by ivo v3.10.0
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
export GIT_ASKPASS=echo

# Disable IPv6 to prevent hanging in LXC containers
echo -e "${YELLOW}Disabling IPv6 to prevent network hangs...${RESET}"
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1 || true
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1 || true

# Set arguments
PIP_ARGS="--no-cache-dir --no-warn-script-location --timeout=120 --retries 3 --progress-bar on --root-user-action=ignore --trusted-host pypi.org --trusted-host files.pythonhosted.org --trusted-host pypi.python.org"
CURL_ARGS="--retry 200 --retry-all-errors"
UV_ARGS="--system --no-cache --link-mode=copy"

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
    echo -e "${GREEN}::::::::::::::: Clearing Pip and uv Cache${GREEN} :::::::::::::::${RESET}"
    
    local cache_size=0
    local pip_cache="$HOME/.cache/pip"
    local uv_cache="$HOME/.cache/uv"
    
    # Calculate and clear pip cache
    if [ -d "$pip_cache" ]; then
        cache_size=$(du -sk "$pip_cache" 2>/dev/null | cut -f1)
        cache_size=$((cache_size * 1024))
        rm -rf "$pip_cache" && mkdir -p "$pip_cache"
    fi
    
    # Calculate and clear uv cache
    if [ -d "$uv_cache" ]; then
        uv_size=$(du -sk "$uv_cache" 2>/dev/null | cut -f1)
        uv_size=$((uv_size * 1024))
        cache_size=$((cache_size + uv_size))
        rm -rf "$uv_cache" && mkdir -p "$uv_cache"
    fi
    
    # Show space cleared
    if [ "$cache_size" -eq 0 ]; then
        echo -e "${GREEN}::::::::::::::: ${YELLOW}Cache is already clean${GREEN} :::::::::::::::${RESET}"
    elif [ "$cache_size" -ge 1073741824 ]; then
        local gb=$((cache_size / 1073741824))
        local remainder=$((cache_size % 1073741824))
        local decimals=$((remainder * 10 / 1073741824))
        echo -e "${GREEN}::::::::::::::: ${YELLOW}Cleared ${gb}.${decimals} GB${GREEN} :::::::::::::::${RESET}"
    else
        local mb=$((cache_size / 1048576))
        echo -e "${GREEN}::::::::::::::: ${YELLOW}Cleared ${mb} MB${GREEN} :::::::::::::::${RESET}"
    fi
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
    
    # Map uname -m output to Python's architecture naming
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64) PYTHON_ARCH="amd64" ;;
        aarch64|arm64) PYTHON_ARCH="arm64" ;;
        *) PYTHON_ARCH="$ARCH" ;;
    esac
    
    PYTHON_EMBED_URL="https://www.python.org/ftp/python/${PYTHON_VER}/python-${PYTHON_VER}-embed-${PYTHON_ARCH}.zip"
    PYTHON_SRC_URL="https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz"
    
    echo -e "${GREEN}::::::::::::::: Setting up Python ${PYTHON_VER} Embedded :::::::::::::::${RESET}"
    
    # Remove existing directory if it exists
    rm -rf "$PYTHON_EMBED_DIR"
    
    # Create and enter the directory
    mkdir -p "$PYTHON_EMBED_DIR"
    cd "$PYTHON_EMBED_DIR"
    
    # Skip embedded Python (Windows-only) - go directly to source compilation
    echo -e "${YELLOW}Embedded Python not available on $(uname -s), building from source${RESET}"
    EMBED_TAR_OK=0

    if [ "$EMBED_TAR_OK" -eq 1 ]; then
        # Extract embedded Python
        echo "Extracting Python embedded..."
        unzip -q python-embed.zip
        rm python-embed.zip
        
        # Set up Python path configuration
        echo "Configuring Python environment..."
        
        # Check for different Python binary names in embedded distribution
        if [ -x "python.exe" ]; then
            PYTHON_CMD="$(pwd)/python.exe"
        elif [ -x "python3" ]; then
            PYTHON_CMD="$(pwd)/python3"
        elif [ -x "python" ]; then
            PYTHON_CMD="$(pwd)/python"
        else
            echo -e "${RED}No Python binary found in embedded distribution${RESET}"
            exit 1
        fi
        
        # Create wrapper script
        cat > python << 'EOL'
#!/usr/bin/env sh
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

# Try different Python binary names
if [ -x "$SCRIPT_DIR/python.exe" ]; then
    exec "$SCRIPT_DIR/python.exe" "$@"
elif [ -x "$SCRIPT_DIR/python3" ]; then
    exec "$SCRIPT_DIR/python3" "$@"
elif [ -x "$SCRIPT_DIR/python" ]; then
    exec "$SCRIPT_DIR/python" "$@"
else
    echo "Error: No Python binary found"
    exit 1
fi
EOL
        chmod +x python
        PYTHON_CMD="$(pwd)/python"
        
        # Create python312._pth
        cat > python312._pth << 'EOL'
../ComfyUI
python312.zip
.
Lib/site-packages
Lib
Scripts
import site
EOL

        # Install pip
        echo "Installing pip..."
        curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        $PYTHON_CMD -I get-pip.py
        rm get-pip.py
    else
        echo -e "${YELLOW}Embedded Python archive not available/valid for this platform, falling back to building from source${RESET}"
        rm -f python-embed.zip

        echo "Downloading Python ${PYTHON_VER} source..."
        if ! curl -L "$PYTHON_SRC_URL" -o Python-${PYTHON_VER}.tgz; then
            echo -e "${RED}Failed to download Python ${PYTHON_VER} source${RESET}"
            exit 1
        fi

        echo "Installing system dependencies for Python build..."
        if [ "$(uname -s)" = "Darwin" ]; then
            # macOS
            if command -v brew >/dev/null 2>&1; then
                echo "Detected Homebrew, installing dependencies..."
                brew install openssl readline sqlite3 xz zlib tcl-tk libffi 2>/dev/null || true
            else
                echo -e "${YELLOW}Warning: Homebrew not found. Please install build dependencies manually.${RESET}"
                echo "Install Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
                echo "Then run: brew install openssl readline sqlite3 xz zlib tcl-tk libffi"
            fi
            # Ensure Xcode Command Line Tools are installed
            if ! xcode-select -p >/dev/null 2>&1; then
                echo "Installing Xcode Command Line Tools..."
                xcode-select --install
                echo "Please complete the Xcode Command Line Tools installation and run this script again."
                exit 1
            fi
        elif [ "$(uname -s)" = "Linux" ]; then
            # Use sudo only if not running as root
            SUDO_CMD=""
            if [ "$(id -u)" -ne 0 ]; then
                SUDO_CMD="sudo"
            fi
            
            if command -v apt-get >/dev/null 2>&1; then
                # Debian/Ubuntu
                echo "Detected apt package manager, installing dependencies..."
                $SUDO_CMD apt-get update
                $SUDO_CMD apt-get install -y build-essential zlib1g-dev libncurses5-dev \
                    libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev \
                    liblzma-dev libbz2-dev libsqlite3-dev uuid-dev libdb-dev \
                    tk-dev libncursesw5-dev unzip
            elif command -v yum >/dev/null 2>&1; then
                # RHEL/CentOS
                echo "Detected yum package manager, installing dependencies..."
                $SUDO_CMD yum groupinstall -y "Development Tools"
                $SUDO_CMD yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel \
                    sqlite-devel readline-devel xz-devel libffi-devel libuuid-devel
            elif command -v dnf >/dev/null 2>&1; then
                # Fedora
                echo "Detected dnf package manager, installing dependencies..."
                $SUDO_CMD dnf groupinstall -y "Development Tools"
                $SUDO_CMD dnf install -y zlib-devel bzip2-devel openssl-devel ncurses-devel \
                    sqlite-devel readline-devel xz-devel libffi-devel libuuid-devel
            elif command -v pacman >/dev/null 2>&1; then
                # Arch Linux
                echo "Detected pacman package manager, installing dependencies..."
                $SUDO_CMD pacman -S --needed --noconfirm base-devel zlib bzip2 openssl \
                    ncurses sqlite readline xz libffi
            else
                echo "Warning: Could not determine package manager. You may need to install build dependencies manually."
                echo "Required packages: build-essential, zlib1g-dev, liblzma-dev, libbz2-dev, libsqlite3-dev, libffi-dev, libssl-dev"
            fi
        fi

        echo "Extracting and building Python..."
        tar -xzf Python-${PYTHON_VER}.tgz
        cd Python-${PYTHON_VER}

        echo "Configuring Python build..."
        if [ "$(uname -s)" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
            # macOS: must explicitly link OpenSSL from Homebrew
            # Note: --enable-optimizations is disabled on macOS ARM64 due to PGO linking errors
            OPENSSL_PREFIX="$(brew --prefix openssl)"
            XZ_PREFIX="$(brew --prefix xz)"
            READLINE_PREFIX="$(brew --prefix readline)"
            env \
                PKG_CONFIG_PATH="${OPENSSL_PREFIX}/lib/pkgconfig:${XZ_PREFIX}/lib/pkgconfig:${READLINE_PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}" \
                LDFLAGS="-L${OPENSSL_PREFIX}/lib -L${XZ_PREFIX}/lib -L${READLINE_PREFIX}/lib" \
                CPPFLAGS="-I${OPENSSL_PREFIX}/include -I${XZ_PREFIX}/include -I${READLINE_PREFIX}/include" \
                LIBS="-llzma" \
                ./configure --prefix="$(pwd)/.." \
                    --with-ensurepip=install \
                    --with-system-ffi \
                    --with-system-libm \
                    --with-openssl="$OPENSSL_PREFIX"
        else
            # Linux: system OpenSSL is usually found automatically
            ./configure --prefix="$(pwd)/.." \
                --enable-optimizations \
                --with-ensurepip=install \
                --with-system-ffi \
                --with-system-libm
        fi

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
    # Upgrade pip with timeout to prevent hanging (skip if it fails)
    echo "Upgrading pip (timeout 60s)..."
    timeout 60 $PYTHON_CMD -m pip install --no-cache-dir --timeout=30 --retries=2 --upgrade pip 2>/dev/null || echo -e "${YELLOW}pip upgrade skipped (timeout or network issue)${RESET}"

    # Set the full path to the embedded Python
    EMBEDDED_PYTHON="$PYTHON_CMD"
    
    # Add embedded Python's bin to PATH for pip and other scripts
    PYTHON_BIN_DIR="$(dirname "$PYTHON_CMD")"
    if [ -d "$PYTHON_BIN_DIR/bin" ]; then
        export PATH="$PYTHON_BIN_DIR/bin:$PATH"
    else
        export PATH="$PYTHON_BIN_DIR:$PATH"
    fi
    
    # Update UV_ARGS to use the embedded Python
    UV_ARGS="$UV_ARGS --python $EMBEDDED_PYTHON"
    
    # Return to the original directory
    cd ..
    
    echo -e "${GREEN}Python ${PYTHON_VER} setup complete${RESET}"
    echo -e "Using Python from: $EMBEDDED_PYTHON"

    # Install required packages using the embedded Python
    echo -e "${GREEN}::::::::::::::: Installing required packages :::::::::::::::${RESET}"
    
    echo -e "${YELLOW}[1/6]${RESET} Installing uv package manager..."
    $EMBEDDED_PYTHON -m pip install uv==0.9.7 $PIP_ARGS
    echo -e "${GREEN}✓${RESET} uv installed"
    
    echo -e "${YELLOW}[2/6]${RESET} Installing PyTorch 2.10.0..."
    # Check if running on macOS and install appropriate PyTorch
    if [ "$(uname)" = "Darwin" ]; then
        echo -e "${YELLOW}Installing PyTorch 2.10.0 for macOS (CPU/MPS)...${RESET}"
        # For macOS, install without CUDA index
        uv pip install $UV_ARGS torch==2.10.0 torchvision==0.25.0 torchaudio==2.10.0
        echo -e "${GREEN}✓${RESET} PyTorch installed (macOS version)"
    else
        echo -e "${YELLOW}Installing PyTorch 2.10.0 + CUDA 13.0...${RESET}"
        uv pip install $UV_ARGS torch==2.10.0 torchvision==0.25.0 torchaudio==2.10.0 --index-url https://download.pytorch.org/whl/cu130
        echo -e "${GREEN}✓${RESET} PyTorch installed (CUDA version)"
    fi
    
    echo -e "${GREEN}::::::::::::::: ${YELLOW}Pre-installation of required modules${GREEN} :::::::::::::::${RESET}"
    echo
    uv pip install scikit-build-core $UV_ARGS
    
    # Handle onnxruntime based on platform
    if [ "$(uname)" = "Darwin" ]; then
        echo -e "${YELLOW}Installing onnxruntime (CPU version for macOS)...${RESET}"
        uv pip install onnxruntime $UV_ARGS
    else
        echo -e "${YELLOW}Installing onnxruntime (GPU version for Linux)...${RESET}"
        uv pip install onnxruntime-gpu $UV_ARGS
    fi
    
    uv pip install onnx $UV_ARGS
    uv pip install flet $UV_ARGS
    uv pip install chardet==5.2.0 $UV_ARGS
    uv pip install kornia==0.7.4 $UV_ARGS

    
    # Install llama-cpp-python (platform-specific) - JamePeng's fork
    if [ "$(uname)" = "Darwin" ]; then
        # macOS version - install from source with Metal support
        echo -e "${YELLOW}Installing llama-cpp-python v0.3.40 with Metal support for macOS...${RESET}"
        CMAKE_ARGS="-DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_APPLE_SILICON_PROCESSOR=arm64 -DGGML_METAL=on" uv pip install --upgrade --force-reinstall "llama-cpp-python @ git+https://github.com/JamePeng/llama-cpp-python.git" $UV_ARGS
    else
        # Linux version - try different CUDA versions
        # Note: JamePeng v0.3.40 has no cu130 Linux build; cu128 is the closest
        echo -e "${YELLOW}Installing llama-cpp-python v0.3.40 with CUDA support for Linux...${RESET}"
        
        # Try CUDA 12.8 first (no cu130 Linux build for v0.3.40)
        uv pip install https://github.com/JamePeng/llama-cpp-python/releases/download/v0.3.40-cu128-linux-20260607/llama_cpp_python-0.3.40+cu128-cp312-cp312-linux_x86_64.whl $UV_ARGS || {
            # Fallback to CUDA 12.6
            uv pip install https://github.com/JamePeng/llama-cpp-python/releases/download/v0.3.40-cu126-linux-20260607/llama_cpp_python-0.3.40+cu126-cp312-cp312-linux_x86_64.whl $UV_ARGS || {
                # Final fallback to source build
                echo -e "${YELLOW}Falling back to source build with CUDA...${RESET}"
                CMAKE_ARGS="-DGGML_CUDA=on" uv pip install --upgrade --force-reinstall "llama-cpp-python @ git+https://github.com/JamePeng/llama-cpp-python.git" $UV_ARGS || {
                    echo -e "${YELLOW}Final fallback to CPU-only llama-cpp-python...${RESET}"
                    CMAKE_ARGS="-DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS" uv pip install --upgrade --force-reinstall "llama-cpp-python @ git+https://github.com/JamePeng/llama-cpp-python.git" $UV_ARGS
                }
            }
        }
    fi

    # Install working version of stringzilla (damn it)
    uv pip install stringzilla==3.12.6 $UV_ARGS
    # Install working version of transformers (damn it again)
    uv pip install transformers==4.57.6 $UV_ARGS
    uv pip install descript-audio-codec $UV_ARGS
    uv pip install scipy==1.17.1 $UV_ARGS
    echo
    
    echo -e "${YELLOW}[3/6]${RESET} Installing pygit2..."
    uv pip install $UV_ARGS pygit2
    echo -e "${GREEN}✓${RESET} pygit2 installed"
    
    echo -e "${YELLOW}[4/6]${RESET} Installing av==16.0.1 (Thx @Ivo)..."
    uv pip install $UV_ARGS av==16.0.1
    echo -e "${GREEN}✓${RESET} av installed"
    
    # Install ComfyUI requirements
    echo -e "${YELLOW}[5/6]${RESET} Installing ComfyUI requirements..."
    cd ComfyUI
    # Install requirements.txt if it exists, otherwise install essential packages
    if [ -f "requirements.txt" ]; then
        uv pip install -r requirements.txt $UV_ARGS
    else
        echo -e "${YELLOW}requirements.txt not found, installing essential packages...${RESET}"
        uv pip install $UV_ARGS sqlalchemy alembic aiohttp pillow numpy opencv-python-headless sounddevice
    fi
    # Install manager requirements if available
    if [ -f "custom_nodes/comfyui-manager/requirements.txt" ] || [ -f "manager_requirements.txt" ]; then
        echo -e "${YELLOW}Installing ComfyUI Manager requirements...${RESET}"
        if [ -f "manager_requirements.txt" ]; then
            uv pip install -r manager_requirements.txt $UV_ARGS
        elif [ -f "custom_nodes/comfyui-manager/requirements.txt" ]; then
            uv pip install -r custom_nodes/comfyui-manager/requirements.txt $UV_ARGS
        fi
    fi
    echo -e "${GREEN}✓${RESET} ComfyUI requirements installed"
    cd ..
    
    echo -e "${YELLOW}[6/6]${RESET} Base packages complete!"
    echo ""
}

# Get Node
get_node() {
    GIT_URL=$1
    GIT_FOLDER=$2
    echo -e "${GREEN}::::::::::::::: Installing${YELLOW} ${GIT_FOLDER} ${GREEN}:::::::::::::::${RESET}"
    echo ""
    git clone "$GIT_URL" "ComfyUI/custom_nodes/${GIT_FOLDER}"

    if [ "$(uname -s)" = "Darwin" ] && [ "$GIT_FOLDER" = "comfyui-rmbg" ]; then
        RMBG_SAM3_FILE="./ComfyUI/custom_nodes/${GIT_FOLDER}/py/AILab_SAM3Segment.py"
        if [ -f "$RMBG_SAM3_FILE" ]; then
            rm -f "$RMBG_SAM3_FILE"
            echo -e "${YELLOW}Removed RMBG SAM3 Triton module on macOS (requires CUDA)${RESET}"
        fi
    fi

    # Install requirements from requirements.txt
    if [ -f "./ComfyUI/custom_nodes/${GIT_FOLDER}/requirements.txt" ]; then
        if [ -s "./ComfyUI/custom_nodes/${GIT_FOLDER}/requirements.txt" ]; then
            if [ "$(uname)" = "Darwin" ]; then
                # macOS: filter out packages that have no macOS wheels
                grep -vi "onnxruntime-gpu" "./ComfyUI/custom_nodes/${GIT_FOLDER}/requirements.txt" | \
                grep -vi "decord" | \
                grep -vi "triton" > "/tmp/requirements_temp.txt" 2>/dev/null || true
                if [ -s "/tmp/requirements_temp.txt" ]; then
                    uv pip install -r "/tmp/requirements_temp.txt" $UV_ARGS
                fi
                rm -f "/tmp/requirements_temp.txt"
                # Replace onnxruntime-gpu with CPU version if needed
                if grep -qi "onnxruntime" "./ComfyUI/custom_nodes/${GIT_FOLDER}/requirements.txt"; then
                    uv pip install onnxruntime $UV_ARGS
                fi
            else
                # Linux: install as-is
                uv pip install -r "./ComfyUI/custom_nodes/${GIT_FOLDER}/requirements.txt" $UV_ARGS
            fi
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
# clear_pip_uv_cache  # Disabled to avoid slow connection issues
install_comfyui

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
get_node https://github.com/shiimizu/ComfyUI-TiledDiffusion ComfyUI-TiledDiffusion
get_node https://github.com/kijai/ComfyUI-KJNodes comfyui-kjnodes
get_node https://github.com/kijai/ComfyUI-WanVideoWrapper ComfyUI-WanVideoWrapper
get_node https://github.com/1038lab/ComfyUI-QwenVL ComfyUI-QwenVL
get_node https://github.com/flybirdxx/ComfyUI-Qwen-TTS qwen3-tts-comfyui
get_node https://github.com/Saganaki22/ComfyUI-FishAudioS2 ComfyUI-fish-audio-s2
get_node https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler seedvr2_videoupscaler
get_node https://github.com/chflame163/ComfyUI_LayerStyle comfyui_layerstyle
get_node https://github.com/kijai/ComfyUI-WanAnimatePreprocess ComfyUI-WanAnimatePreprocess
get_node https://gitlab.com/pixaroma/ComfyUI-Pixaroma.git ComfyUI-Pixaroma
if [ "$(uname -s)" = "Darwin" ]; then
    echo -e "${YELLOW}Skipping comfyui-easy-sam3 on macOS (requires triton/CUDA).${RESET}"
else
    get_node https://github.com/yolain/ComfyUI-Easy-Sam3 comfyui-easy-sam3
fi
get_node https://github.com/kijai/ComfyUI-SCAIL-Pose ComfyUI-SCAIL-Pose
get_node https://github.com/kijai/ComfyUI-MelBandRoFormer ComfyUI-MelBandRoFormer
get_node https://github.com/capitan01R/ComfyUI-Krea2T-Enhancer ComfyUI-Krea2T-Enhancer

if [ ! -d "ComfyUI/custom_nodes/.disabled" ]; then
    mkdir -p "ComfyUI/custom_nodes/.disabled"
fi

# INSTALLING Add-Ons :::
# Installing Nunchaku ::
# bash Add-Ons/Nunchaku-NEXT.sh NoPause
# Installing Insightface ::
# bash Add-Ons/Insightface-NEXT.sh NoPause
# Installing SageAttention ::
# bash Add-Ons/SageAttention-NEXT.sh NoPause

# Install SoX (required by some audio/TTS nodes)
if command -v sox >/dev/null 2>&1; then
    echo -e "${GREEN}::::::::::::::: ${YELLOW}SoX${GREEN} already installed — skipping${RESET}"
else
    echo -e "${GREEN}::::::::::::::: Installing ${YELLOW}SoX${GREEN} :::::::::::::::${RESET}"
    if [ "$(uname -s)" = "Darwin" ]; then
        if command -v brew >/dev/null 2>&1; then
            brew install sox || true
        else
            echo -e "${YELLOW}Homebrew not found. Please install SoX manually.${RESET}"
        fi
    elif [ "$(uname -s)" = "Linux" ]; then
        SUDO_CMD=""
        if [ "$(id -u)" -ne 0 ]; then
            SUDO_CMD="sudo"
        fi

        if command -v apt-get >/dev/null 2>&1; then
            $SUDO_CMD apt-get update
            $SUDO_CMD apt-get install -y sox || true
        elif command -v dnf >/dev/null 2>&1; then
            $SUDO_CMD dnf install -y sox || true
        elif command -v yum >/dev/null 2>&1; then
            $SUDO_CMD yum install -y sox || true
        elif command -v pacman >/dev/null 2>&1; then
            $SUDO_CMD pacman -S --needed --noconfirm sox || true
        elif command -v zypper >/dev/null 2>&1; then
            $SUDO_CMD zypper --non-interactive install sox || true
        else
            echo -e "${YELLOW}Could not determine package manager. Please install SoX manually.${RESET}"
        fi
    fi
fi
echo

# Install remaining dependencies (only packages NOT already installed above)
echo -e "${GREEN}::::::::::::::: Installing ${YELLOW}Required Dependencies${GREEN} :::::::::::::::${RESET}"
echo ""

echo -e "${YELLOW}[1/2]${RESET} Installing pylatexenc (for kokoro)..."
uv pip install pylatexenc $UV_ARGS
echo -e "${GREEN}✓${RESET} pylatexenc installed"

echo -e "${YELLOW}[2/2]${RESET} Installing python-ffmpeg..."
uv pip install python-ffmpeg $UV_ARGS
echo -e "${GREEN}✓${RESET} python-ffmpeg installed"

if [ "$(uname -s)" = "Darwin" ]; then
    echo -e "${YELLOW}Installing opencv-contrib-python for LayerStyle (ximgproc)...${RESET}"
    uv pip uninstall --system --python "$EMBEDDED_PYTHON" opencv-python-headless opencv-python opencv-contrib-python 2>/dev/null || true
    uv pip install --force-reinstall opencv-contrib-python $UV_ARGS
fi

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

# Install Triton matching Torch requirements (Linux only)
if [ "$(uname -s)" = "Linux" ]; then
    echo -e "${GREEN}::::::::::::::: Installing ${YELLOW}Triton${GREEN} :::::::::::::::${RESET}"
    TRITON_VER=$($EMBEDDED_PYTHON -c "import importlib.metadata; dist = importlib.metadata.metadata('torch'); reqs = [r for r in (dist.get_all('Requires-Dist') or []) if r.startswith('triton')]; ver = reqs[0].split('==')[1].split(';')[0].strip() if reqs and '==' in reqs[0] else ''; print(ver)" 2>/dev/null)
    if [ -n "$TRITON_VER" ]; then
        echo -e "${YELLOW}Torch requires triton==${TRITON_VER}${RESET}"
        $EMBEDDED_PYTHON -m pip install --upgrade --force-reinstall "triton==${TRITON_VER}" $PIP_ARGS || echo -e "${YELLOW}Triton install skipped${RESET}"
    else
        echo -e "${YELLOW}Could not determine triton version from torch metadata, skipping${RESET}"
    fi
    echo ""
fi

# Postinstall: resync pydantic stack to avoid version mismatch issues
uv pip uninstall --system --python "$EMBEDDED_PYTHON" pydantic pydantic-core || true
uv pip install $UV_ARGS pydantic

# Copy additional files if they exist
copy_files run_nvidia_gpu.sh .
copy_files run_nvidia_gpu_SageAttention.sh .
copy_files extra_model_paths.yaml ComfyUI
copy_files comfy.settings.json ComfyUI/user/default
copy_files rgthree_config.json ComfyUI/custom_nodes/rgthree-comfy

# Clear Pip and uv Cache (moved to end in v2.02.0) - Disabled for slow connections
# clear_pip_uv_cache

# Capture the end time
END_TIME=$(date +%s)
DIFF=$(($END_TIME - $START_TIME))

# Final Messages
echo ""
echo -e "${GREEN}::::::::::::::: Installation Complete :::::::::::::::${RESET}"
echo -e "${GREEN}::::::::::::::: Total Running Time:${RED} ${DIFF} ${GREEN}seconds${RESET}"
read -p "Press any key to exit"
