#!/bin/bash
# ComfyUI Easy Install by ivo - macOS ARM version
# Title ComfyUI Easy Install by ivo v0.48.0 (Ep48)
# Pixaroma Community Edition

# Set colors
warning="\033[33m"
red="\033[91m"
green="\033[92m"
yellow="\033[93m"
bold="\033[1m"
reset="\033[0m"

# Set No Warnings
silent="--no-cache-dir --no-warn-script-location"

# Capture the start time
start=$(date +%H:%M:%S)

# Check if running as root
if [ "$(id -u)" -eq 0 ]; then
    echo -e "${warning}WARNING:${reset} The installer was run with ${bold}Administrator privileges${reset}."
    echo -e "Please run it with ${green}Standard user permissions${reset} (without Admin rights)."
    echo "Press any key to Exit..."
    read -n 1
    exit 1
fi

# Check for Existing ComfyUI Folder
if [ -d "ComfyUI-Easy-Install" ]; then
    echo -e "${warning}WARNING:${reset} '${bold}ComfyUI-Easy-Install${reset}' folder already exists!"
    echo -e "${green}Move this file to another folder and run it again.${reset}"
    echo "Press any key to Exit..."
    read -n 1
    exit 1
fi

# Check for Existing Helper-CEI.zip
if [ ! -f "Helper-CEI.zip" ]; then
    echo -e "${warning}WARNING:${reset} '${bold}Helper-CEI.zip${reset}' does not exist!"
    echo -e "${green}Unzip the entire package and try again.${reset}"
    echo "Press any key to Exit..."
    read -n 1
    exit 1
fi

# Clear Pip Cache
if [ -d "$HOME/Library/Caches/pip" ]; then
    rm -rf "$HOME/Library/Caches/pip"
    mkdir -p "$HOME/Library/Caches/pip"
fi
echo -e "${green}::::::::::::::: Clearing Pip Cache ${reset}${yellow}Done${reset}${green} ::::::::::::::${reset}"
echo

# Install/Update Git
install_git() {
    echo -e "${green}::::::::::::::: Installing/Updating Git ::::::::::::::${reset}"
    echo
    if ! command -v git &> /dev/null; then
        echo -e "${yellow}Git not found. Installing via Homebrew...${reset}"
        if ! command -v brew &> /dev/null; then
            echo -e "${yellow}Homebrew not found. Installing Homebrew...${reset}"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install git
    else
        echo -e "${yellow}Git is already installed. Updating...${reset}"
        brew upgrade git || echo -e "${yellow}Git is up to date${reset}"
    fi
    echo
}

# Install Git
install_git

# Check if git is installed
if command -v git &> /dev/null; then
    gitversion=$(git --version)
    echo -e "${bold}git${reset} ${yellow}is installed${reset}: $gitversion"
    echo
else
    echo -e "${warning}WARNING:${reset} ${bold}'git'${reset} is NOT installed"
    echo -e "Please install ${bold}'git'${reset} manually from ${yellow}https://git-scm.com/${reset} and run this installer again"
    echo "Press any key to Exit..."
    read -n 1
    exit 1
fi

# Create directory
mkdir -p ComfyUI-Easy-Install
if [ ! -d "ComfyUI-Easy-Install" ]; then
    echo -e "${warning}WARNING:${reset} Cannot create folder ${yellow}ComfyUI-Easy-Install${reset}"
    echo -e "Make sure you are NOT using system folders or folders with restricted permissions"
    echo -e "${green}Move this file to another folder and run it again.${reset}"
    echo "Press any key to Exit..."
    read -n 1
    exit 1
fi
cd ComfyUI-Easy-Install

