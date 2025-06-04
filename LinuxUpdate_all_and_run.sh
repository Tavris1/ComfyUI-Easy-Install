#!/bin/bash
# ComfyUI-Update All and RUN for Linux
# Adapted from the Windows version by ivo
# Pixaroma Community Edition

# Set colors
green="\033[92m"
reset="\033[0m"

# Define the correct base directory
# This is important because the script might be run from different locations
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
BASE_DIR="$SCRIPT_DIR"
UPDATE_DIR="$BASE_DIR/ComfyUI-Easy-Install/update"
PYTHON_PATH="$BASE_DIR/ComfyUI-Easy-Install/python_embedded/bin/python"
COMFYUI_DIR="$BASE_DIR/ComfyUI-Easy-Install/ComfyUI"

export COMFYUI_PATH="$COMFYUI_DIR"

echo -e "${green}::::::::::::::: Updating ComfyUI :::::::::::::::${reset}"
echo

# Check if update directory exists
if [ -d "$UPDATE_DIR" ]; then
    cd "$UPDATE_DIR"

    # Run the Python update script
    "$PYTHON_PATH" update.py "$COMFYUI_DIR"

    # Check if the updater itself was updated
    if [ -f "update_new.py" ]; then
        mv -f update_new.py update.py
        echo "Running updater again since it got updated."
        "$PYTHON_PATH" update.py "$COMFYUI_DIR" --skip_self_update
    fi

    cd "$BASE_DIR"
else
    echo "Update directory not found at $UPDATE_DIR. Skipping ComfyUI update."
fi

echo

echo -e "${green}::::::::::::::: Updating All Nodes :::::::::::::::${reset}"
echo

# Check if ComfyUI-Manager exists
if [ -d "$COMFYUI_DIR/custom_nodes/ComfyUI-Manager" ]; then
    # Use the ComfyUI-Manager CLI to update all nodes
    "$PYTHON_PATH" "$COMFYUI_DIR/custom_nodes/ComfyUI-Manager/cm-cli.py" update all
else
    echo "ComfyUI-Manager not found at $COMFYUI_DIR/custom_nodes/ComfyUI-Manager. Skipping node updates."
fi

echo

echo -e "${green}::::::::::::::: Done. Starting ComfyUI :::::::::::::::${reset}"
echo

# Run ComfyUI with optimized settings for Linux
if [ -f "$BASE_DIR/run_comfyui.sh" ]; then
    "$BASE_DIR/run_comfyui.sh"
else
    echo "run_comfyui.sh not found at $BASE_DIR/run_comfyui.sh. Cannot start ComfyUI."
fi
