#!/usr/bin/env bash

# ComfyUI Proxmox LXC Installer - Standalone Version
# Copyright (c) 2025 VenimK
# License: MIT

#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2025 VenimK
# Author: VenimK
# License: MIT
# https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE


# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

function header_info {
clear
cat <<"EOF"
    ____  _ _  __     ____        __  ___     
   / __ \(_) |/ /__ _/ __ \____  /  |/  /___ _
  / /_/ / /|   / __ `/ /_/ / __ \/ /|_/ / __ `/
 / ____/ //   / /_/ / _, _/ /_/ / /  / / /_/ / 
/_/   /_//_/|_\__,_/_/ |_|\____/_/  /_/\__,_/  
                                                
        ComfyUI v1.73.0
EOF
echo ""
}

header_info

# Configuration
CTID=""
HOSTNAME="PiXaRoma"
DISK_SIZE="100"
CORES="4"
MEMORY="16384"
BRIDGE="vmbr0"
OSTYPE="debian"
OSVERSION="12"


# Get next available CTID
NEXTID=$(pvesh get /cluster/nextid)

# Detect available storage for containers
echo -e "${BLUE}Detecting available storage...${NC}"

# Prefer storages that explicitly support rootdir (containers)
mapfile -t STORAGE_OPTIONS < <(pvesm status -content rootdir 2>/dev/null | awk 'NR>1 {print $1}')

