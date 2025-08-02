#!/bin/bash
# ComfyUI Easy Install by ivo - Linux version
# ComfyUI Easy Install by ivo v0.55.1 (Ep55)
# Pixaroma Community Edition

# Set colors
warning="\033[33m"
red="\033[91m"
green="\033[92m"
yellow="\033[93m"
blue="\033[94m"
bold="\033[1m"
reset="\033[0m"

# Set No Warnings
silent="--no-cache-dir --no-warn-script-location"

# Fix pip cache permissions for root
if [ "$(id -u)" -eq 0 ]; then
    export PIP_CACHE_DIR="$(pwd)/.pip_cache"
    mkdir -p "$PIP_CACHE_DIR"
    chmod 700 "$PIP_CACHE_DIR"
fi

# Capture the start time
start=$(date +%H:%M:%S)

# Check if running as root
if [ "$(id -u)" -eq 0 ]; then
    # Check if we're in a Proxmox LXC container
    if grep -q container=lxc /proc/1/environ 2>/dev/null || [ -f /.dockerenv ] || grep -q docker /proc/1/cgroup 2>/dev/null; then
        echo -e "${warning}WARNING:${reset} Running as root in a container environment."
        echo -e "${green}This is allowed for Proxmox LXC containers.${reset}"
        echo -e "It's recommended to create a non-root user after installation."
        # Continue execution
    else
        echo -e "${warning}WARNING:${reset} The installer was run with ${bold}Administrator privileges${reset}."
        echo -e "Please run it with ${green}Standard user permissions${reset} (without Admin rights)."
        echo -e "If you're in a Proxmox LXC container, add --proxmox flag."
        echo "Press any key to Exit..."
        read -n 1
        exit 1
    fi
fi

# Check for Existing ComfyUI Folder
if [ -d "ComfyUI-Easy-Install" ]; then
    echo -e "${warning}WARNING:${reset} '${bold}ComfyUI-Easy-Install${reset}' folder already exists!"
    echo -e "${green}Move this file to another folder and run it again.${reset}"
    echo "Press any key to Exit..."
    read -n 1
    exit 1
fi

# Download Helper-CEI.zip if not present
if [ ! -f "Helper-CEI.zip" ]; then
    echo -e "${green}Downloading Helper-CEI.zip...${reset}"
    
    # Try multiple download methods
    if command -v curl &> /dev/null; then
        echo -e "${yellow}Trying curl...${reset}"
        curl -L -o Helper-CEI.zip https://github.com/Tavris1/ComfyUI-Easy-Install/releases/download/v0.46.0/Helper-CEI.zip || true
    fi
    
    if [ ! -f "Helper-CEI.zip" ] && command -v wget &> /dev/null; then
        echo -e "${yellow}Trying wget...${reset}"
        wget --no-check-certificate https://github.com/Tavris1/ComfyUI-Easy-Install/releases/download/v0.46.0/Helper-CEI.zip || true
    fi
    
    # Verify download
    if [ ! -f "Helper-CEI.zip" ]; then
        echo -e "${warning}ERROR:${reset} Failed to download Helper-CEI.zip"
        echo -e "${yellow}Trying alternative download URL...${reset}"
        
        # Try alternative URL
        if command -v curl &> /dev/null; then
            curl -L -o Helper-CEI.zip https://raw.githubusercontent.com/Tavris1/ComfyUI-Easy-Install/main/Helper-CEI.zip || true
        elif command -v wget &> /dev/null; then
            wget --no-check-certificate https://raw.githubusercontent.com/Tavris1/ComfyUI-Easy-Install/main/Helper-CEI.zip || true
        fi
        
        if [ ! -f "Helper-CEI.zip" ]; then
            echo -e "${warning}ERROR:${reset} All download attempts failed."
            echo -e "${yellow}Debug information:${reset}"
            echo "Internet connectivity:"
            ping -c 1 github.com || true
            echo "DNS resolution:"
            host github.com || true
            exit 1
        fi
    fi
    
    echo -e "${green}Successfully downloaded Helper-CEI.zip${reset}"
fi

# Initialize pip
echo -e "${green}::::::::::::::: Initializing pip ${green}::::::::::::::${reset}"

# Ensure python3-pip is installed
if ! command -v pip3 &> /dev/null; then
    echo -e "${yellow}Installing python3-pip...${reset}"
    apt-get update
    apt-get install -y python3-pip
