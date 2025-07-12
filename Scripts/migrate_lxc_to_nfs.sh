#!/bin/bash

# Script to migrate an LXC container from local storage to NFS
# Created for ComfyUI-Easy-Install

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_green() {
    echo -e "${GREEN}$1${NC}"
}

print_yellow() {
    echo -e "${YELLOW}$1${NC}"
}

print_red() {
    echo -e "${RED}$1${NC}"
}

print_blue() {
    echo -e "${BLUE}$1${NC}"
}

# Function to check if running as root
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        print_red "This script must be run as root"
        exit 1
    fi
}

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to check if we're running on Proxmox
check_proxmox() {
    if ! command_exists pct || ! command_exists pvesm; then
        print_red "This script must be run on a Proxmox VE host"
        exit 1
    fi
}

# Function to list available containers
list_containers() {
    print_blue "Available LXC containers:"
    pct list | grep -v VMID
}

# Function to list available storages
list_storages() {
    print_blue "Available storages:"
    pvesm status | grep -v Name
}

# Function to check if storage supports containers
check_storage_supports_containers() {
    local storage=$1
    
    # Get the content types without using -v option
    local content=$(pvesm status | grep "^$storage " | awk '{print $3}')
    
    if [[ $content == *"rootdir"* ]] || [[ $content == *"vztmpl"* ]]; then
        return 0
    else
        return 1
    fi
}

# Function to enable container support for storage
enable_container_support() {
    local storage=$1
    print_yellow "Attempting to enable container support for $storage..."
    
    # Directly enable container support with standard content types
    pvesm set "$storage" --content iso,vztmpl,backup,rootdir
    
    # Check if it worked
    if check_storage_supports_containers "$storage"; then
        print_green "Successfully enabled container support for $storage"
        return 0
    else
        print_red "Failed to enable container support for $storage"
        return 1
    fi
}

# Function to get container status
get_container_status() {
    local container_id=$1
    pct status "$container_id" | awk '{print $2}'
}

# Function to check if container exists
container_exists() {
    local container_id=$1
    pct list | grep -q "^$container_id "
}

# Main script starts here
check_root
check_proxmox

print_blue "=== LXC Container Migration Tool ==="
print_blue "This script will migrate an LXC container from local storage to NFS storage"
echo

# List available containers
list_containers
echo

# Get container ID
read -p "Enter the container ID to migrate: " CONTAINER_ID

# Validate container ID
if ! container_exists "$CONTAINER_ID"; then
    print_red "Container $CONTAINER_ID does not exist"
    exit 1
fi

print_green "Selected container: $CONTAINER_ID"

# Get container status
CONTAINER_STATUS=$(get_container_status "$CONTAINER_ID")
print_yellow "Container status: $CONTAINER_STATUS"

# List available storages
echo
list_storages
echo

# Get target storage
read -p "Enter the target NFS storage name: " TARGET_STORAGE

# Validate storage
if ! pvesm status | grep -q "^$TARGET_STORAGE "; then
    print_red "Storage $TARGET_STORAGE does not exist"
    exit 1
fi

# Check if storage supports containers
if ! check_storage_supports_containers "$TARGET_STORAGE"; then
    print_yellow "Storage $TARGET_STORAGE does not currently support containers"
    echo "Options:"
    echo "1. Try to enable container support automatically"
    echo "2. Continue anyway (use this if you've already enabled it in the web UI)"
    echo "3. Cancel migration"
    read -p "Choose an option (1-3): " STORAGE_OPTION
    
    case $STORAGE_OPTION in
        1)
            if ! enable_container_support "$TARGET_STORAGE"; then
                print_red "Unable to automatically enable container support"
                print_yellow "Please enable 'Container' in the content types for this storage in the Proxmox web UI:"
                print_yellow "1. Go to Datacenter → Storage"
                print_yellow "2. Edit '$TARGET_STORAGE'"
                print_yellow "3. Add 'Container' and 'Container template' to Content"
                print_yellow "4. Run this script again and choose option 2"
                exit 1
            fi
            ;;
        2)
            print_yellow "Continuing anyway - assuming container support is enabled"
            ;;
        *)
            print_yellow "Migration cancelled"
            exit 0
            ;;
    esac
fi

print_green "Selected target storage: $TARGET_STORAGE"

# Confirm migration
echo
print_yellow "WARNING: This will stop the container during migration"
read -p "Continue with migration? (y/n): " CONFIRM

if [[ $CONFIRM != "y" && $CONFIRM != "Y" ]]; then
    print_yellow "Migration cancelled"
    exit 0
fi

# Stop container if running
if [ "$CONTAINER_STATUS" == "running" ]; then
    print_yellow "Stopping container $CONTAINER_ID..."
    pct stop "$CONTAINER_ID"
    sleep 5
fi

# Create backup directory if it doesn't exist
BACKUP_DIR="/var/lib/vz/dump"
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

# Create backup
print_yellow "Creating backup of container $CONTAINER_ID..."
vzdump "$CONTAINER_ID" --compress lzo --dumpdir "$BACKUP_DIR"

