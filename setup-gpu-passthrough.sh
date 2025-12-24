#!/usr/bin/env bash

# ComfyUI GPU Passthrough Setup Script
# Run this on Proxmox HOST to automatically configure GPU for a container

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}  ${GREEN}ComfyUI GPU Passthrough Setup for Proxmox${NC}      ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Error: Please run as root${NC}"
  exit 1
fi

# Get container ID
if [ -z "$1" ]; then
  echo -e "${YELLOW}Usage: $0 <container_id>${NC}"
  echo -e "${YELLOW}Example: $0 108${NC}"
  exit 1
fi

CTID=$1
CONF_FILE="/etc/pve/lxc/${CTID}.conf"

# Check if container exists
if [ ! -f "$CONF_FILE" ]; then
  echo -e "${RED}Error: Container $CTID does not exist${NC}"
  exit 1
fi

# Check if container is privileged
if ! grep -q "^unprivileged: 0" "$CONF_FILE" 2>/dev/null; then
  if grep -q "^unprivileged: 1" "$CONF_FILE"; then
    echo -e "${RED}Error: Container $CTID is unprivileged. GPU passthrough requires a privileged container.${NC}"
    exit 1
  fi
fi

echo -e "${GREEN}✓ Container $CTID found and is privileged${NC}"
echo ""

# Check for NVIDIA driver on host
if ! command -v nvidia-smi &> /dev/null; then
  echo -e "${RED}Error: NVIDIA driver not found on Proxmox host${NC}"
  echo -e "${YELLOW}Install NVIDIA drivers first:${NC}"
  echo "  apt update"
  echo "  apt install nvidia-driver"
  exit 1
fi

echo -e "${GREEN}✓ NVIDIA driver detected on host${NC}"
nvidia-smi --query-gpu=name --format=csv,noheader | while read -r gpu; do
  echo -e "  ${BLUE}→${NC} $gpu"
done
echo ""

# Detect NVIDIA devices
echo -e "${BLUE}Detecting NVIDIA devices...${NC}"
NVIDIA_DEVICES=$(ls -1 /dev/nvidia* 2>/dev/null | grep -v "nvidia-caps")
NVIDIA_CAPS=$(ls -1 /dev/nvidia-caps/nvidia-cap* 2>/dev/null || echo "")

if [ -z "$NVIDIA_DEVICES" ]; then
  echo -e "${RED}Error: No NVIDIA devices found in /dev/${NC}"
  exit 1
fi

echo -e "${GREEN}✓ Found NVIDIA devices:${NC}"
echo "$NVIDIA_DEVICES" | while read -r dev; do
  echo -e "  ${BLUE}→${NC} $dev"
done

if [ -n "$NVIDIA_CAPS" ]; then
  echo "$NVIDIA_CAPS" | while read -r dev; do
    echo -e "  ${BLUE}→${NC} $dev"
  done
fi
echo ""

# Get unique device major numbers
echo -e "${BLUE}Detecting device major numbers...${NC}"
MAJOR_NUMBERS=$(stat -c '%t' /dev/nvidia* /dev/nvidia-caps/* 2>/dev/null | sort -u | sed 's/^0*//')
echo -e "${GREEN}✓ Device major numbers: $(echo $MAJOR_NUMBERS | tr '\n' ' ')${NC}"
echo ""

# Backup original config
cp "$CONF_FILE" "${CONF_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
echo -e "${GREEN}✓ Backed up container config${NC}"
echo ""

# Remove old GPU entries if they exist
sed -i '/lxc.cgroup2.devices.allow.*nvidia/d' "$CONF_FILE"
sed -i '/lxc.mount.entry.*nvidia/d' "$CONF_FILE"

# Add GPU configuration
echo -e "${BLUE}Adding GPU configuration to container...${NC}"

# Add device permissions for all detected major numbers
for major in $MAJOR_NUMBERS; do
  # Convert hex to decimal
  major_dec=$((16#$major))
  echo "lxc.cgroup2.devices.allow: c ${major_dec}:* rwm" >> "$CONF_FILE"
  echo -e "  ${GREEN}✓${NC} Added device permission: c ${major_dec}:* rwm"
done
echo ""

# Mount NVIDIA devices
for device in $NVIDIA_DEVICES; do
  device_name=$(basename "$device")
  echo "lxc.mount.entry: $device dev/$device_name none bind,optional,create=file" >> "$CONF_FILE"
  echo -e "  ${GREEN}✓${NC} Added mount: $device"
done

# Mount NVIDIA caps devices
if [ -n "$NVIDIA_CAPS" ]; then
  echo "$NVIDIA_CAPS" | while read -r device; do
    # Create full path in container (preserve nvidia-caps directory structure)
    device_path="${device#/dev/}"
    echo "lxc.mount.entry: $device dev/$device_path none bind,optional,create=file" >> "$CONF_FILE"
    echo -e "  ${GREEN}✓${NC} Added mount: $device"
  done
fi

echo ""
echo -e "${GREEN}✓ GPU passthrough configured successfully${NC}"
echo ""

# Ask to restart container
echo -e "${YELLOW}Container needs to be restarted for changes to take effect.${NC}"
read -p "Restart container $CTID now? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${BLUE}Restarting container $CTID...${NC}"
  pct reboot $CTID
  
  # Wait for container to come back up
  echo -e "${BLUE}Waiting for container to restart...${NC}"
  sleep 5
  
  # Verify GPU access
  echo -e "${BLUE}Verifying GPU access in container...${NC}"
  if pct exec $CTID -- bash -c "ls /dev/nvidia* >/dev/null 2>&1"; then
    echo -e "${GREEN}✓ GPU devices are accessible in container${NC}"
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}  ${BLUE}Setup Complete!${NC}                                 ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "Test GPU access:"
    echo -e "  ${BLUE}pct enter $CTID${NC}"
    echo -e "  ${BLUE}nvidia-smi${NC}"
    echo ""
    echo -e "Start ComfyUI:"
    echo -e "  ${BLUE}systemctl start comfyui${NC}"
  else
    echo -e "${YELLOW}⚠ Could not verify GPU access. Check manually:${NC}"
    echo -e "  ${BLUE}pct enter $CTID${NC}"
    echo -e "  ${BLUE}ls -l /dev/nvidia*${NC}"
  fi
else
  echo -e "${YELLOW}Restart skipped. Run manually:${NC}"
  echo -e "  ${BLUE}pct reboot $CTID${NC}"
fi

echo ""
echo -e "${BLUE}Configuration saved to: ${CONF_FILE}${NC}"
echo -e "${BLUE}Backup saved to: ${CONF_FILE}.backup.*${NC}"