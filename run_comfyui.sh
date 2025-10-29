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