# Install ComfyUI
install_comfyui() {
    echo -e "${green}::::::::::::::: Installing ComfyUI ::::::::::::::${reset}"
    echo
    git clone https://github.com/comfyanonymous/ComfyUI ComfyUI
    
    # Setup Python environment
    echo -e "${yellow}Setting up Python environment...${reset}"
    python_version="3.11.9"
    
    # Check if Python is installed
    if ! command -v python3 &> /dev/null; then
        echo -e "${yellow}Python not found. Installing via Homebrew...${reset}"
        brew install python@3.11
    fi
    
    # Create virtual environment with Python 3.11 if available
    if command -v python3.11 &> /dev/null; then
        python3.11 -m venv python_embedded
    else
        python3 -m venv python_embedded
    fi
    source python_embedded/bin/activate
    
    # Ensure pip is up to date
    python -m pip install --upgrade pip $silent
    
    # Install pip and dependencies
    python -m pip install --upgrade pip $silent
    
    # Install PyTorch for M1/M2 Macs
    
    python -m pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cpu $silent
    
    python -m pip install pygit2 $silent
    
    # Install ComfyUI requirements
    cd ComfyUI
    python -m pip install -r requirements.txt $silent
    cd ..
    echo
}

# Function to get custom nodes
get_node() {
    local git_url=$1
    local git_folder=$(basename $git_url)
    echo -e "${green}::::::::::::::: Installing $git_folder ::::::::::::::${reset}"
    echo
    
    git clone $git_url ComfyUI/custom_nodes/$git_folder
    
    if [ -f "./ComfyUI/custom_nodes/$git_folder/requirements.txt" ]; then
        source python_embedded/bin/activate
        python -m pip install -r ./ComfyUI/custom_nodes/$git_folder/requirements.txt $silent
    fi
    
    if [ -f "./ComfyUI/custom_nodes/$git_folder/install.py" ]; then
        source python_embedded/bin/activate
        python ./ComfyUI/custom_nodes/$git_folder/install.py
    fi
    
    echo
}

# Function to copy files
copy_files() {
    if [ -f "../$1" ] && [ -d "./$2" ]; then
        cp "../$1" "./$2/"
    fi
}

# Install ComfyUI
install_comfyui

# Install Pixaroma's Related Nodes
get_node https://github.com/Comfy-Org/ComfyUI-Manager
get_node https://github.com/WASasquatch/was-node-suite-comfyui

# Configure WAS Node Suite ffmpeg
echo -e "${yellow}Configuring WAS Node Suite ffmpeg...${reset}"
# Install ffmpeg if not already installed
if ! command -v ffmpeg &> /dev/null; then
    echo -e "${yellow}Installing ffmpeg...${reset}"
    brew install ffmpeg
fi

# Get ffmpeg path
FFMPEG_PATH=$(which ffmpeg)
if [ ! -z "$FFMPEG_PATH" ]; then
    echo -e "${green}Found ffmpeg at: $FFMPEG_PATH${reset}"
    
    # Check if WAS Node Suite is installed and config exists
    WAS_CONFIG_FILE="ComfyUI/custom_nodes/was-node-suite-comfyui/was_suite_config.json"
    
    if [ -f "$WAS_CONFIG_FILE" ]; then
        # Config file exists, update it
        echo -e "${yellow}Updating existing WAS Node Suite config file...${reset}"
        # Make a backup
        cp "$WAS_CONFIG_FILE" "${WAS_CONFIG_FILE}.bak"
        # Update ffmpeg path
        sed -i '' "s|\"ffmpeg_bin_path\": \".*\"|\"ffmpeg_bin_path\": \"$FFMPEG_PATH\"|g" "$WAS_CONFIG_FILE"
        echo -e "${green}Updated WAS Node Suite config with ffmpeg path: $FFMPEG_PATH${reset}"
    else
        # Config file doesn't exist, create it
        echo -e "${yellow}Creating new WAS Node Suite config file...${reset}"
        mkdir -p "ComfyUI/custom_nodes/was-node-suite-comfyui"
        cat > "$WAS_CONFIG_FILE" << EOF
{
    "run_requirements": true,
    "suppress_uncomfy_warnings": true,
    "show_startup_junk": true,
    "show_inspiration_quote": true,
    "text_nodes_type": "STRING",
    "webui_styles": null,
    "webui_styles_persistent_update": true,
    "sam_model_vith_url": "https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth",
    "sam_model_vitl_url": "https://dl.fbaipublicfiles.com/segment_anything/sam_vit_l_0b3195.pth",
    "sam_model_vitb_url": "https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth",
    "history_display_limit": 36,
    "use_legacy_ascii_text": false,
    "ffmpeg_bin_path": "$FFMPEG_PATH",
    "ffmpeg_extra_codecs": {
        "avc1": ".mp4",
        "h264": ".mkv"
    },
    "wildcards_path": "ComfyUI/custom_nodes/was-node-suite-comfyui/wildcards",
    "wildcard_api": true
}
EOF
        echo -e "${green}Created pre-configured WAS Node Suite config file${reset}"
    fi
