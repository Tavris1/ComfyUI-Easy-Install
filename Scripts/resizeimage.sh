#!/bin/bash
# Script to prepare images for colorization in ComfyUI

# Set colors for better readability
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
RESET="\033[0m"

# Check if an input file was provided
if [ $# -lt 1 ]; then
    echo -e "${RED}Error: Please provide the path to a black and white image${RESET}"
    echo -e "Usage: $0 /path/to/bw_image.jpg [output_path] [max_size] [exact_size]"
echo -e "  [exact_size] (optional): Resize to WxH, e.g. 512x512. Overrides max_size if provided."
    exit 1
fi

INPUT_IMAGE="$1"
OUTPUT_DIR="${2:-./prepared_images}"
# Parse size arguments
if [[ "$3" =~ ^[0-9]+x[0-9]+$ ]]; then
    EXACT_SIZE="$3"
    MAX_SIZE="1024"  # Default, will be ignored if EXACT_SIZE is set
elif [[ -n "$3" ]]; then
    MAX_SIZE="$3"
    EXACT_SIZE="$4"
else
    MAX_SIZE="1024"
    EXACT_SIZE=""
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Get the base name of the input file
FILENAME=$(basename "$INPUT_IMAGE")
BASE_NAME="${FILENAME%.*}"
OUTPUT_IMAGE="$OUTPUT_DIR/${BASE_NAME}_prepared.png"

echo -e "${BLUE}=== Preparing Image for ComfyUI Colorization ===${RESET}"
echo -e "${GREEN}Input image: $INPUT_IMAGE${RESET}"
echo -e "${GREEN}Output will be saved to: $OUTPUT_IMAGE${RESET}"
if [ -n "$EXACT_SIZE" ]; then
    echo -e "${GREEN}Exact size: ${EXACT_SIZE}${RESET}"
else
    echo -e "${GREEN}Maximum dimension: ${MAX_SIZE}px${RESET}"
fi

# Use Python to prepare the image
python3 - << PYTHON_SCRIPT
from PIL import Image
import sys
import os
import re

# Input and output paths
input_path = "$INPUT_IMAGE"
output_path = "$OUTPUT_IMAGE"
max_size = int("$MAX_SIZE")
exact_size = "$EXACT_SIZE".strip() if "$EXACT_SIZE" else None

try:
    # Load the image
    print("Loading image...")
    img = Image.open(input_path)
    orig_width, orig_height = img.size
    print(f"Original image size: {orig_width}x{orig_height}")

    # If exact_size is provided, parse and use it
    if exact_size:
        m = re.match(r"^(\\d+)x(\\d+)$", exact_size)
        if not m:
            raise ValueError(f"Invalid exact_size format: {exact_size}. Use WxH, e.g. 512x512.")
        new_width, new_height = int(m.group(1)), int(m.group(2))
        print(f"Resizing to exact size: {new_width}x{new_height}")
        img = img.resize((new_width, new_height), Image.LANCZOS)
    else:
        # Resize if larger than max_size
        if orig_width > max_size or orig_height > max_size:
            # Calculate new dimensions while maintaining aspect ratio
            if orig_width > orig_height:
                new_width = max_size
                new_height = int(orig_height * (max_size / orig_width))
            else:
                new_height = max_size
                new_width = int(orig_width * (max_size / orig_height))
            print(f"Resizing to {new_width}x{new_height} for processing...")
            img = img.resize((new_width, new_height), Image.LANCZOS)

    # Convert to RGB if not already
    if img.mode != 'RGB':
        img = img.convert('RGB')

    # Save the prepared image
    img.save(output_path, format="PNG")
    print(f"Prepared image saved to {output_path}")

except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
PYTHON_SCRIPT

if [ $? -eq 0 ]; then
    echo -e "${BLUE}=== Image Preparation Complete ===${RESET}"
    echo -e "${GREEN}Prepared image saved to: $OUTPUT_IMAGE${RESET}"
    echo -e "${YELLOW}Instructions:${RESET}"
    echo -e "1. Start ComfyUI with: ${YELLOW}./run_comfyui_colorize.sh${RESET}"
    echo -e "2. Open your colorization workflow"
    echo -e "3. Load the prepared image in the LoadImage node"
    echo -e "4. Run the workflow to colorize your image"
else
    echo -e "${RED}Image preparation failed.${RESET}"
fi