# Fallback: any storage entry if none reported with rootdir
if [ ${#STORAGE_OPTIONS[@]} -eq 0 ]; then
    mapfile -t STORAGE_OPTIONS < <(pvesm status 2>/dev/null | awk 'NR>1 {print $1}')
fi

if [ ${#STORAGE_OPTIONS[@]} -eq 0 ]; then
    echo -e "${RED}Error: No storage found on this Proxmox host${NC}"
    echo -e "${YELLOW}pvesm status output:${NC}"
    pvesm status || true
    exit 1
fi

echo -e "${CYAN}Available storage options:${NC}"
idx=1
for store in "${STORAGE_OPTIONS[@]}"; do
    echo -e "  ${idx}) ${store}"
    idx=$((idx+1))
done

echo ""
read -p "Select storage [1-${#STORAGE_OPTIONS[@]}] (default 1): " STORAGE_CHOICE

if [ -z "${STORAGE_CHOICE}" ]; then
    STORAGE_CHOICE=1
fi

if ! [[ "${STORAGE_CHOICE}" =~ ^[0-9]+$ ]] || [ "${STORAGE_CHOICE}" -lt 1 ] || [ "${STORAGE_CHOICE}" -gt ${#STORAGE_OPTIONS[@]} ]; then
    echo -e "${RED}Invalid selection. Aborting.${NC}"
    exit 1
fi

STORAGE=${STORAGE_OPTIONS[$((STORAGE_CHOICE-1))]}

echo -e "${GREEN}✓ Using storage: ${STORAGE}${NC}"

echo -e "${CYAN}ComfyUI LXC Container Setup${NC}"
echo ""
echo -e "${YELLOW}This will create a privileged Debian 12 LXC container for ComfyUI${NC}"
echo ""
echo -e "${GREEN}Default settings:${NC}"
echo -e "  Container ID: ${NEXTID}"
echo -e "  Hostname: ${HOSTNAME}"
echo -e "  CPU Cores: ${CORES}"
echo -e "  RAM: ${MEMORY}MB"
echo -e "  Disk: ${DISK_SIZE}GB"
echo -e "  Storage: ${STORAGE}"
echo -e "  OS: Debian ${OSVERSION}"
echo ""

read -p "Disk size in GB [${DISK_SIZE}]: " INPUT_DISK
if [[ -n "${INPUT_DISK}" && "${INPUT_DISK}" =~ ^[0-9]+$ && "${INPUT_DISK}" -gt 0 ]]; then
  DISK_SIZE="${INPUT_DISK}"
fi

read -p "CPU cores [${CORES}]: " INPUT_CORES
if [[ -n "${INPUT_CORES}" && "${INPUT_CORES}" =~ ^[0-9]+$ && "${INPUT_CORES}" -gt 0 ]]; then
  CORES="${INPUT_CORES}"
fi

read -p "RAM in MB [${MEMORY}]: " INPUT_MEM
if [[ -n "${INPUT_MEM}" && "${INPUT_MEM}" =~ ^[0-9]+$ && "${INPUT_MEM}" -gt 0 ]]; then
  MEMORY="${INPUT_MEM}"
fi

echo ""
echo -e "${CYAN}Final settings:${NC}"
echo -e "  Container ID: ${NEXTID}"
echo -e "  Hostname: ${HOSTNAME}"
echo -e "  CPU Cores: ${CORES}"
echo -e "  RAM: ${MEMORY}MB"
echo -e "  Disk: ${DISK_SIZE}GB"
echo -e "  Storage: ${STORAGE}"
echo -e "  OS: Debian ${OSVERSION}"
echo ""

read -p "Press Enter to create the container with these settings, or Ctrl+C to cancel: "

CTID=$NEXTID

echo ""
echo -e "${BLUE}Creating LXC container...${NC}"

# Find the latest Debian 12 template
echo -e "${YELLOW}Finding Debian ${OSVERSION} template...${NC}"
pveam update

# Get the latest Debian 12 template name
TEMPLATE=$(pveam available | grep "debian-${OSVERSION}" | grep "standard" | tail -n1 | awk '{print $2}')

if [ -z "$TEMPLATE" ]; then
    echo -e "${RED}Error: Could not find Debian ${OSVERSION} template${NC}"
    echo -e "${YELLOW}Available templates:${NC}"
    pveam available | grep debian
    exit 1
fi

echo -e "${GREEN}✓ Found template: ${TEMPLATE}${NC}"

TEMPLATE_PATH="/var/lib/vz/template/cache/${TEMPLATE}"

if [ ! -f "$TEMPLATE_PATH" ]; then
    echo -e "${YELLOW}Downloading template...${NC}"
    pveam download local "$TEMPLATE"
fi

# Create container
pct create $CTID $TEMPLATE_PATH \
    --hostname $HOSTNAME \
    --cores $CORES \
    --memory $MEMORY \
    --rootfs ${STORAGE}:${DISK_SIZE} \
    --net0 name=eth0,bridge=${BRIDGE},ip=dhcp \
    --unprivileged 0 \
    --features nesting=1 \
    --onboot 1 \
    --start 1

echo -e "${GREEN}✓ Container created (ID: $CTID)${NC}"

# Wait for container to start
echo -e "${BLUE}Waiting for container to start...${NC}"
sleep 5

# Wait for network
echo -e "${BLUE}Waiting for network...${NC}"
for i in {1..30}; do
    if pct exec $CTID -- ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Network is ready${NC}"
        break
    fi
    sleep 2
done

# Get container IP
IP=$(pct exec $CTID -- hostname -I | awk '{print $1}')
echo -e "${GREEN}✓ Container IP: $IP${NC}"
echo ""

# Run installation inside container
echo -e "${BLUE}Starting ComfyUI installation...${NC}"
echo -e "${YELLOW}This will take 10-30 minutes depending on your internet speed${NC}"
echo ""

pct exec $CTID -- bash <<'INSTALL_SCRIPT'
#!/bin/bash
set -e

# Colors inside container
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Updating system...${NC}"
apt-get update
apt-get upgrade -y

echo -e "${BLUE}Installing dependencies...${NC}"
apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    cmake \
    software-properties-common \
    gnupg2 \
    ca-certificates \
    python3-venv \
    python3.11-venv
echo -e "${BLUE}Setting up ComfyUI...${NC}"
cd /root

echo -e "${BLUE}Cloning ComfyUI-Easy-Install repository...${NC}"
git clone -b MAC-Linux https://github.com/Tavris1/ComfyUI-Easy-Install.git temp

cd temp

echo -e "${BLUE}Patching ComfyUI-Easy-Install for Linux compatibility...${NC}"
python3 - <<'PY'
from __future__ import annotations

from pathlib import Path

path = Path("ComfyUI-Easy-Install.sh")
text = path.read_text(encoding="utf-8")

needle = "# Main script execution\n"
if needle in text and "triton-windows" not in text:
    override = """
get_node() {
    GIT_URL=$1
    GIT_FOLDER=$2
    echo -e \"${GREEN}::::::::::::::: Installing${YELLOW} ${GIT_FOLDER} ${GREEN}:::::::::::::::${RESET}\"
    echo \"\"
    git clone \"$GIT_URL\" \"ComfyUI/custom_nodes/${GIT_FOLDER}\"

    if [ -f \"./ComfyUI/custom_nodes/${GIT_FOLDER}/requirements.txt\" ]; then
        if [ -s \"./ComfyUI/custom_nodes/${GIT_FOLDER}/requirements.txt\" ]; then
            REQ_FILE=\"./ComfyUI/custom_nodes/${GIT_FOLDER}/requirements.txt\"
            if [[ \"${OSTYPE}\" == \"msys\"* || \"${OSTYPE}\" == \"cygwin\"* || \"${OSTYPE}\" == \"win32\"* ]]; then
                python -m uv pip install -r \"$REQ_FILE\" $UV_ARGS
            else
                if [ \"$GIT_FOLDER\" = \"ComfyUI-RMBG\" ]; then
                    REQ_TMP=\"${REQ_FILE}.cei.tmp\"
                    grep -v -E '^[[:space:]]*triton-windows([<>=!~ ].*)?$' \"$REQ_FILE\" > \"$REQ_TMP\" || true
                    python -m uv pip install -r \"$REQ_TMP\" $UV_ARGS
                    rm -f \"$REQ_TMP\" || true
                else
                    python -m uv pip install -r \"$REQ_FILE\" $UV_ARGS
                fi
            fi
        fi
    fi

    if [ -f \"./ComfyUI/custom_nodes/${GIT_FOLDER}/install.py\" ]; then
        if [ -s \"./ComfyUI/custom_nodes/${GIT_FOLDER}/install.py\" ]; then
            python \"./ComfyUI/custom_nodes/${GIT_FOLDER}/install.py\"
        fi
    fi
    echo \"\"
}

""".lstrip("\n")
    text = text.replace(needle, override + needle)
    path.write_text(text, encoding="utf-8")

print("Patched")
PY

echo -e "${BLUE}Running ComfyUI-Easy-Install...${NC}"
bash ComfyUI-Easy-Install.sh

echo -e "${BLUE}Creating systemd service...${NC}"

# Detect which Python venv was created
PYTHON_VENV=""
WORKDIR="/root/temp/ComfyUI-Easy-Install/ComfyUI-Easy-Install"

if [ -d "${WORKDIR}/python_embeded" ]; then
    PYTHON_VENV="${WORKDIR}/python_embeded/bin/python"
elif [ -d "${WORKDIR}/python_embeded_3.12" ]; then
    PYTHON_VENV="${WORKDIR}/python_embeded_3.12/bin/python"
elif [ -d "${WORKDIR}/python_embeded_3.11" ]; then
    PYTHON_VENV="${WORKDIR}/python_embeded_3.11/bin/python"
else
    PYTHON_VENV="/usr/bin/python3"
fi

cat <<EOF >/etc/systemd/system/comfyui.service
[Unit]
Description=ComfyUI - AI Image Generation
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=${WORKDIR}
ExecStart=${PYTHON_VENV} ComfyUI/main.py --listen 0.0.0.0 --port 8188
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable comfyui.service

echo -e "${GREEN}✓ Installation complete!${NC}"
echo ""
echo -e "${YELLOW}Note: GPU passthrough must be configured before starting ComfyUI${NC}"

INSTALL_SCRIPT

# Now install NVIDIA components from host
echo ""
echo -e "${BLUE}Installing NVIDIA Driver from host...${NC}"

# Find NVIDIA driver on host
NVIDIA_DRIVER_RUN=$(find /root /tmp /usr/local/src -name "NVIDIA-Linux-x86_64-*.run" 2>/dev/null | head -n1)

if [ -z "$NVIDIA_DRIVER_RUN" ]; then
    echo -e "${YELLOW}Warning: No NVIDIA driver .run file found on host${NC}"
    echo -e "${YELLOW}Looking for driver in common locations...${NC}"
    
    # Try to detect driver version from nvidia-smi
    if command -v nvidia-smi &> /dev/null; then
        DRIVER_VERSION=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | head -n1)
        echo -e "${YELLOW}Host driver version: ${DRIVER_VERSION}${NC}"
        echo -e "${YELLOW}You can install the driver later with:${NC}"
        echo -e "  ${GREEN}bash install-nvidia-driver.sh ${CTID}${NC}"
    fi
else
    echo -e "${GREEN}✓ Found NVIDIA driver: ${NVIDIA_DRIVER_RUN}${NC}"
    
    # Push driver to container
    pct push ${CTID} ${NVIDIA_DRIVER_RUN} /root/nvidia-driver.run
    
    # Install driver in container
    echo -e "${YELLOW}Installing driver in container (this may take a few minutes)...${NC}"
    pct exec ${CTID} -- bash -c "cd /root && chmod +x nvidia-driver.run && ./nvidia-driver.run --no-kernel-modules"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ NVIDIA driver installed in container${NC}"
    else
        echo -e "${RED}✗ Driver installation failed${NC}"
        echo -e "${YELLOW}You can retry with: bash install-nvidia-driver.sh ${CTID}${NC}"
    fi
fi

echo ""
echo -e "${BLUE}Installing NVIDIA Container Toolkit...${NC}"

pct exec ${CTID} -- bash -c "
apt-get install -y gpg curl
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
apt-get update
apt-get install -y nvidia-container-toolkit
"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ NVIDIA Container Toolkit installed${NC}"
else
    echo -e "${RED}✗ NVIDIA Container Toolkit installation failed${NC}"
fi

echo ""
echo -e "${BLUE}Configuring NVIDIA Container Runtime...${NC}"

pct exec ${CTID} -- bash -c "
if [ -f /etc/nvidia-container-runtime/config.toml ]; then
    sed -i 's/#no-cgroups = false/no-cgroups = true/' /etc/nvidia-container-runtime/config.toml
    sed -i 's/no-cgroups = false/no-cgroups = true/' /etc/nvidia-container-runtime/config.toml
    echo 'Set no-cgroups = true in config.toml'
fi
"

echo -e "${GREEN}✓ NVIDIA Container Runtime configured${NC}"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}  ${BLUE}ComfyUI Container Created Successfully!${NC}          ${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Container Details:${NC}"
echo -e "  ID: ${CTID}"
echo -e "  IP: ${IP}"
echo -e "  URL: ${BLUE}http://${IP}:8188${NC}"
echo ""
echo -e "${GREEN}✓ NVIDIA Driver and Container Toolkit installed${NC}"
echo ""
echo -e "${YELLOW}IMPORTANT: GPU Passthrough Configuration Required${NC}"
echo ""
echo -e "${CYAN}Option 1: Use automated script (Recommended)${NC}"
echo -e "  ${GREEN}bash setup-gpu-passthrough.sh ${CTID}${NC}"
echo ""
echo -e "${CYAN}Option 2: Manual configuration${NC}"
echo -e "  1. Edit config: ${GREEN}nano /etc/pve/lxc/${CTID}.conf${NC}"
echo -e "  2. Add GPU device permissions:"
echo -e "     ${GREEN}lxc.cgroup2.devices.allow: c 195:* rwm${NC}  # nvidia0, nvidiactl"
echo -e "     ${GREEN}lxc.cgroup2.devices.allow: c 234:* rwm${NC}  # nvidia-uvm, nvidia-uvm-tools"
echo -e "     ${GREEN}lxc.cgroup2.devices.allow: c 237:* rwm${NC}  # nvidia-caps"
echo -e "  3. Add GPU device mounts:"
echo -e "     ${GREEN}lxc.mount.entry: /dev/nvidia0 dev/nvidia0 none bind,optional,create=file${NC}"
echo -e "     ${GREEN}lxc.mount.entry: /dev/nvidiactl dev/nvidiactl none bind,optional,create=file${NC}"
echo -e "     ${GREEN}lxc.mount.entry: /dev/nvidia-uvm dev/nvidia-uvm none bind,optional,create=file${NC}"
echo -e "     ${GREEN}lxc.mount.entry: /dev/nvidia-uvm-tools dev/nvidia-uvm-tools none bind,optional,create=file${NC}"
echo -e "     ${GREEN}lxc.mount.entry: /dev/nvidia-caps/nvidia-cap1 dev/nvidia-caps/nvidia-cap1 none bind,optional,create=file${NC}"
echo -e "     ${GREEN}lxc.mount.entry: /dev/nvidia-caps/nvidia-cap2 dev/nvidia-caps/nvidia-cap2 none bind,optional,create=file${NC}"
echo -e "  4. Restart: ${GREEN}pct reboot ${CTID}${NC}"
echo ""
echo -e "${CYAN}After GPU passthrough setup:${NC}"
echo -e "  Verify GPU: ${GREEN}pct exec ${CTID} -- nvidia-smi${NC}"
echo -e "  Start ComfyUI: ${GREEN}pct exec ${CTID} -- systemctl start comfyui${NC}"
echo -e "  Check logs: ${GREEN}pct exec ${CTID} -- journalctl -u comfyui -f${NC}"
echo -e "  Access UI: ${BLUE}http://${IP}:8188${NC}"
echo ""