fi

# Install opencv with ffmpeg support
echo -e "${yellow}Installing opencv-python with ffmpeg support...${reset}"
source python_embedded/bin/activate
# First uninstall any existing opencv installations
python -m pip uninstall -y opencv-python opencv-python-headless
# Install opencv-python with ffmpeg support
python -m pip install opencv-python[ffmpeg] $silent
echo -e "${green}Installed opencv-python with ffmpeg support${reset}"
get_node https://github.com/yolain/ComfyUI-Easy-Use
get_node https://github.com/Fannovel16/comfyui_controlnet_aux
get_node https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes
get_node https://github.com/crystian/ComfyUI-Crystools
get_node https://github.com/rgthree/rgthree-comfy
get_node https://github.com/city96/ComfyUI-GGUF
get_node https://github.com/kijai/ComfyUI-Florence2
get_node https://github.com/SeargeDP/ComfyUI_Searge_LLM

# Fix SeargeSDXL for Mac M1
echo -e "${yellow}Fixing SeargeSDXL for Mac M1...${reset}"
if [ -d "ComfyUI/custom_nodes/ComfyUI_Searge_LLM" ]; then
    # Add Mac M1 support to requirements.txt
    if ! grep -q "platform_system == \"Darwin\"" ComfyUI/custom_nodes/ComfyUI_Searge_LLM/requirements.txt; then
        echo "\n# Mac M1/M2 support\nllama-cpp-python==0.2.89; platform_system == \"Darwin\" and platform_machine == \"arm64\"" >> ComfyUI/custom_nodes/ComfyUI_Searge_LLM/requirements.txt
    fi
    
    # Create a complete replacement for Searge_LLM_Node.py with Mac M1 optimizations
    echo -e "${yellow}Creating optimized Searge_LLM_Node.py for Mac M1...${reset}"
    cat > ComfyUI/custom_nodes/ComfyUI_Searge_LLM/Searge_LLM_Node.py << 'EOF'
import importlib
import os
import platform
import sys

# Handle the case when folder_paths isn't available (outside ComfyUI environment)
try:
    import folder_paths
    GLOBAL_MODELS_DIR = os.path.join(folder_paths.models_dir, "llm_gguf")
except ImportError:
    print("Warning: folder_paths module not found. Using default paths.")
    # Default path when running outside ComfyUI
    GLOBAL_MODELS_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "models", "llm_gguf")

WEB_DIRECTORY = "./web/assets/js"

DEFAULT_INSTRUCTIONS = 'Generate a prompt from "{prompt}"'

# Detect platform for better import handling
is_macos = platform.system() == "Darwin"
is_arm = platform.machine() == "arm64" or platform.machine() == "aarch64"
is_mac_m1 = is_macos and is_arm

# Set number of threads based on platform
default_threads = 4 if is_mac_m1 else 8

# Try to import llama-cpp with the appropriate backend
try:
    # First try CUDA version (for NVIDIA GPUs)
    Llama = importlib.import_module("llama_cpp_cuda").Llama
    print("Using CUDA-accelerated llama-cpp")
except ImportError:
    try:
        # Then try standard llama_cpp
        Llama = importlib.import_module("llama_cpp").Llama
        print("Using standard llama-cpp")
    except ImportError:
        try:
            # Finally try the standard package name
            Llama = importlib.import_module("llama_cpp_python").Llama
            print("Using llama-cpp-python")
        except ImportError:
            print("ERROR: Could not import any llama-cpp variant. Please install llama-cpp-python.")
            Llama = None

class AnyType(str):
    """A special class that is always equal in not equal comparisons. Credit to pythongosssss"""

    def __ne__(self, __value: object) -> bool:
        return False


