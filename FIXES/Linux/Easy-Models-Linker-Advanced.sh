#!/bin/bash
# Easy-Models-Linker Advanced by ivo v1.65.0 - Linux/Proxmox version
# Pixaroma Community Edition
# Enhanced version with network mount support and validation

# Set colors
warning="\033[33m"
red="\033[91m"
green="\033[92m"
yellow="\033[93m"
blue="\033[94m"
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

# Function to display menu
show_menu() {
    echo -e "${bold}${blue}Easy-Models-Linker Advanced${reset}"
    echo -e "${green}================================${reset}"
    echo -e "${yellow}1.${reset} Link local models folder"
    echo -e "${yellow}2.${reset} Link network/NFS mounted models folder"
    echo -e "${yellow}3.${reset} Show current model paths configuration"
    echo -e "${yellow}4.${reset} Remove existing configuration"
    echo -e "${yellow}5.${reset} Change ComfyUI installation path"
    echo -e "${yellow}6.${reset} Exit"
    echo ""
    read -p "Select option (1-6): " choice
}

# Function to validate models folder
validate_models_folder() {
    local models_path="$1"
    
    if [ ! -d "$models_path" ]; then
        echo -e "${red}Error: Path does not exist: $models_path${reset}"
        return 1
    fi
    
    # Check for common ComfyUI model subdirectories
    local found_dirs=0
    local expected_dirs=("checkpoints" "loras" "vae" "controlnet" "embeddings" "upscale_models")
    
    for dir in "${expected_dirs[@]}"; do
        if [ -d "$models_path/$dir" ]; then
            ((found_dirs++))
        fi
    done
    
    if [ $found_dirs -eq 0 ]; then
        echo -e "${warning}Warning: No standard ComfyUI model directories found.${reset}"
        echo -e "${yellow}Expected directories: ${expected_dirs[*]}${reset}"
        echo -e "${yellow}Continue anyway? (y/n):${reset}"
        read -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 1
        fi
    else
        echo -e "${green}Found $found_dirs standard model directories.${reset}"
    fi
    
    return 0
}

# Function to create YAML configuration
create_yaml_config() {
    local models_path="$1"
    local yaml_file="$2"
    
    # Get the parent directory and folder name
    local parent_dir="$(dirname "$models_path")"
    local models_name="$(basename "$models_path")"
    
    # Create the YAML file
    cat > "$yaml_file" << EOF
# Powered by Easy-Models-Linker Advanced and Ivo
# Pixaroma Community Edition
# Generated on: $(date)
# Models source: $models_path

comfyui:
    base_path: $parent_dir/
    is_default: true

EOF

    # Add each subdirectory to the YAML
    local added_dirs=0
    cd "$models_path" || return 1
    
    for dir in */; do
        if [ -d "$dir" ]; then
            # Remove trailing slash from directory name
            dirname="${dir%/}"
            echo "    $dirname: $models_name/$dirname/" >> "$yaml_file"
            ((added_dirs++))
        fi
    done
    
    echo -e "${green}Added $added_dirs model directories to configuration.${reset}"
    return 0
}

# Function to link local models
link_local_models() {
    echo -e "${green}Enter the full path to your ${yellow}EXISTING MODELS${green} folder:${reset}"
    echo -e "${yellow}(Example: /home/user/models or /mnt/storage/comfyui-models)${reset}"
    echo ""
    
    read -p "Models path: " models
    models="${models%/}"  # Remove trailing slash
    
    if [ -z "$models" ]; then
        echo "Cancelled."
        return 1
    fi
    
    if ! validate_models_folder "$models"; then
        return 1
    fi
    
    # Check if it's the same as current ComfyUI models
    if [ "$models" = "$main_folder/ComfyUI/models" ]; then
        echo -e "${red}Error: Cannot link to the same folder as current ComfyUI models.${reset}"
        return 1
    fi
    
    echo -e "${green}Selected: ${yellow}$models${reset}"
    create_yaml_config "$models" "$yaml_file"
}

