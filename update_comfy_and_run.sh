#!/bin/bash
# ComfyUI-Update Comfy and RUN for macOS ARM
# Adapted from the Windows version by ivo
# Pixaroma Community Edition

# Set colors
green="\033[92m"
reset="\033[0m"

echo -e "${green}::::::::::::::: Updating ComfyUI :::::::::::::::${reset}"
echo

# Define paths
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
PYTHON="$SCRIPT_DIR/ComfyUI-Easy-Install/python_embedded/bin/python"
COMFYUI_DIR="$SCRIPT_DIR/ComfyUI-Easy-Install/ComfyUI"
UPDATE_DIR="$SCRIPT_DIR/ComfyUI-Easy-Install/update"

# Create update directory if it doesn't exist
mkdir -p "$UPDATE_DIR"
cd "$UPDATE_DIR"

# Download the update script if it doesn't exist
if [ ! -f "update.py" ]; then
  echo "Downloading update script..."
  curl -o update.py https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/update.py
fi

# Run the Python update script
"$PYTHON" update.py "$COMFYUI_DIR/"

# Check if the updater itself was updated
if [ -f "update_new.py" ]; then
  mv -f update_new.py update.py
  echo "Running updater again since it got updated."
  "$PYTHON" update.py "$COMFYUI_DIR/" --skip_self_update
fi

cd ..
echo
echo -e "${green}::::::::::::::: Done. Starting ComfyUI :::::::::::::::${reset}"
echo

# Run ComfyUI with optimized settings for macOS ARM
"$SCRIPT_DIR/run_comfyui.sh"