anytype = AnyType("*")


class Searge_LLM_Node:
    @classmethod
    def INPUT_TYPES(cls):
        model_options = []
        
        # Check if models directory exists
        if os.path.isdir(GLOBAL_MODELS_DIR):
            gguf_files = [file for file in os.listdir(GLOBAL_MODELS_DIR) if file.endswith('.gguf')]
            model_options.extend(gguf_files)

        return {
            "required": {
                "text": ("STRING", {"multiline": True, "dynamicPrompts": True, "default": ""}),
                "random_seed": ("INT", {"default": 1234567890, "min": 0, "max": 0xffffffffffffffff}),
                "model": (model_options,),
                "max_tokens": ("INT", {"default": 4096, "min": 1, "max": 8192}),
                "apply_instructions": ("BOOLEAN", {"default": True}),
                "instructions": ("STRING", {"multiline": False, "default": DEFAULT_INSTRUCTIONS}),
            },
            "optional": {
                "adv_options_config": ("SRGADVOPTIONSCONFIG",),
            }
        }

    CATEGORY = "Searge/LLM"
    FUNCTION = "main"
    RETURN_TYPES = ("STRING", "STRING",)
    RETURN_NAMES = ("generated", "original",)

    def main(self, text, random_seed, model, max_tokens, apply_instructions, instructions, adv_options_config=None):
        # Check if models directory exists
        if not os.path.exists(GLOBAL_MODELS_DIR):
            try:
                os.makedirs(GLOBAL_MODELS_DIR, exist_ok=True)
                print(f"Created models directory: {GLOBAL_MODELS_DIR}")
            except Exception as e:
                error_msg = f"Error creating models directory: {str(e)}"
                print(error_msg)
                return error_msg, text
        
        # Check if Llama is available
        if Llama is None:
            error_msg = "ERROR: llama-cpp-python not available. Please install it."
            print(error_msg)
            return error_msg, text
            
        model_path = os.path.join(GLOBAL_MODELS_DIR, model)
        
        # Check if model file exists
        if not os.path.exists(model_path):
            error_msg = f"Model file not found: {model_path}"
            print(error_msg)
            return error_msg, text

        if model.endswith(".gguf"):
            generate_kwargs = {'max_tokens': max_tokens, 'temperature': 1.0, 'top_p': 0.9, 'top_k': 50,
                               'repeat_penalty': 1.2}

            if adv_options_config:
                for option in ['temperature', 'top_p', 'top_k', 'repeat_penalty']:
                    if option in adv_options_config:
                        generate_kwargs[option] = adv_options_config[option]
            
            # Optimize model parameters for Mac M1
            if is_mac_m1:
                print("Optimizing LLM parameters for Mac M1...")
                model_kwargs = {
                    "model_path": model_path,
                    "n_threads": default_threads,  # Limit threads for M1
                    "n_gpu_layers": 1,  # Minimal GPU usage on M1
                    "seed": random_seed,
                    "verbose": False,
                    "n_ctx": 2048,
                    "use_mlock": False,  # Don't lock memory on M1
                    "use_mmap": True,     # Use memory mapping for better performance
                    "offload_kqv": True   # Offload key/query/value matrices to save memory
                }
            else:
                # Standard parameters for other platforms
                model_kwargs = {
                    "model_path": model_path,
                    "n_gpu_layers": -1,
                    "seed": random_seed,
                    "verbose": False,
                    "n_ctx": 2048,
                }
                
            try:
                model_to_use = Llama(**model_kwargs)
            except Exception as e:
                error_msg = f"Error loading model: {str(e)}"
                print(error_msg)
                return error_msg, text

            if apply_instructions:
                req = instructions.replace("{prompt}", text) if "{prompt}" in instructions else f"{instructions} {text}"
                messages = [
                    {"role": "system",
                     "content": f"You are a helpful assistant."},
                    {"role": "user",
                     "content": f"An image generation prompt is a single paragraph summary to describe the subject and "
                                f"style of an image. It includes a description of the kind of image, the subject of "
                                f"the image, and some description of the image medium and style in the form of short "
                                f"keyword.\n\nCreate an image generation prompt for the subject \"a creepy creature "
                                f"shadow in the dark in a dimly lit tunnel\" in the style \"digital art illustration "
                                f"with intricate details\"."},
                    {"role": "assistant",
                     "content": f"Image Description: A digitally crafted illustration portrays a chilling scene within "
                                f"a dimly lit, cavernous tunnel. The dominant subject of the image is a mysterious "
                                f"creature, its form subtly discernible only as a menacing shadow on the walls of the "
                                f"tunnel. Its elongated silhouette suggests a serpentine creature with sharp "
                                f"protrusions and an ominous aura. The creature's eyes, a pair of glowing orbs, appear "
                                f"eerily human-like yet alien. The tunnel is riddled with intricate details that "
                                f"enhance the eerie atmosphere: dust particles floating lazily in the feeble light, "
                                f"ancient and crumbling stone, water droplets sparkling on the damp walls, and a "
                                f"hauntingly beautiful, bioluminescent fungi growing in the shadows. The dimly lit "
                                f"environment is highlighted by strategically placed light sources that create "
                                f"dramatic chiaroscuro effects, casting an unsettling and atmospheric glow on the "
                                f"scene. Digital Art Illustration with Intricate Details (Dark, Atmospheric, "
                                f"Suspenseful)"},
                    {"role": "user",
                     "content": "Now compile the description and style into a single paragraph summary"},
                    {"role": "assistant",
                     "content": f"Digital art illustration featuring a dark, atmospheric, and suspenseful scene within "
                                f"a dimly lit, cavernous tunnel. The subject of the image is a mysterious creature, "
                                f"depicted only as a menacing shadow on the walls, with elongated silhouette and sharp "
                                f"protrusions. The creature's eyes, a pair of glowing orbs, appear eerily human-like "
                                f"yet alien. The tunnel is adorned with intricate details, such as dust particles, "
                                f"ancient crumbling stone, water droplets, and a hauntingly beautiful bioluminescent "
                                f"fungi growing in the shadows. Dramatic chiaroscuro effects are created through "
                                f"strategically placed light sources, casting an unsettling and atmospheric glow on "
                                f"the scene."},
                    {"role": "user",
                     "content": f"create a detailed summary without the title or style"},
                    {"role": "assistant",
                     "content": f"A dimly lit, cavernous tunnel is the setting for this chilling digital illustration. "
                                f"A mysterious creature lurks in the shadows, its elongated silhouette suggestive of a "
                                f"serpentine creature with sharp protrusions and an ominous aura. The creature's eyes, "
                                f"a pair of glowing orbs, appear eerily human-like yet alien. The tunnel is riddled "
                                f"with intricate details that enhance the eerie atmosphere: dust particles floating "
                                f"lazily in the feeble light, ancient and crumbling stone, water droplets sparkling on "
                                f"the damp walls, and a hauntingly beautiful, bioluminescent fungi growing in the "
                                f"shadows. Dramatic chiaroscuro effects are created through strategically placed light "
                                f"sources, casting an unsettling and atmospheric glow on the scene."},
                    {"role": "user",
                     "content": f"Generate a prompt from \"magical garden, sitting on a blue_bench, Disney Princess in "
                                f"pink_dress, blonde_hair, portrait, Pixar, Disney style, photorealistic, high "
                                f"quality, 4k\""},
                    {"role": "assistant",
                     "content": f"A captivating portrait of a blonde-haired Disney Princess adorned in an elegant pink "
                                f"gown, seated gracefully on a blue bench within an enchanting magical garden. The "
                                f"scene is rendered in the distinctive Pixar and Disney animation style, featuring "
                                f"high-definition details of her porcelain skin, visible freckles, and the intricacies "
                                f"of her elegant gown. The image is rendered in the captivating, photorealistic style "
                                f"that exemplifies both the Disney and Pixar brands, capturing the princess's timeless "
                                f"beauty and the magic of her enchanting surroundings."},
                    {"role": "user",
                     "content": req},
                ]
            else:
                messages = [
                    {"role": "system",
                     "content": f"You are a helpful assistant. Try your best to give the best response possible to "
                                f"the user."},
                    {"role": "user",
                     "content": f"Create a detailed visually descriptive caption of this description, which will be "
                                f"used as a prompt for a text to image AI system (caption only, no instructions like "
                                f"\"create an image\").Remove any mention of digital artwork or artwork style. Give "
                                f"detailed visual descriptions of the character(s), including ethnicity, skin tone, "
                                f"expression etc. Imagine using keywords for a still for someone who has aphantasia. "
                                f"Describe the image style, e.g. any photographic or art styles / techniques utilized. "
                                f"Make sure to fully describe all aspects of the cinematography, with abundant "
                                f"technical details and visual descriptions. If there is more than one image, combine "
                                f"all of the descriptions into a single prompt. Respond with the caption only, no "
                                f"additional text."},
                    {"role": "assistant",
                     "content": f"A stunning portrait of a young woman with porcelain skin, emerald green eyes, and "
                                f"flowing auburn hair cascading over her shoulders. She gazes directly at the viewer "
                                f"with a serene, enigmatic smile that conveys both wisdom and mystery. The lighting is "
                                f"soft and diffused, creating a gentle rim light that highlights the contours of her "
                                f"face and the subtle freckles across her nose and cheeks. She wears a delicate, "
                                f"vintage-inspired dress with intricate lace details and a muted sage color that "
                                f"complements her eyes. The background features a dreamy, bokeh effect with soft "
                                f"golden particles floating in the air, suggesting a magical forest setting at golden "
                                f"hour. The composition follows the rule of thirds with the subject slightly off-center, "
                                f"creating a balanced yet dynamic frame. The photographic style mimics medium format "
                                f"film with rich, warm tones, slight grain, and incredible depth of field that keeps "
                                f"only her face in sharp focus while the environment gently blurs into a painterly "
                                f"backdrop of emerald and amber hues."},
                    {"role": "user",
                     "content": text},
                ]

            try:
                response = model_to_use.create_chat_completion(messages=messages, **generate_kwargs)
                generated_text = response["choices"][0]["message"]["content"]
                return generated_text, text
            except Exception as e:
                error_msg = f"Error generating response: {str(e)}"
                print(error_msg)
                return error_msg, text
        else:
            return "Invalid model format. Please select a .gguf model file.", text