fi

# Create pip cache directory with proper permissions
export PIP_CACHE_DIR="$(pwd)/.pip_cache"
mkdir -p "$PIP_CACHE_DIR"
chmod 700 "$PIP_CACHE_DIR"

# Clear Pip Cache
echo -e "${green}::::::::::::::: Clearing Pip Cache ${green}::::::::::::::${reset}"
pip3 cache purge || true

# System folder?
mkdir -p ComfyUI-Easy-Install
if [ ! -d "ComfyUI-Easy-Install" ]; then
    echo -e "${warning}WARNING:${reset} Cannot create folder ${yellow}ComfyUI-Easy-Install${reset}"
    echo "Make sure you are NOT using system folders or root directories"
    echo -e "${green}Move this file to another folder and run it again.${reset}"
    echo "Press any key to Exit..."
    read -n 1
    exit 1
fi
cd ComfyUI-Easy-Install

# Install system dependencies
install_dependencies() {
    echo -e "${green}::::::::::::::: Installing System Dependencies ${green}::::::::::::::${reset}"
    # If we're root, don't use sudo
    if [ "$(id -u)" -eq 0 ]; then
        apt-get update
        apt-get install -y \
            python3-pip \
            python3-venv \
            python3-dev \
            git \
            wget \
            curl \
            unzip \
            libgl1 \
            libglib2.0-0 \
            libsm6 \
            libxext6 \
            libxrender1 \
            dnsutils
    else
        sudo apt-get update
        sudo apt-get install -y \
            python3-pip \
            python3-venv \
            python3-dev \
            git \
            wget \
            curl \
            unzip \
            libgl1 \
            libglib2.0-0 \
            libsm6 \
            libxext6 \
            libxrender1 \
            dnsutils
    fi
}

# Install ComfyUI
install_comfyui() {
    echo -e "${green}::::::::::::::: Installing ComfyUI ${green}::::::::::::::${reset}"
    
    # Create Python virtual environment
    echo -e "${green}Creating Python virtual environment...${reset}"
    python3 -m venv venv || {
        echo -e "${warning}Failed to create venv, installing python3-venv...${reset}"
        apt-get update && apt-get install -y python3-venv
        python3 -m venv venv
    }
    
    # Activate virtual environment
    echo -e "${green}Activating virtual environment...${reset}"
    source venv/bin/activate
    
    # Upgrade pip
    echo -e "${green}Upgrading pip...${reset}"
    python3 -m pip install --upgrade pip setuptools wheel
    
    # Extract Helper-CEI.zip
    unzip -q ../Helper-CEI.zip
    
    # Clone ComfyUI
    git clone https://github.com/comfyanonymous/ComfyUI.git
    
    # Install requirements
    echo -e "${green}Installing ComfyUI requirements...${reset}"
    python3 -m pip install --no-cache-dir -r ComfyUI/requirements.txt $silent
    
    # Install PyTorch with appropriate backend
    echo -e "${green}Installing PyTorch...${reset}"
    python3 -m pip install --no-cache-dir torch torchvision torchaudio $silent
}

# Function to get custom nodes
get_node() {
    local git_url="$1"
    local git_folder="$2"
    
    echo -e "${green}::::::::::::::: Installing${yellow} $git_folder ${green}::::::::::::::${reset}"
    echo ""
    
    git clone "$git_url" "ComfyUI/custom_nodes/$git_folder"
    
    if [ -f "ComfyUI/custom_nodes/$git_folder/requirements.txt" ]; then
        source venv/bin/activate
        pip install -r "ComfyUI/custom_nodes/$git_folder/requirements.txt" --use-pep517 $silent
    fi
    
    if [ -f "ComfyUI/custom_nodes/$git_folder/install.py" ]; then
        source venv/bin/activate
        python "ComfyUI/custom_nodes/$git_folder/install.py"
    fi
    
    echo ""
}

# Function to copy files
copy_files() {
    if [ -f "../$1" ] && [ -d "./$2" ]; then
        cp "../$1" "./$2/"
    fi
}

# Install dependencies
install_dependencies

# Install ComfyUI
install_comfyui

