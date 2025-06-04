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

# List available drives
echo -e "${YELLOW}Available drives:${NC}"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,MODEL,SERIAL
echo

# Ask for drive selection
read -p "Enter the drive name (e.g., sdb, sdc): " DRIVE

# Validate drive exists
if [ ! -b "/dev/$DRIVE" ]; then
    echo -e "${RED}Error: /dev/$DRIVE does not exist${NC}"
    exit 1
fi

# Safety check
echo -e "${RED}WARNING: This will erase ALL data on /dev/$DRIVE${NC}"
echo -e "${YELLOW}Drive details:${NC}"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,MODEL,SERIAL "/dev/$DRIVE"
echo
read -p "Are you absolutely sure you want to format this drive? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo -e "${YELLOW}Operation cancelled${NC}"
    exit 1
fi

# Unmount any existing partitions
echo -e "${YELLOW}Unmounting any existing partitions...${NC}"
for part in $(lsblk -nro NAME "/dev/$DRIVE" | tail -n +2); do
    umount "/dev/$part" 2>/dev/null
done

# Create new partition table and partition
echo -e "${YELLOW}Creating new GPT partition table...${NC}"
parted -s "/dev/$DRIVE" mklabel gpt

echo -e "${YELLOW}Creating new partition...${NC}"
parted -s "/dev/$DRIVE" mkpart primary ext4 0% 100%

# Wait for partition to be available
sleep 2

# Get the new partition name
PARTITION="${DRIVE}1"
if [ -b "/dev/${DRIVE}p1" ]; then
    PARTITION="${DRIVE}p1"
fi

# Format partition
echo -e "${YELLOW}Formatting partition as ext4...${NC}"
mkfs.ext4 -L "MODELS" "/dev/$PARTITION"

# Create mount point
MOUNT_POINT="/mnt/models_usb"
echo -e "${YELLOW}Creating mount point at $MOUNT_POINT${NC}"
mkdir -p "$MOUNT_POINT"

# Get partition UUID
UUID=$(blkid -s UUID -o value "/dev/$PARTITION")

# Add to fstab if not already present
if ! grep -q "$UUID" /etc/fstab; then
    echo -e "${YELLOW}Adding to /etc/fstab for automatic mounting...${NC}"
    echo "UUID=$UUID $MOUNT_POINT ext4 defaults 0 2" >> /etc/fstab
fi

# Mount the drive
echo -e "${YELLOW}Mounting the drive...${NC}"
mount "$MOUNT_POINT"

# Set permissions
echo -e "${YELLOW}Setting permissions...${NC}"
chown -R 1000:1000 "$MOUNT_POINT"
chmod -R 755 "$MOUNT_POINT"

# Final status
if mountpoint -q "$MOUNT_POINT"; then
    echo -e "${GREEN}Success! Drive is mounted at $MOUNT_POINT${NC}"
    echo -e "${GREEN}Drive details:${NC}"
    df -h "$MOUNT_POINT"
    echo -e "${YELLOW}The drive will automatically mount on boot${NC}"
else
    echo -e "${RED}Mount failed. Please check the system logs${NC}"
    exit 1
fi