# Function to link network models
link_network_models() {
    echo -e "${green}Network Models Linking${reset}"
    echo -e "${yellow}This option is for models stored on network shares (NFS, CIFS, etc.)${reset}"
    echo ""
    
    echo -e "${yellow}1.${reset} Use already mounted network path"
    echo -e "${yellow}2.${reset} Mount NFS share (requires root)"
    echo -e "${yellow}3.${reset} Back to main menu"
    echo ""
    
    read -p "Select option (1-3): " net_choice
    
    case $net_choice in
        1)
            echo -e "${green}Enter the path to your mounted network models folder:${reset}"
            echo -e "${yellow}(Example: /mnt/nfs/models or /media/shared/comfyui-models)${reset}"
            read -p "Network models path: " models
            models="${models%/}"
            
            if [ -z "$models" ]; then
                echo "Cancelled."
                return 1
            fi
            
            if ! validate_models_folder "$models"; then
                return 1
            fi
            
            create_yaml_config "$models" "$yaml_file"
            ;;
        2)
            if [ "$(id -u)" -ne 0 ]; then
                echo -e "${red}Error: Root privileges required for mounting NFS shares.${reset}"
                echo -e "${yellow}Please run as root or use option 1 with pre-mounted shares.${reset}"
                return 1
            fi
            
            echo -e "${green}Enter NFS server details:${reset}"
            read -p "NFS Server IP: " nfs_server
            read -p "NFS Share path: " nfs_path
            read -p "Local mount point (e.g., /mnt/nfs-models): " mount_point
            
            # Create mount point if it doesn't exist
            mkdir -p "$mount_point"
            
            # Mount the NFS share
            if mount -t nfs "$nfs_server:$nfs_path" "$mount_point"; then
                echo -e "${green}Successfully mounted NFS share.${reset}"
                if validate_models_folder "$mount_point"; then
                    create_yaml_config "$mount_point" "$yaml_file"
                fi
            else
                echo -e "${red}Failed to mount NFS share.${reset}"
                return 1
            fi
            ;;
        3)
            return 0
            ;;
        *)
            echo -e "${red}Invalid option.${reset}"
            return 1
            ;;
    esac
}

# Function to show current configuration
show_current_config() {
    if [ -f "$yaml_file" ]; then
        echo -e "${green}Current extra_model_paths.yaml configuration:${reset}"
        echo "=============================================="
        cat "$yaml_file"
        echo "=============================================="
    else
        echo -e "${yellow}No configuration file found.${reset}"
    fi
}

# Function to remove configuration
remove_config() {
    if [ -f "$yaml_file" ]; then
        echo -e "${yellow}Are you sure you want to remove the current configuration? (y/n):${reset}"
        read -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$yaml_file"
            echo -e "${green}Configuration removed.${reset}"
        fi
    else
        echo -e "${yellow}No configuration file to remove.${reset}"
    fi
}

# Main script execution
main() {
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
    
    yaml_file="$main_folder/extra_model_paths.yaml"

    while true; do
        clear
        echo -e "${yellow}Easy-Models-Linker Advanced${green} - Universal Linux Edition${reset}"
        echo -e "${green}This tool creates an ${yellow}extra_model_paths.yaml${green} configuration file.${reset}"
        echo -e "${green}ComfyUI installation: ${yellow}$main_folder${reset}"
        echo ""
        
        show_menu
        
        case $choice in
            1)
                clear
                link_local_models
                if [ $? -eq 0 ]; then
                    show_current_config
                fi
                echo -e "\n${yellow}Press any key to continue...${reset}"
                read -n 1
                ;;
            2)
                clear
                link_network_models
                if [ $? -eq 0 ]; then
                    show_current_config
                fi
                echo -e "\n${yellow}Press any key to continue...${reset}"
                read -n 1
                ;;
            3)
                clear
                show_current_config
                echo -e "\n${yellow}Press any key to continue...${reset}"
                read -n 1
                ;;
            4)
                clear
                remove_config
                echo -e "\n${yellow}Press any key to continue...${reset}"
                read -n 1
                ;;
            5)
                clear
                echo -e "${yellow}Current ComfyUI path: ${green}$main_folder${reset}"
                main_folder=$(manual_comfyui_path)
                if [ $? -eq 0 ] && [ -n "$main_folder" ]; then
                    yaml_file="$main_folder/extra_model_paths.yaml"
                    echo -e "${green}ComfyUI path updated successfully!${reset}"
                else
                    echo -e "${yellow}ComfyUI path unchanged.${reset}"
                fi
                echo -e "\n${yellow}Press any key to continue...${reset}"
                read -n 1
                ;;
            6)
                echo -e "${green}Goodbye!${reset}"
                exit 0
                ;;
            *)
                echo -e "${red}Invalid option. Please select 1-6.${reset}"
                sleep 2
                ;;
        esac
    done
}

# Start the script
main
