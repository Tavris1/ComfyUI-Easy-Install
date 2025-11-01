#!/bin/bash

# Navigate to the ComfyUI custom nodes directory
cd "$(dirname "$0")/ComfyUI/custom_nodes"

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