# Find the latest backup file
BACKUP_FILE=$(ls -t "$BACKUP_DIR"/vzdump-lxc-"$CONTAINER_ID"-*.tar.lzo 2>/dev/null | head -n 1)

if [ -z "$BACKUP_FILE" ]; then
    print_red "Backup failed or not found"
    exit 1
fi

print_green "Backup created: $BACKUP_FILE"

# Get original container config for reference
ORIGINAL_CONFIG=$(pct config "$CONTAINER_ID" 2>/dev/null)
ORIGINAL_HOSTNAME=$(echo "$ORIGINAL_CONFIG" | grep "^hostname:" | awk '{print $2}')
ORIGINAL_MEMORY=$(echo "$ORIGINAL_CONFIG" | grep "^memory:" | awk '{print $2}')
ORIGINAL_CORES=$(echo "$ORIGINAL_CONFIG" | grep "^cores:" | awk '{print $2}')

# Save original container ID for later cleanup
ORIGINAL_CONTAINER_ID=$CONTAINER_ID

# Create a new container ID (original + 1000) to avoid conflicts
NEW_CONTAINER_ID=$((CONTAINER_ID + 1000))

# Check if the new container ID already exists
while container_exists "$NEW_CONTAINER_ID"; do
    NEW_CONTAINER_ID=$((NEW_CONTAINER_ID + 1))
done

# Restore to new storage with temporary container ID
print_yellow "Restoring container to $TARGET_STORAGE as temporary ID $NEW_CONTAINER_ID..."
pct restore "$NEW_CONTAINER_ID" "$BACKUP_FILE" --storage "$TARGET_STORAGE"

if [ $? -ne 0 ]; then
    print_red "Restore failed"
    exit 1
fi

print_green "Container restored to $TARGET_STORAGE with temporary ID $NEW_CONTAINER_ID"

# Start the new container
print_yellow "Starting new container $NEW_CONTAINER_ID..."
pct start "$NEW_CONTAINER_ID"
sleep 10

# Check if the new container started successfully
NEW_CONTAINER_STATUS=$(get_container_status "$NEW_CONTAINER_ID")
if [ "$NEW_CONTAINER_STATUS" != "running" ]; then
    print_red "New container failed to start"
    print_yellow "Keeping both containers for manual verification"
    exit 1
fi

print_green "New container started successfully"

# Ask for verification
echo
print_yellow "IMPORTANT: Please verify that the new container works correctly"
print_yellow "You can access it with: pct enter $NEW_CONTAINER_ID"
echo
read -p "Does the new container work correctly? (y/n): " VERIFY

if [[ $VERIFY != "y" && $VERIFY != "Y" ]]; then
    print_yellow "Migration not verified. Keeping both containers for manual verification"
    print_yellow "Original container: $ORIGINAL_CONTAINER_ID"
    print_yellow "New container: $NEW_CONTAINER_ID"
    exit 0
fi

# Stop both containers
print_yellow "Stopping both containers..."
pct stop "$ORIGINAL_CONTAINER_ID" 2>/dev/null
pct stop "$NEW_CONTAINER_ID" 2>/dev/null
sleep 5

# Destroy the original container
print_yellow "Removing original container $ORIGINAL_CONTAINER_ID..."
pct destroy "$ORIGINAL_CONTAINER_ID"

# Rename the new container to the original ID
print_yellow "Renaming container $NEW_CONTAINER_ID to original ID $ORIGINAL_CONTAINER_ID..."

# This is a bit tricky - we need to modify the config files directly
# First, get the config file path
NEW_CONFIG_PATH="/etc/pve/lxc/$NEW_CONTAINER_ID.conf"
ORIGINAL_CONFIG_PATH="/etc/pve/lxc/$ORIGINAL_CONTAINER_ID.conf"

# Create the new config file
cp "$NEW_CONFIG_PATH" "$ORIGINAL_CONFIG_PATH"

# Update the Proxmox database
qm unlock "$NEW_CONTAINER_ID" 2>/dev/null
pvesm set "$TARGET_STORAGE" --content rootdir,vztmpl

# Remove the temporary container
pct destroy "$NEW_CONTAINER_ID"

# Start the renamed container
print_yellow "Starting container $ORIGINAL_CONTAINER_ID..."
pct start "$ORIGINAL_CONTAINER_ID"
sleep 5

# Final status check
FINAL_STATUS=$(get_container_status "$ORIGINAL_CONTAINER_ID")
if [ "$FINAL_STATUS" == "running" ]; then
    print_green "Migration completed successfully!"
    print_green "Container $ORIGINAL_CONTAINER_ID is now running on $TARGET_STORAGE"
else
    print_red "Final container failed to start"
    print_yellow "Please check the container status manually"
fi

# Optional cleanup
read -p "Remove backup file $BACKUP_FILE? (y/n): " CLEANUP
if [[ $CLEANUP == "y" || $CLEANUP == "Y" ]]; then
    rm -f "$BACKUP_FILE"
    print_green "Backup file removed"
else
    print_yellow "Keeping backup file for safety: $BACKUP_FILE"
fi

print_blue "Migration process completed"