# Install Pixaroma's Related Nodes
get_node "https://github.com/Comfy-Org/ComfyUI-Manager" "comfyui-manager"
get_node "https://github.com/WASasquatch/was-node-suite-comfyui" "was-node-suite-comfyui"
get_node "https://github.com/yolain/ComfyUI-Easy-Use" "ComfyUI-Easy-Use"
get_node "https://github.com/Fannovel16/comfyui_controlnet_aux" "comfyui_controlnet_aux"
get_node "https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes" "ComfyUI_Comfyroll_CustomNodes"
get_node "https://github.com/crystian/ComfyUI-Crystools" "ComfyUI-Crystools"
get_node "https://github.com/rgthree/rgthree-comfy" "rgthree-comfy"
get_node "https://github.com/city96/ComfyUI-GGUF" "ComfyUI-GGUF"
get_node "https://github.com/kijai/ComfyUI-Florence2" "ComfyUI-Florence2"
get_node "https://github.com/SeargeDP/ComfyUI_Searge_LLM" "ComfyUI_Searge_LLM"
get_node "https://github.com/gseth/ControlAltAI-Nodes" "controlaltai-nodes"
get_node "https://github.com/stavsap/comfyui-ollama" "comfyui-ollama"
get_node "https://github.com/MohammadAboulEla/ComfyUI-iTools" "comfyui-itools"
get_node "https://github.com/spinagon/ComfyUI-seamless-tiling" "comfyui-seamless-tiling"
get_node "https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch" "comfyui-inpaint-cropandstitch"
get_node "https://github.com/Lerc/canvas_tab" "canvas_tab"
get_node "https://github.com/1038lab/ComfyUI-OmniGen" "comfyui-omnigen"
get_node "https://github.com/john-mnz/ComfyUI-Inspyrenet-Rembg" "comfyui-inspyrenet-rembg"
get_node "https://github.com/kaibioinfo/ComfyUI_AdvancedRefluxControl" "ComfyUI_AdvancedRefluxControl"
get_node "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite" "comfyui-videohelpersuite"
get_node "https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait" "comfyui-advancedliveportrait"
get_node "https://github.com/Yanick112/ComfyUI-ToSVG" "ComfyUI-ToSVG"

# Install pylatexenc for kokoro
echo -e "${green}::::::::::::::: Installing pylatexenc for kokoro ${green}::::::::::::::${reset}"
source venv/bin/activate
pip3 install --no-cache-dir pylatexenc $silent
echo ""

get_node "https://github.com/stavsap/comfyui-kokoro" "comfyui-kokoro"
get_node "https://github.com/CY-CHENYUE/ComfyUI-Janus-Pro" "janus-pro"
get_node "https://github.com/smthemex/ComfyUI_Sonic" "ComfyUI_Sonic"
get_node "https://github.com/welltop-cn/ComfyUI-TeaCache" "teacache"
get_node "https://github.com/kk8bit/KayTool" "kaytool"
get_node "https://github.com/shiimizu/ComfyUI-TiledDiffusion" "ComfyUI-TiledDiffusion"
get_node "https://github.com/Lightricks/ComfyUI-LTXVideo" "ComfyUI-LTXVideo"
get_node "https://github.com/kijai/ComfyUI-KJNodes" "comfyui-kjnodes"

# Install onnxruntime
echo -e "${green}::::::::::::::: Installing onnxruntime ${green}::::::::::::::${reset}"
source venv/bin/activate
python3 -m pip install --no-cache-dir onnxruntime-gpu $silent

# Create run_comfyui.sh script
echo -e "${green}::::::::::::::: Creating Startup Script ${green}::::::::::::::${reset}"
cat > run_comfyui.sh << 'EOL'
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

# Run ComfyUI
python ComfyUI/main.py --listen 0.0.0.0 --port 8188 "$@"
EOL

# Make the script executable
chmod +x run_comfyui.sh

# Calculate installation time
end=$(date +%H:%M:%S)

# Display completion message
echo -e "\n${green}::::::::::::::: Installation Complete ${green}::::::::::::::${reset}"
echo -e "Start time: $start"
echo -e "End time:   $end"
echo -e "\nTo start ComfyUI, run:"
echo -e "  ${bold}cd ComfyUI-Easy-Install && ./run_comfyui.sh${reset}"
echo -e "\nThen open your browser to:"
echo -e "  ${bold}http://localhost:8188${reset}"
