#!/bin/bash

# Extra Model Paths Maker for macOS by ivo v0.26.0 (macOS adaptation)

# Set colors
warning="\033[33m"
green="\033[92m"
reset="\033[0m"

yaml="extra_model_paths.yaml"

# Get the directory where the script is located
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

# Check if checkpoints directory exists
if [ ! -d "checkpoints" ]; then
    echo
    echo -e "${warning}WARNING:${reset} ${green}Place this file in shared 'models' folder and rerun it.${reset}"
    echo
    echo "Press any key to Exit..."
    read -n 1
    exit 1
fi

modelsfolder="$script_dir"
modelsname=$(basename "$modelsfolder")

# Create YAML file
echo "comfyui:" > "$yaml"
cd ..
echo "    base_path: $(pwd)/" >> "$modelsfolder/$yaml"
cd "$modelsfolder"
echo "    is_default: true" >> "$yaml"
echo "" >> "$yaml"

# Add all subdirectories to the YAML file
for dir in */; do
    if [ -d "$dir" ]; then
        dirname="${dir%/}"
        echo "    $dirname: $modelsname/$dirname/" >> "$yaml"
    fi
done

# Try to open the file with an available text editor
if command -v nano &> /dev/null; then
    nano "$yaml"  # Most Linux systems have nano
elif command -v vim &> /dev/null; then
    vim "$yaml"
elif command -v open &> /dev/null; then
    open -t "$yaml"  # macOS default text editor
else
    echo -e "${green}YAML file created: $yaml${reset}"
    echo -e "${green}You can open it with your preferred text editor.${reset}"
    echo -e "${green}Content of $yaml:${reset}"
    cat "$yaml"
fi

echo -e "${green}Successfully created $yaml file!${reset}"
