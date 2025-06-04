#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if running as root
#if [ "$EUID" -ne 0 ]; then
#    echo -e "${RED}Please run as root${NC}"
#    exit 1
#fi

MOUNT_POINT="/mnt/models_usb"

# Check if mounted
if ! mountpoint -q "$MOUNT_POINT"; then
    echo -e "${RED}$MOUNT_POINT is not mounted${NC}"
    exit 1
fi

# Show current mount info
echo -e "${YELLOW}Current mount details:${NC}"
mount | grep "$MOUNT_POINT"
df -h "$MOUNT_POINT"

# Check for processes using the mount
echo -e "\n${YELLOW}Checking for processes using $MOUNT_POINT...${NC}"
PROCS=$(lsof "$MOUNT_POINT" 2>/dev/null)

if [ ! -z "$PROCS" ]; then
    echo -e "${RED}Warning: The following processes are using $MOUNT_POINT:${NC}"
    echo "$PROCS"
    read -p "Do you want to force unmount? This may cause data loss! (yes/no): " FORCE
    if [ "$FORCE" = "yes" ]; then
        echo -e "${YELLOW}Force unmounting...${NC}"
        umount -f "$MOUNT_POINT"
    else
        echo -e "${YELLOW}Operation cancelled. Please stop the processes first.${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}No processes are using the mount point.${NC}"
    echo -e "${YELLOW}Unmounting...${NC}"
    umount "$MOUNT_POINT"
fi

# Check if unmount was successful
if ! mountpoint -q "$MOUNT_POINT"; then
    echo -e "${GREEN}Successfully unmounted $MOUNT_POINT${NC}"
    
    # Check if entry exists in fstab
    if grep -q "$MOUNT_POINT" /etc/fstab; then
        echo -e "${YELLOW}Found entry in /etc/fstab. You might want to remove it:${NC}"
        grep "$MOUNT_POINT" /etc/fstab
    fi
else
    echo -e "${RED}Failed to unmount $MOUNT_POINT${NC}"
    exit 1
fi
