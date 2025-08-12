#!/bin/bash
# Script to fetch ComfyUI backup from LXC container via Proxmox host
# Created for ComfyUI-Easy-Install

# Set colors
green="\033[92m"
yellow="\033[93m"
red="\033[91m"
reset="\033[0m"

# Default values
PROXMOX_IP="192.168.1.202"
PROXMOX_USER="root"
LXC_ID="100"
BACKUP_PATH="/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI/user_backups/user_backup_20250812_025947"
LOCAL_BACKUP_DIR="$HOME/ComfyUI_Backups"
TEMP_DIR="/tmp/comfyui_backup_temp_$$" # Use PID to make unique

# SSH options to reduce password prompts
SSH_OPTS="-o ControlMaster=auto -o ControlPath=/tmp/ssh-%r@%h:%p -o ControlPersist=yes"

# Function to run SSH commands with persistent connection
ssh_cmd() {
    ssh $SSH_OPTS ${PROXMOX_USER}@${PROXMOX_IP} "$1"
}

echo -e "${green}=== ComfyUI LXC Backup Fetcher ===${reset}"
echo

# Ask for server details
read -p "Enter Proxmox server IP [default: $PROXMOX_IP]: " input_ip
PROXMOX_IP=${input_ip:-$PROXMOX_IP}

read -p "Enter Proxmox username [default: $PROXMOX_USER]: " input_user
PROXMOX_USER=${input_user:-$PROXMOX_USER}

read -p "Enter LXC container ID [default: $LXC_ID]: " input_lxc
LXC_ID=${input_lxc:-$LXC_ID}

# Create local backup directory if it doesn't exist
mkdir -p "$LOCAL_BACKUP_DIR"

# Connect to Proxmox and check LXC container status
echo -e "${yellow}Checking LXC container status...${reset}"
LXC_STATUS=$(ssh_cmd "pct status $LXC_ID | awk '{print \$2}'")

if [ "$LXC_STATUS" != "running" ]; then
    echo -e "${yellow}LXC container $LXC_ID is not running. Attempting to start it...${reset}"
    ssh_cmd "pct start $LXC_ID"
    sleep 5
    LXC_STATUS=$(ssh_cmd "pct status $LXC_ID | awk '{print \$2}'")
    if [ "$LXC_STATUS" != "running" ]; then
        echo -e "${red}Failed to start LXC container $LXC_ID. Exiting.${reset}"
        exit 1
    fi
fi

echo -e "${green}LXC container $LXC_ID is running.${reset}"

# List ComfyUI directories in the LXC container
echo -e "${yellow}Listing ComfyUI directories in LXC container...${reset}"
ssh_cmd "pct exec $LXC_ID -- find /root -name ComfyUI -type d 2>/dev/null"
echo

# List backup directories in the LXC container
echo -e "${yellow}Listing backup directories in LXC container...${reset}"
ssh_cmd "pct exec $LXC_ID -- find /root -name user_backups -type d 2>/dev/null"

# List actual backup directories
echo -e "${yellow}Listing actual backup directories in LXC container...${reset}"
ssh_cmd "pct exec $LXC_ID -- find /root -path '*/user_backups/*' -type d 2>/dev/null | grep -i backup"
echo

# Ask for backup path
read -p "Enter backup path in LXC container [default: $BACKUP_PATH]: " input_path
BACKUP_PATH=${input_path:-$BACKUP_PATH}

# Get backup name from path
BACKUP_NAME=$(basename "$BACKUP_PATH")
LOCAL_BACKUP_PATH="$LOCAL_BACKUP_DIR/$BACKUP_NAME"

echo -e "${yellow}Will fetch backup from LXC container $LXC_ID:$BACKUP_PATH${reset}"
echo -e "${yellow}to $LOCAL_BACKUP_PATH${reset}"
echo

# Check if backup exists in LXC container
echo -e "${yellow}Checking if backup exists in LXC container...${reset}"
BACKUP_EXISTS=$(ssh_cmd "pct exec $LXC_ID -- bash -c 'if [ -e \"$BACKUP_PATH\" ]; then echo \"exists\"; else echo \"not_found\"; fi'")

if [ "$BACKUP_EXISTS" = "not_found" ]; then
    echo -e "${red}Error: Backup not found in LXC container.${reset}"
    echo "Available backups:"
    ssh_cmd "pct exec $LXC_ID -- find /root -path '*/user_backups/*' -type d 2>/dev/null | grep -i backup"
    exit 1
fi

# Check if it's a file or directory
BACKUP_TYPE=$(ssh_cmd "pct exec $LXC_ID -- bash -c 'if [ -d \"$BACKUP_PATH\" ]; then echo \"directory\"; elif [ -f \"$BACKUP_PATH\" ]; then echo \"file\"; else echo \"unknown\"; fi'")

