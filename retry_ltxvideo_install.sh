#!/bin/bash

# Set the base directory to the script's directory
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Try to find the ComfyUI directory
if [ -d "$BASE_DIR/ComfyUI/custom_nodes" ]; then
    CUSTOM_NODES_DIR="$BASE_DIR/ComfyUI/custom_nodes"
elif [ -d "$BASE_DIR/ComfyUI-Easy-Install/ComfyUI/custom_nodes" ]; then
    CUSTOM_NODES_DIR="$BASE_DIR/ComfyUI-Easy-Install/ComfyUI/custom_nodes"
else
    echo "Error: Could not find ComfyUI/custom_nodes directory."
    echo "Please run this script from the ComfyUI-Easy-Install directory or provide the path to ComfyUI as an argument."
    exit 1
fi

echo "Using ComfyUI directory: $(dirname "$CUSTOM_NODES_DIR")"
cd "$CUSTOM_NODES_DIR"

# Remove the partially cloned directory if it exists
if [ -d "ComfyUI-LTXVideo" ]; then
    echo "Removing partially cloned ComfyUI-LTXVideo directory..."
    rm -rf ComfyUI-LTXVideo
fi

# Clone the repository again with Git LFS
echo "Cloning ComfyUI-LTXVideo with Git LFS..."
git clone https://github.com/Lightricks/ComfyUI-LTXVideo.git

# Navigate into the directory and pull LFS files
echo "Downloading LFS files..."
cd ComfyUI-LTXVideo
git lfs pull

echo "Installation complete!"
