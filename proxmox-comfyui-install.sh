#!/usr/bin/env bash

# Copyright (c) 2025 VenimK
# Author: VenimK
# License: MIT
# https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y \
  curl \
  sudo \
  git \
  build-essential \
  cmake \
  wget \
  software-properties-common \
  gnupg2
msg_ok "Installed Dependencies"

msg_info "Installing Python 3.12"
$STD add-apt-repository -y ppa:deadsnakes/ppa
$STD apt-get update
$STD apt-get install -y \
  python3.12 \
  python3.12-venv \
  python3.12-dev \
  python3-pip
$STD update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
msg_ok "Installed Python 3.12"

msg_info "Installing NVIDIA Container Toolkit"
# Add NVIDIA repository
$STD curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

$STD apt-get update
$STD apt-get install -y nvidia-container-toolkit
msg_ok "Installed NVIDIA Container Toolkit"

msg_info "Installing CUDA Toolkit 12.8"
# Install CUDA keyring
$STD wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
$STD dpkg -i cuda-keyring_1.1-1_all.deb
$STD rm cuda-keyring_1.1-1_all.deb

$STD apt-get update
$STD apt-get install -y cuda-toolkit-12-8

# Set up environment
echo 'export PATH=/usr/local/cuda-12.8/bin${PATH:+:${PATH}}' >> /root/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> /root/.bashrc
msg_ok "Installed CUDA Toolkit 12.8"

msg_info "Setting Up ComfyUI Installation Directory"
cd /root
mkdir -p temp
cd temp
msg_ok "Created Installation Directory"

msg_info "Downloading ComfyUI-Easy-Install"
$STD wget -O ComfyUI-Easy-Install.sh https://raw.githubusercontent.com/Tavris1/ComfyUI-Easy-Install/refs/heads/MAC-Linux/ComfyUI-Easy-Install.sh
chmod +x ComfyUI-Easy-Install.sh
msg_ok "Downloaded ComfyUI-Easy-Install"

msg_info "Running ComfyUI-Easy-Install (This may take 10-30 minutes)"
# Run the installer non-interactively
export DEBIAN_FRONTEND=noninteractive
$STD bash ComfyUI-Easy-Install.sh
msg_ok "ComfyUI Installation Complete"

msg_info "Creating ComfyUI Service"
cat <<EOF >/etc/systemd/system/comfyui.service
[Unit]
Description=ComfyUI - AI Image Generation
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/temp/ComfyUI-Easy-Install/ComfyUI-Easy-Install
ExecStart=/root/temp/ComfyUI-Easy-Install/ComfyUI-Easy-Install/python_embeded_3.12/bin/python ComfyUI/main.py --listen 0.0.0.0 --port 8188
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

$STD systemctl daemon-reload
$STD systemctl enable comfyui.service
msg_ok "Created ComfyUI Service"

msg_info "Starting ComfyUI"
$STD systemctl start comfyui.service
msg_ok "Started ComfyUI"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:8188${CL} \n"
