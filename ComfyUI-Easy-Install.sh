#!/bin/bash

# Title: ComfyUI-Easy-Install NEXT by ivo v1.70.0 (Ep70)
# Pixaroma Community Edition
# macOS and Linux conversion

# Set the Python version here (3.11 or 3.12 only)
PYTHON_VERSION="3.12"

# Set colors
WARNING='\033[33m'
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BOLD='\033[1m'
RESET='\033[0m'

# Helper: run package manager with or without sudo
pm_run() {
  if command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    "$@"
  fi
}

# Check the Python version
if [ "$PYTHON_VERSION" != "3.11" ] && [ "$PYTHON_VERSION" != "3.12" ]; then
    echo ""
    echo -e "${WARNING}WARNING: ${RED}Python ${PYTHON_VERSION} is not supported. ${GREEN}Supported versions: 3.11, 3.12${RESET}"
    echo ""
    read -p "Press any key to exit"
    exit 1
fi

# Set Ignoring Large File Storage
export GIT_LFS_SKIP_SMUDGE=1

# Set arguments
PIP_ARGS="--no-cache-dir --no-warn-script-location --timeout=1000 --retries 200"
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
    git clone https://github.com/comfyanonymous/ComfyUI ComfyUI

    if [ "$PYTHON_VERSION" == "3.11" ]; then
        PYTHON_VER="3.11.9"
    fi
    if [ "$PYTHON_VERSION" == "3.12" ]; then
        PYTHON_VER="3.12.10"
    fi

    # Resolve Python command (prefer system python3 >= 3.11, else fall back to configured version)
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
        PYV=$($PYTHON_CMD -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
        case "$PYV" in
            3.1[1-9]|3.[2-9]*) ;;  # >= 3.11
            *)
                echo -e "${WARNING}WARNING:${RESET} Detected python3 version ${BOLD}${PYV}${RESET}. ${GREEN}Python >= 3.11 is required.${RESET}"
                echo -e "Install a newer Python or adjust PATH, then rerun."
                read -p "Press any key to Exit..."
                exit 1
                ;;
        esac
    elif command -v python"$PYTHON_VERSION" &> /dev/null; then
        PYTHON_CMD="python${PYTHON_VERSION}"
    else
        echo -e "${WARNING}WARNING:${RESET} ${BOLD}'python3'${RESET} or ${BOLD}'python${PYTHON_VERSION}'${RESET} is NOT installed"
        echo -e "Please install an appropriate Python (>=3.11) and run this installer again"
        read -p "Press any key to Exit..."
        exit 1
    fi

    # Ensure venv module is available on Debian-based systems
    if ! $PYTHON_CMD -m venv -h > /dev/null 2>&1; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y python3-venv || true
        fi
    fi

    "$PYTHON_CMD" -m venv python_embeded
    source python_embeded/bin/activate

    python -m pip install $PIP_ARGS uv
    python -m pip install $PIP_ARGS torch torchvision torchaudio
    python -m uv pip install $UV_ARGS pygit2
    cd ComfyUI
    python -m uv pip install -r requirements.txt $UV_ARGS
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
            python -m uv pip install -r "./ComfyUI/custom_nodes/${GIT_FOLDER}/requirements.txt" $UV_ARGS
        fi
    fi

    if [ -f "./ComfyUI/custom_nodes/${GIT_FOLDER}/install.py" ]; then
        if [ -s "./ComfyUI/custom_nodes/${GIT_FOLDER}/install.py" ]; then
            python "./ComfyUI/custom_nodes/${GIT_FOLDER}/install.py"
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

# Install Pixaroma's Related Nodes
get_node https://github.com/Comfy-Org/ComfyUI-Manager comfyui-manager
get_node https://github.com/WASasquatch/was-node-suite-comfyui was-node-suite-comfyui
get_node https://github.com/yolain/ComfyUI-Easy-Use ComfyUI-Easy-Use
get_node https://github.com/Fannovel16/comfyui_controlnet_aux comfyui_controlnet_aux
get_node https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes ComfyUI_Comfyroll_CustomNodes
get_node https://github.com/crystian/ComfyUI-Crystools ComfyUI-Crystools
get_node https://github.com/rgthree/rgthree-comfy rgthree-comfy
get_node https://github.com/city96/ComfyUI-GGUF ComfyUI-GGUF
get_node https://github.com/kijai/ComfyUI-Florence2 ComfyUI-Florence2
if [ "$PYTHON_VERSION" == "3.11" ]; then
    get_node https://github.com/SeargeDP/ComfyUI_Searge_LLM ComfyUI_Searge_LLM
fi
get_node https://github.com/SeargeDP/ComfyUI_Searge_LLM ComfyUI_Searge_LLM
get_node https://github.com/gseth/ControlAltAI-Nodes controlaltai-nodes
get_node https://github.com/stavsap/comfyui-ollama comfyui-ollama
get_node https://github.com/MohammadAboulEla/ComfyUI-iTools comfyui-itools
get_node https://github.com/spinagon/ComfyUI-seamless-tiling comfyui-seamless-tiling
get_node https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch comfyui-inpaint-cropandstitch
get_node https://github.com/Lerc/canvas_tab canvas_tab
get_node https://github.com/1038lab/ComfyUI-OmniGen comfyui-omnigen
get_node https://github.com/john-mnz/ComfyUI-Inspyrenet-Rembg comfyui-inspyrenet-rembg
get_node https://github.com/kaibioinfo/ComfyUI_AdvancedRefluxControl ComfyUI_AdvancedRefluxControl
get_node https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite comfyui-videohelpersuite
get_node https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait comfyui-advancedliveportrait
get_node https://github.com/Yanick112/ComfyUI-ToSVG ComfyUI-ToSVG
get_node https://github.com/stavsap/comfyui-kokoro comfyui-kokoro
get_node https://github.com/CY-CHENYUE/ComfyUI-Janus-Pro janus-pro
get_node https://github.com/smthemex/ComfyUI_Sonic ComfyUI_Sonic
get_node https://github.com/welltop-cn/ComfyUI-TeaCache teacache
get_node https://github.com/kk8bit/KayTool kaytool
get_node https://github.com/shiimizu/ComfyUI-TiledDiffusion ComfyUI-TiledDiffusion