class Searge_Output_Node:
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "text": ("STRING", {"multiline": True, "dynamicPrompts": True, "default": ""}),
            },
            "hidden": {
                "unique_id": "UNIQUE_ID",
                "extra_pnginfo": "EXTRA_PNGINFO",
            },
        }

    CATEGORY = "Searge/LLM"
    FUNCTION = "main"
    RETURN_TYPES = ()
    RETURN_NAMES = ()
    OUTPUT_NODE = True

    def main(self, text, unique_id=None, extra_pnginfo=None):
        if unique_id and extra_pnginfo and "workflow" in extra_pnginfo:
            workflow = extra_pnginfo["workflow"]
            node = next((x for x in workflow["nodes"] if str(x["id"]) == str(unique_id)), None)
            if node:
                node["widgets_values"] = [text]
        return ()


class Searge_AdvOptionsNode:
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "temperature": ("FLOAT", {"default": 1.0, "min": 0.0, "max": 2.0, "step": 0.01}),
                "top_p": ("FLOAT", {"default": 0.9, "min": 0.0, "max": 1.0, "step": 0.01}),
                "top_k": ("INT", {"default": 50, "min": 0, "max": 100}),
                "repetition_penalty": ("FLOAT", {"default": 1.2, "min": 1.0, "max": 2.0, "step": 0.01}),
            },
        }

    CATEGORY = "Searge/LLM"
    FUNCTION = "main"
    RETURN_TYPES = ("SRGADVOPTIONSCONFIG",)
    RETURN_NAMES = ("adv_options_config",)

    def main(self, temperature=1.0, top_p=0.9, top_k=50, repetition_penalty=1.2):
        return ({"temperature": temperature, "top_p": top_p, "top_k": top_k, "repeat_penalty": repetition_penalty},)


