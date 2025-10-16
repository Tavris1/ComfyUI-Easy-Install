#!/bin/bash
# Easy-Models-Linker by ivo v1.65.0 - Linux version
# Pixaroma Community Edition

# Set colors
warning="\033[33m"
red="\033[91m"
green="\033[92m"
yellow="\033[93m"
bold="\033[1m"
reset="\033[0m"

# Function to find ComfyUI installation
find_comfyui_installation() {
    local search_paths=(
        # Current directory and subdirectories
        "$SCRIPT_DIR/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI"  # Nested (Proxmox/container)
        "$SCRIPT_DIR/ComfyUI-Easy-Install/ComfyUI"                      # Standard installation
        "$SCRIPT_DIR/ComfyUI"                                          # Direct ComfyUI
        
        # Common system paths
        "/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI"       # Your Proxmox path
        "/root/ComfyUI"                                                # Root ComfyUI
        "/home/*/ComfyUI"                                              # User home ComfyUI
        "/opt/ComfyUI"                                                 # System ComfyUI
        "/usr/local/ComfyUI"                                           # Local ComfyUI
        "/var/lib/ComfyUI"                                             # Service ComfyUI
        
        # Docker/container paths
        "/app/ComfyUI"                                                 # Docker app
        "/workspace/ComfyUI"                                           # Workspace
        "/data/ComfyUI"                                                # Data volume
        
        # Custom installation paths
        "/mnt/*/ComfyUI"                                               # Mounted drives
        "/srv/ComfyUI"                                                 # Service directory
    )
    
    echo -e "${yellow}Searching for ComfyUI installation...${reset}"
    
    # Check predefined paths
    for path in "${search_paths[@]}"; do
        # Handle wildcard paths
        if [[ "$path" == *"*"* ]]; then
            for expanded_path in $path; do
                if [ -d "$expanded_path/models" ]; then
                    echo -e "${green}Found ComfyUI at: ${yellow}$expanded_path${reset}"
                    echo "$expanded_path"
                    return 0
                fi
            done
        else
            if [ -d "$path/models" ]; then
                echo -e "${green}Found ComfyUI at: ${yellow}$path${reset}"
                echo "$path"
                return 0
            fi
        fi
    done
    
    return 1
}

# Function to manually specify ComfyUI path
manual_comfyui_path() {
    echo -e "${yellow}ComfyUI installation not found in standard locations.${reset}"
    echo -e "${green}Please enter the full path to your ComfyUI installation:${reset}"
    echo -e "${yellow}(The directory that contains the 'models' folder)${reset}"
    echo -e "${yellow}Example: /root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI${reset}"
    echo ""
    
    read -p "ComfyUI path: " manual_path
    manual_path="${manual_path%/}"  # Remove trailing slash
    
    if [ -z "$manual_path" ]; then
        echo "Cancelled."
        return 1
    fi
    
    if [ ! -d "$manual_path" ]; then
        echo -e "${red}Error: Directory does not exist: $manual_path${reset}"
        return 1
    fi
    
    if [ ! -d "$manual_path/models" ]; then
        echo -e "${red}Error: No 'models' directory found in: $manual_path${reset}"
        echo -e "${yellow}Please ensure you're pointing to the ComfyUI root directory.${reset}"
        return 1
    fi
    
    echo -e "${green}ComfyUI installation confirmed at: ${yellow}$manual_path${reset}"
    echo "$manual_path"
    return 0
}

start_script() {
    # Get the directory where this script is located
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    cd "$SCRIPT_DIR" || exit

    # Try to find ComfyUI installation automatically
    main_folder=$(find_comfyui_installation)
    
    # If not found, ask user to specify manually
    if [ $? -ne 0 ] || [ -z "$main_folder" ]; then
        main_folder=$(manual_comfyui_path)
        if [ $? -ne 0 ] || [ -z "$main_folder" ]; then
            echo -e "${red}Cannot proceed without a valid ComfyUI installation path.${reset}"
            exit 1
        fi
    fi
    
    yaml="$main_folder/extra_model_paths.yaml"

    echo -e "${yellow}Easy-Models-Linker${green} will create an ${yellow}extra_model_paths.yaml${green} in ${yellow}$main_folder${green} folder.${reset}"
    echo -e "${green}This way, you can reuse your existing ComfyUI model folders without downloading them again.${reset}"
    echo ""
    echo -e "${green}Enter the full path to your ${yellow}EXISTING MODELS${green} folder:"
    echo -e "${yellow}(Example: /mnt/models or /home/user/ComfyUI/models)${reset}"
    echo ""

    # Read user input for models path
    read -p "Models path: " models

    # Remove trailing slash if present
    models="${models%/}"

    # Check if user cancelled (empty input)
    if [ -z "$models" ]; then
        echo "Cancelled."
        exit 0
    fi

    # Check if the path exists
    if [ ! -d "$models" ]; then
        echo -e "\n${warning}WARNING:${reset} ${green}Path ${red}$models${green} does not exist.${reset}"
        echo -e "\n${yellow}Press any key to try again...${reset}"
        read -n 1
        clear
        start_script
        return
    fi

    echo -e "${green}Selected: ${yellow}$models${reset}"

    # Check if it's a valid models folder (should contain checkpoints)
    if [ ! -d "$models/checkpoints" ]; then
        echo -e "\n${warning}WARNING:${reset} ${green}This is ${red}NOT a MODELS${green} folder.${reset}"
        echo -e "${green}A valid models folder should contain a 'checkpoints' subdirectory.${reset}"
        echo -e "\n${yellow}Press any key to Select again...${reset}"
        read -n 1
        clear
        start_script
        return
    fi

    # Check if user selected the same folder as the new ComfyUI models
    if [ "$models" = "$main_folder/models" ]; then
        echo -e "\n${warning}WARNING:${reset} ${green}This is ${red}YOUR NEW MODELS${green} folder.${reset}"
        echo -e "${green}Select the location of your ${yellow}EXISTING MODELS${green} folder.${reset}"
        echo -e "\n${yellow}Press any key to Select again...${reset}"
        read -n 1
        clear
        start_script
        return
    fi
    
    echo -e "${green}Selected: ${yellow}$models${reset}"
    echo -e "${green}ComfyUI installation: ${yellow}$main_folder${reset}"

    # Change to models directory to get its name
    cd "$models" || exit
    modelsname="$(basename "$models")"

    # Create the YAML file
    cat > "$yaml" << EOF
# Powered by Easy-Models-Linker and Ivo
# Pixaroma Community Edition

comfyui:
    base_path: $(dirname "$models")/
    is_default: true

EOF

    # Add each subdirectory to the YAML
    for dir in */; do
        if [ -d "$dir" ]; then
            # Remove trailing slash from directory name
            dirname="${dir%/}"
            echo "    $dirname: $modelsname/$dirname/" >> "$yaml"
        fi
    done

    echo ""
    echo "Generated extra_model_paths.yaml:"
    echo "=================================="
    cat "$yaml"
    echo "=================================="
    echo ""
    echo -e "${green}::::: ${yellow}extra_model_paths.yaml${green} was created in the ${yellow}$main_folder${green} folder :::::${reset}"
    echo ""
    echo -e "${green}::::: ${yellow}Press any key to exit${reset}"
    read -n 1
}

# Start the script
clear
start_script
