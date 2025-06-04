#!/bin/bash
# ComfyUI-Update Comfy and RUN for Linux
# Adapted from the macOS version
# Pixaroma Community Edition

# Set colors
green="\033[92m"
reset="\033[0m"

echo -e "${green}::::::::::::::: Updating ComfyUI :::::::::::::::${reset}"
echo

# Define paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_PYTHON="$SCRIPT_DIR/venv/bin/python"
COMFYUI_DIR="$SCRIPT_DIR/ComfyUI-Easy-Install/ComfyUI"
UPDATE_DIR="$SCRIPT_DIR/ComfyUI-Easy-Install/update"

# Check if virtual environment exists
if [ ! -f "$VENV_PYTHON" ]; then
    echo "Error: Python virtual environment not found at $VENV_PYTHON"
    echo "Make sure ComfyUI is properly installed."
    exit 1
fi

# Create update directory if it doesn't exist
mkdir -p "$UPDATE_DIR"
cd "$UPDATE_DIR" || exit 1

# Download the update script if it doesn't exist
if [ ! -f "update.py" ]; then
    echo "Downloading update script..."
    if ! curl -f -o update.py https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/update.py; then
        echo "Error: Failed to download update script"
        exit 1
    fi
fi

# Run the Python update script
echo "Updating ComfyUI..."
if ! "$VENV_PYTHON" update.py "$COMFYUI_DIR/"; then
    echo "Error: Failed to update ComfyUI"
    exit 1
fi

# Check if the updater itself was updated
if [ -f "update_new.py" ]; then
    mv -f update_new.py update.py
    echo "Running updater again since it got updated."
    if ! "$VENV_PYTHON" update.py "$COMFYUI_DIR/" --skip_self_update; then
        echo "Error: Failed to run updated updater"
        exit 1
    fi
fi

echo -e "\n${green}ComfyUI update completed successfully!${reset}"
echo "You can now start ComfyUI using:"
echo "cd $(dirname "$COMFYUI_DIR") && ./run_comfyui.sh"