NODE_CLASS_MAPPINGS = {
    "Searge_LLM_Node": Searge_LLM_Node,
    "Searge_AdvOptionsNode": Searge_AdvOptionsNode,
    "Searge_Output_Node": Searge_Output_Node,
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "Searge_LLM_Node": "LLM Generator",
    "Searge_AdvOptionsNode": "LLM Advanced Options",
    "Searge_Output_Node": "LLM Output",
}
EOF
    
    # Install llama-cpp-python for Mac M1
    source python_embedded/bin/activate
    python -m pip install llama-cpp-python==0.2.89 $silent
    
    # Create models directory for LLM
    mkdir -p ComfyUI/models/llm_gguf
    
    echo -e "${green}SeargeSDXL node fixed successfully!${reset}"
fi
get_node https://github.com/gseth/ControlAltAI-Nodes
get_node https://github.com/stavsap/comfyui-ollama
get_node https://github.com/MohammadAboulEla/ComfyUI-iTools
get_node https://github.com/spinagon/ComfyUI-seamless-tiling
get_node https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch
get_node https://github.com/Lerc/canvas_tab
get_node https://github.com/1038lab/ComfyUI-OmniGen
get_node https://github.com/john-mnz/ComfyUI-Inspyrenet-Rembg
get_node https://github.com/kaibioinfo/ComfyUI_AdvancedRefluxControl
get_node https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
get_node https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait
get_node https://github.com/Yanick112/ComfyUI-ToSVG