# Check and install git-lfs for ComfyUI-LTXVideo
if ! command -v git-lfs &> /dev/null; then
    echo -e "${YELLOW}Git LFS not found, installing...${RESET}"
    if [[ "$(uname)" == "Darwin" ]]; then
        if ! command -v brew &> /dev/null; then
            echo -e "${RED}Error: Homebrew is required to install Git LFS on macOS.${RESET}"
            echo -e "Please install Homebrew first: https://brew.sh/"
            exit 1
        fi
        brew install git-lfs
    else
        # For Linux
        if command -v apt-get &> /dev/null; then
            pm_run apt-get update && pm_run apt-get install -y git-lfs
        elif command -v dnf &> /dev/null; then
            pm_run dnf install -y git-lfs
        elif command -v yum &> /dev/null; then
            pm_run yum install -y git-lfs
        else
            echo -e "${RED}Error: Could not determine package manager to install Git LFS${RESET}"
            echo -e "Please install Git LFS manually: https://git-lfs.com/"
            exit 1
        fi
    fi
    git lfs install
fi

get_node https://github.com/Lightricks/ComfyUI-LTXVideo ComfyUI-LTXVideo
get_node https://github.com/kijai/ComfyUI-KJNodes comfyui-kjnodes
get_node https://github.com/kijai/ComfyUI-WanVideoWrapper ComfyUI-WanVideoWrapper
get_node https://github.com/Enemyx-net/VibeVoice-ComfyUI VibeVoice-ComfyUI
get_node https://github.com/ussoewwin/ComfyUI-QwenImageLoraLoader ComfyUI-QwenImageLoraLoader
# Ensure unzip exists, then extract helper folders (to provide Add-Ons and other helpers)
if ! command -v unzip >/dev/null 2>&1; then
    if command -v apt-get &> /dev/null; then
        pm_run apt-get update && pm_run apt-get install -y unzip
    elif command -v dnf &> /dev/null; then
        pm_run dnf install -y unzip
    elif command -v yum &> /dev/null; then
        pm_run yum install -y unzip
    else
        echo -e "${RED}Error: 'unzip' not found and package manager not detected. Please install unzip and rerun.${RESET}"
        read -p "Press any key to Exit..."
        exit 1
    fi
fi
# Extracting helper folders (to provide Add-Ons and other helpers)
cd ../
unzip -o ./"$HLPR_NAME" -d ./
cd ComfyUI-Easy-Install
# INSTALLING Add-Ons :::
# Installing Nunchaku ::
if [ -f "Add-Ons/Nunchaku-NEXT.sh" ]; then bash Add-Ons/Nunchaku-NEXT.sh NoPause; else echo -e "${YELLOW}Skipping Nunchaku add-on:${RESET} script not found"; fi
# Installing Insightface ::
if [ -f "Add-Ons/Insightface-NEXT.sh" ]; then bash Add-Ons/Insightface-NEXT.sh NoPause; else echo -e "${YELLOW}Skipping Insightface add-on:${RESET} script not found"; fi
# Installing SageAttention ::
if [ -f "Add-Ons/SageAttention-NEXT.sh" ]; then bash Add-Ons/SageAttention-NEXT.sh NoPause; else echo -e "${YELLOW}Skipping SageAttention add-on:${RESET} script not found"; fi

echo -e "${GREEN}::::::::::::::: Installing ${YELLOW}Required Dependencies${GREEN} :::::::::::::::${RESET}"
echo ""

# Install llama-cpp-python for Searge
if [[ "$(uname)" == "Darwin" ]]; then
    if command -v brew &> /dev/null; then brew install cmake; fi
else
    if command -v apt-get &> /dev/null; then
        pm_run apt-get update && pm_run apt-get install -y build-essential cmake python3-dev
    elif command -v dnf &> /dev/null; then
        pm_run dnf install -y gcc gcc-c++ cmake make python3-devel
    elif command -v yum &> /dev/null; then
        pm_run yum install -y gcc gcc-c++ cmake make python3-devel
    fi
fi
python -m uv pip install llama-cpp-python $UV_ARGS
# Install pylatexenc for kokoro
python -m uv pip install pylatexenc $UV_ARGS
# Install onnxruntime
python -m uv pip install onnxruntime $UV_ARGS
python -m uv pip install onnx $UV_ARGS
# Install flet for REMBG
python -m uv pip install flet $UV_ARGS
# Install ffmpeg
python -m uv pip install python-ffmpeg $UV_ARGS

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
copy_files was_suite_config.json ComfyUI/custom_nodes/was-node-suite-comfyui
copy_files rgthree_config.json ComfyUI/custom_nodes/rgthree-comfy

deactivate

# Capture the end time
END_TIME=$(date +%s)
DIFF=$(($END_TIME - $START_TIME))

# Final Messages
echo ""
echo -e "${GREEN}::::::::::::::: Installation Complete :::::::::::::::${RESET}"
echo -e "${GREEN}::::::::::::::: Total Running Time:${RED} ${DIFF} ${GREEN}seconds${RESET}"
read -p "Press any key to exit"
