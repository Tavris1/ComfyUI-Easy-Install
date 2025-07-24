#!/bin/bash

# Color definitions
green='\033[0;32m'
yellow='\033[1;33m'
red='\033[0;31m'
reset='\033[0m'

echo -e "${green}::::::::::::::: Setting up LLM model symlinks ${green}::::::::::::::${reset}"
echo ""

# Define paths
DEFAULT_LLM_PATH="/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI/models/llm_gguf"
EXTERNAL_LLM_PATH="/mnt/models/llm_gguf"

# Check if external path exists
if [ ! -d "$EXTERNAL_LLM_PATH" ]; then
    echo -e "${red}Error: External LLM model path $EXTERNAL_LLM_PATH does not exist.${reset}"
    exit 1
fi

# Create default path if it doesn't exist
if [ ! -d "$DEFAULT_LLM_PATH" ]; then
    echo -e "${yellow}Creating directory: $DEFAULT_LLM_PATH${reset}"
    mkdir -p "$DEFAULT_LLM_PATH"
fi

# Check if there are any models in the external path
MODEL_COUNT=$(ls -1 "$EXTERNAL_LLM_PATH"/*.gguf 2>/dev/null | wc -l)
if [ "$MODEL_COUNT" -eq 0 ]; then
    echo -e "${yellow}Warning: No .gguf models found in $EXTERNAL_LLM_PATH${reset}"
    echo "Please make sure your models are in this location."
    exit 1
fi

# Create symbolic links for all .gguf files
echo -e "${green}Creating symbolic links for LLM models:${reset}"
for model_file in "$EXTERNAL_LLM_PATH"/*.gguf; do
    model_name=$(basename "$model_file")
    target_link="$DEFAULT_LLM_PATH/$model_name"
    
    # Remove existing link or file if it exists
    if [ -e "$target_link" ] || [ -L "$target_link" ]; then
        echo -e "${yellow}Removing existing link: $target_link${reset}"
        rm "$target_link"
    fi
    
    # Create the symbolic link
    ln -s "$model_file" "$target_link"
    echo -e "${green}Created link: ${yellow}$model_name${reset}"
done

echo ""
echo -e "${green}::::::::::::::: Symlinks created successfully ${green}::::::::::::::${reset}"
echo -e "You can now use the Searge_LLM_Node with models from ${yellow}$EXTERNAL_LLM_PATH${reset}"
echo -e "The models are now accessible at ${yellow}$DEFAULT_LLM_PATH${reset}"
echo ""