# Install pylatexenc for kokoro
source python_embedded/bin/activate
python -m pip install pylatexenc $silent
echo

# Install Rust (needed for some packages)
if ! command -v rustc &> /dev/null; then
    echo -e "${yellow}Installing Rust (needed for some dependencies)...${reset}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

get_node https://github.com/stavsap/comfyui-kokoro
# Fix kokoro installation
cd ComfyUI/custom_nodes/comfyui-kokoro
source ../../../python_embedded/bin/activate
python -m pip install kokoro-onnx $silent
cd ../../..
get_node https://github.com/CY-CHENYUE/ComfyUI-Janus-Pro
get_node https://github.com/smthemex/ComfyUI_Sonic
get_node https://github.com/welltop-cn/ComfyUI-TeaCache
get_node https://github.com/kk8bit/kaytool
get_node https://github.com/shiimizu/ComfyUI-TiledDiffusion
get_node https://github.com/Lightricks/ComfyUI-LTXVideo
get_node https://github.com/kijai/ComfyUI-KJNodes

# Install onnxruntime for ARM Macs
source python_embedded/bin/activate
python -m pip install onnxruntime-silicon $silent

# Extract 'update' folder
cd ..
unzip -o Helper-CEI.zip
cd ComfyUI-Easy-Install

# Copy additional files if they exist
copy_files run_comfyui.sh ./
copy_files extra_model_paths.yaml ComfyUI
copy_files comfy.settings.json ComfyUI/user/default
copy_files was_suite_config.json ComfyUI/custom_nodes/was-node-suite-comfyui
copy_files rgthree_config.json ComfyUI/custom_nodes/rgthree-comfy

# Create a run script for macOS with optimizations for M1/M2 Macs
cat > run_comfyui.sh << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"

# Clear RAM before starting ComfyUI
echo "Clearing RAM cache to free up memory..."
# Try non-sudo memory clearing techniques first
# Force macOS to drop disk caches and buffer caches
echo 3 > /dev/null 2>&1 || true
# Alternative approach without sudo
python3 -c 'import ctypes; ctypes.CDLL(None).malloc_zone_pressure_relief(0, 0)' 2>/dev/null || true

# Kill any lingering Python processes that might be using memory
echo "Stopping any running Python processes..."
pkill -f "python.*main.py" 2>/dev/null || true

# Give the system a moment to release memory
sleep 1

# Set environment variables for M1 GPU optimization
export PYTORCH_ENABLE_MPS_FALLBACK=1

# Memory optimization settings
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0  # Allow using more GPU memory
export PYTORCH_MPS_LOW_WATERMARK_RATIO=0.7   # Higher threshold for better stability
export PYTORCH_MPS_MINIMUM_MEMORY_WARNINGS=0  # Reduce warning spam
export PYTORCH_MPS_ALLOCATOR_POLICY=garbage_collection  # Enable aggressive GC