echo -e "${green}Found backup ($BACKUP_TYPE) in LXC container.${reset}"

# Create temp directory on Proxmox host
echo -e "${yellow}Creating temporary directory on Proxmox host...${reset}"
ssh_cmd "mkdir -p $TEMP_DIR"

# Handle backup based on type
if [ "$BACKUP_TYPE" = "directory" ]; then
    # For directory backups, we'll use rsync directly from the LXC container
    echo -e "${yellow}Setting up direct rsync from LXC container...${reset}"
    
    # Create a temporary script to run inside the LXC container
    echo -e "${yellow}Creating temporary backup script...${reset}"
    TMP_SCRIPT="/tmp/backup_script_$$.sh"
    
    # Create the script content
    cat > /tmp/backup_script.sh << 'EOF'
#!/bin/bash
BACKUP_PATH="$1"
TAR_PATH="$2"
cd "$(dirname "$BACKUP_PATH")"
tar -czf "$TAR_PATH" "$(basename "$BACKUP_PATH")"
echo "Tar archive created at $TAR_PATH"
EOF
    
    # Copy the script to the Proxmox host
    echo -e "${yellow}Copying backup script to Proxmox...${reset}"
    scp -q /tmp/backup_script.sh ${PROXMOX_USER}@${PROXMOX_IP}:/tmp/
    
    # Copy the script to the LXC container and make it executable
    echo -e "${yellow}Copying backup script to LXC container...${reset}"
    ssh_cmd "pct push $LXC_ID /tmp/backup_script.sh /tmp/backup_script.sh && pct exec $LXC_ID -- chmod +x /tmp/backup_script.sh"
    
    # Execute the script in the LXC container
    echo -e "${yellow}Creating tar archive in LXC container...${reset}"
    ssh_cmd "pct exec $LXC_ID -- /tmp/backup_script.sh \"$BACKUP_PATH\" \"/tmp/$BACKUP_NAME.tar.gz\""
    
    # Pull tar file from LXC container to Proxmox host
    echo -e "${yellow}Pulling tar archive from LXC container to Proxmox host...${reset}"
    ssh_cmd "pct pull $LXC_ID /tmp/$BACKUP_NAME.tar.gz $TEMP_DIR/$BACKUP_NAME.tar.gz"
    
    # Clean up the temporary script
    rm -f /tmp/backup_script.sh
    ssh_cmd "rm -f /tmp/backup_script.sh"
    ssh_cmd "pct exec $LXC_ID -- rm -f /tmp/backup_script.sh"
    
    # Transfer tar file from Proxmox host to local machine
    echo -e "${yellow}Transferring tar archive from Proxmox host to local machine...${reset}"
    rsync -avz -e "ssh $SSH_OPTS" ${PROXMOX_USER}@${PROXMOX_IP}:$TEMP_DIR/$BACKUP_NAME.tar.gz $LOCAL_BACKUP_DIR/
    
    # Extract tar archive on local machine
    echo -e "${yellow}Extracting tar archive on local machine...${reset}"
    mkdir -p "$LOCAL_BACKUP_PATH"
    tar -xzf "$LOCAL_BACKUP_DIR/$BACKUP_NAME.tar.gz" -C "$LOCAL_BACKUP_DIR"
    rm "$LOCAL_BACKUP_DIR/$BACKUP_NAME.tar.gz"
    
    # Clean up temporary files
    echo -e "${yellow}Cleaning up temporary files...${reset}"
    ssh_cmd "rm -rf $TEMP_DIR/$BACKUP_NAME.tar.gz"
    ssh_cmd "pct exec $LXC_ID -- rm -f /tmp/$BACKUP_NAME.tar.gz"
else
    # Pull file from LXC container to Proxmox host
    echo -e "${yellow}Pulling file from LXC container to Proxmox host...${reset}"
    ssh_cmd "pct pull $LXC_ID $BACKUP_PATH $TEMP_DIR/$BACKUP_NAME"
    
    # Transfer file from Proxmox host to local machine
    echo -e "${yellow}Transferring file from Proxmox host to local machine...${reset}"
    rsync -avz -e "ssh $SSH_OPTS" ${PROXMOX_USER}@${PROXMOX_IP}:$TEMP_DIR/$BACKUP_NAME $LOCAL_BACKUP_PATH
    
    # Clean up temporary files
    echo -e "${yellow}Cleaning up temporary files...${reset}"
    ssh_cmd "rm -f $TEMP_DIR/$BACKUP_NAME"
fi

# Clean up temporary directory on Proxmox host
ssh_cmd "rm -rf $TEMP_DIR"

# Close SSH master connection
ssh -O exit ${PROXMOX_USER}@${PROXMOX_IP} 2>/dev/null || true

echo
echo -e "${green}Backup successfully transferred to $LOCAL_BACKUP_PATH${reset}"
echo -e "${green}Backup process completed.${reset}"
