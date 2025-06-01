#!/bin/bash

# Define paths
MODELS_SOURCE="/mnt/models"
COMFYUI_MODELS="/root/ComfyUI-Easy-Install/ComfyUI/models"

# Check if source directory exists
if [ ! -d "$MODELS_SOURCE" ]; then
    echo "Error: Source directory $MODELS_SOURCE does not exist!"
    exit 1
fi

# Check if ComfyUI models directory exists
if [ ! -d "$COMFYUI_MODELS" ]; then
    echo "Error: ComfyUI models directory $COMFYUI_MODELS does not exist!"
    exit 1
fi

# Change to ComfyUI models directory
cd "$COMFYUI_MODELS"

echo "Creating symbolic links from $MODELS_SOURCE to $COMFYUI_MODELS"
echo "Found directories:"

# List all directories in source and create symbolic links
for dir in "$MODELS_SOURCE"/*/ ; do
    if [ -d "$dir" ]; then
        dirname=$(basename "$dir")
        
        # Skip special directories
        if [[ "$dirname" == "#"* || "$dirname" == "."* ]]; then
            continue
        fi
        
        echo "Found: $dirname"
        
        # Remove existing link or directory if it exists
        if [ -e "$dirname" ]; then
            echo "  Removing existing: $dirname"
            rm -rf "$dirname"
        fi
        
        # Create symbolic link
        echo "  Creating link: $dirname"
        ln -s "$dir" "$dirname"
    fi
done

echo "Done! Links created successfully."
echo "Listing current links in $COMFYUI_MODELS:"
ls -la
