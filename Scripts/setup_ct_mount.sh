#!/bin/bash

# Configuration
CT_ID="100"  # Replace with your CT ID
NFS_HOST_MOUNT="/mnt/pve/Models"  # The NFS mount point on your Proxmox host
CT_MOUNT_POINT="/mnt/models"  # Where you want it in your CT

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

# Check if CT exists
if ! pct status $CT_ID >/dev/null 2>&1; then
    echo -e "${RED}Container $CT_ID does not exist${NC}"
    exit 1
fi

# Create mount point in CT if it doesn't exist
if ! pct exec $CT_ID -- test -d "$CT_MOUNT_POINT"; then
    echo -e "${YELLOW}Creating mount point in CT: $CT_MOUNT_POINT${NC}"
    pct exec $CT_ID -- mkdir -p "$CT_MOUNT_POINT"
fi

# Add mount point to CT config if not already present
CT_CONFIG="/etc/pve/lxc/$CT_ID.conf"
MOUNT_LINE="mp0: $NFS_HOST_MOUNT,mp=$CT_MOUNT_POINT"

if grep -q "^mp0:" "$CT_CONFIG"; then
    echo -e "${YELLOW}Mount point already configured in $CT_CONFIG${NC}"
else
    echo -e "${GREEN}Adding mount point to CT config${NC}"
    echo "$MOUNT_LINE" >> "$CT_CONFIG"
fi

# Restart CT to apply changes
echo -e "${YELLOW}Restarting container to apply changes...${NC}"
pct reboot $CT_ID

# Wait for CT to come back online
echo -e "${YELLOW}Waiting for container to come back online...${NC}"
sleep 5

# Verify mount
if pct exec $CT_ID -- mountpoint -q "$CT_MOUNT_POINT"; then
    echo -e "${GREEN}Success! NFS share is mounted in CT at $CT_MOUNT_POINT${NC}"
    echo -e "${YELLOW}Testing access...${NC}"
    pct exec $CT_ID -- ls -la "$CT_MOUNT_POINT"
else
    echo -e "${RED}Mount failed. Please check your configuration${NC}"
    exit 1
fi