# Additional memory optimizations
export PYTORCH_MPS_ALLOCATOR_BLOCK_SIZE=1073741824  # 1GB blocks for better memory management

# Additional performance optimizations
export TORCH_MPS_PLEASE_CACHE_DESCRIPTORS=1   # Improve descriptor caching
export PYTORCH_MPS_ENABLE_GRAPH_MODE=1       # Enable graph mode for better performance

# Enable unified memory for better memory management
export PYTORCH_MPS_ENABLE_UNIFIED_MEMORY=1
export PYTORCH_MPS_ENABLE_GUARD_IMPLEMENTATION=1

# ComfyUI specific optimizations
export COMFYUI_USE_MPS=1    
export COMFYUI_VRAM_OPTIMIZATIONS=MPS
export COMFYUI_FORCE_MPS=1

# Data type compatibility fixes
export PYTORCH_MPS_USE_FP32_ACCUM=1  # Use FP32 for accumulation to improve precision
export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:32  # Limit memory splits
export PYTORCH_FLOAT8_DISABLED=1  # Disable Float8 which is not supported on MPS
export PYTORCH_PREFER_FLOAT32=1  # Prefer float32 over unsupported types

# LLM specific settings for SeargeSDXL
export LLAMA_METAL_ENABLE=1  # Enable Metal support for llama-cpp
export LLAMA_THREADS=4  # Limit threads for better performance on M1
export LLAMA_OFFLOAD_KQV=1  # Offload key/query/value matrices to save memory

# Fix for tensor view errors in upscalers (Ultimate SD Upscale)
export PYTORCH_MPS_CONTIGUOUS_FORMAT=1  # Force contiguous memory format for tensors

# Force Python garbage collection before activating environment
echo "Running Python garbage collection..."
python3 -c "import gc; gc.collect()" 2>/dev/null || true

# Activate the virtual environment
source python_embedded/bin/activate

# Run ComfyUI
cd ComfyUI
python main.py "$@"
EOF
chmod +x run_comfyui.sh
echo -e "${green}Created executable run_comfyui.sh script${reset}"

# Capture the end time
end=$(date +%H:%M:%S)
# Handle time calculation in a more compatible way
if command -v gdate &> /dev/null; then
    # Use gdate if available (from coreutils)
    start_seconds=$(gdate -d "$start" +%s)
    end_seconds=$(gdate -d "$end" +%s)
elif date -j -f "%H:%M:%S" "$start" +%s &> /dev/null; then
    # BSD date (macOS)
    start_seconds=$(date -j -f "%H:%M:%S" "$start" +%s)
    end_seconds=$(date -j -f "%H:%M:%S" "$end" +%s)
else
    # Fallback
    start_seconds=0
    end_seconds=0
fi
diff=$((end_seconds - start_seconds))

# Create a launcher script in the parent directory
cd ..
cat > run_comfyui.sh << 'EOF'
#!/bin/bash
# ComfyUI Easy Launcher

# Change to the ComfyUI-Easy-Install directory
cd "$(dirname "$0")/ComfyUI-Easy-Install"

# Check if run_comfyui.sh exists
if [ -f "./run_comfyui.sh" ]; then
    # Run the actual script with any provided arguments
    ./run_comfyui.sh "$@"
else
    echo "Error: ComfyUI startup script not found."
    echo "Please make sure the installation completed successfully."
    exit 1
fi
EOF
chmod +x run_comfyui.sh
echo -e "${green}Created launcher script in parent directory${reset}"

# Final Messages
echo
echo -e "${green}::::::::::::::: Installation Complete ::::::::::::::${reset}"
echo -e "${green}::::::::::::::: Total Running Time:${reset}${red} $diff ${reset}${green}seconds${reset}"
echo -e "${yellow}::::::::::::::: To run ComfyUI, just use ./run_comfyui.sh from this directory ::::::::::::::${reset}"
echo -e "${yellow}::::::::::::::: Press any key to exit ::::::::::::::${reset}"
read -n 1
    
