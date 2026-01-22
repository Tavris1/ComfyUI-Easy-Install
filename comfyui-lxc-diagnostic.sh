#!/bin/bash

# ComfyUI-Easy-Install Diagnostic Script for Proxmox LXC
# Based on your original script with enhanced error tracking

# Set colors
WARNING='\033[33m'
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BOLD='\033[1m'
BLUE='\033[94m'
RESET='\033[0m'

# Logging
LOG_FILE="comfyui-install-diagnostic.log"
exec > >(tee -a "$LOG_FILE")
exec 2>&1

echo -e "${BLUE}=== ComfyUI-Easy-Install Diagnostic Started ===${RESET}"
echo -e "${BLUE}Timestamp: $(date)${RESET}"
echo -e "${BLUE}Log file: $LOG_FILE${RESET}"
echo ""

# System info
echo -e "${GREEN}=== System Information ===${RESET}"
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo "Kernel: $(uname -r)"
echo "Architecture: $(uname -m)"
echo "Memory: $(free -h)"
echo "Disk space: $(df -h /)"
echo "Load average: $(uptime | awk -F'load average:' '{print $2}')"
echo ""

PYTHON_VERSION="3.12"
echo -e "${GREEN}=== Python Version Check ===${RESET}"
echo "Required Python version: $PYTHON_VERSION"
if [ "$PYTHON_VERSION" != "3.12" ]; then
    echo -e "${WARNING}WARNING: ${RED}Only Python 3.12 is supported.${RESET}"
    exit 1
fi
echo -e "${GREEN}✓ Python version requirement satisfied${RESET}"
echo ""

# Set environment variables
export GIT_LFS_SKIP_SMUDGE=1
export GIT_TERMINAL_PROMPT=0
PIP_ARGS="--no-cache-dir --no-warn-script-location --timeout=1000 --retries 10"
CURL_ARGS="--retry 200 --retry-all-errors"
UV_ARGS="--no-cache --link-mode=copy"

echo -e "${GREEN}=== Environment Variables Set ===${RESET}"
echo "GIT_LFS_SKIP_SMUDGE=$GIT_LFS_SKIP_SMUDGE"
echo "GIT_TERMINAL_PROMPT=$GIT_TERMINAL_PROMPT"
echo ""

# Check for existing directories
echo -e "${GREEN}=== Directory Checks ===${RESET}"
if [ -d "ComfyUI-Easy-Install" ]; then
    echo -e "${WARNING}WARNING: 'ComfyUI-Easy-Install' folder already exists!${RESET}"
    echo "Contents:"
    ls -la ComfyUI-Easy-Install/
    echo ""
fi

HLPR_NAME="Helper-CEI-NEXT-unix.zip"
if [ ! -f "$HLPR_NAME" ]; then
    echo -e "${WARNING}WARNING: '$HLPR_NAME' not found!${RESET}"
    echo "Current directory contents:"
    ls -la *.zip 2>/dev/null || echo "No zip files found"
    echo ""
else
    echo -e "${GREEN}✓ Helper file found: $HLPR_NAME${RESET}"
fi

# Check system requirements
echo -e "${GREEN}=== System Requirements Check ===${RESET}"

# Git check
if command -v git &> /dev/null; then
    echo -e "${GREEN}✓ git is installed: $(git --version)${RESET}"
else
    echo -e "${RED}✗ git is NOT installed${RESET}"
    echo "Install with: apt-get update && apt-get install -y git"
fi

# Python check
if command -v python3 &> /dev/null; then
    echo -e "${GREEN}✓ python3 is installed: $(python3 --version)${RESET}"
else
    echo -e "${RED}✗ python3 is NOT installed${RESET}"
    echo "Install with: apt-get update && apt-get install -y python3 python3-pip python3-venv"
fi

# Check build dependencies
echo -e "${GREEN}=== Build Dependencies Check ===${RESET}"
BUILD_DEPS="build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev liblzma-dev libbz2-dev libsqlite3-dev uuid-dev libdb-dev tk-dev libncursesw5-dev unzip"

for dep in $BUILD_DEPS; do
    if dpkg -l | grep -q "^ii  $dep "; then
        echo -e "${GREEN}✓ $dep is installed${RESET}"
    else
        echo -e "${RED}✗ $dep is NOT installed${RESET}"
    fi
done

echo ""

# Test network connectivity
echo -e "${GREEN}=== Network Connectivity Test ===${RESET}"
if ping -c 1 google.com &> /dev/null; then
    echo -e "${GREEN}✓ Internet connectivity OK${RESET}"
else
    echo -e "${RED}✗ No internet connectivity${RESET}"
fi

if curl -s https://github.com &> /dev/null; then
    echo -e "${GREEN}✓ GitHub accessible${RESET}"
else
    echo -e "${RED}✗ GitHub not accessible${RESET}"
fi

echo ""

# Disk space check
echo -e "${GREEN}=== Disk Space Analysis ===${RESET}"
AVAILABLE_SPACE=$(df / | awk 'NR==2 {print $4}')
REQUIRED_SPACE=10000000  # ~10GB in KB

if [ "$AVAILABLE_SPACE" -gt "$REQUIRED_SPACE" ]; then
    echo -e "${GREEN}✓ Sufficient disk space available: $(df -h / | awk 'NR==2 {print $4}')${RESET}"
else
    echo -e "${RED}✗ Insufficient disk space. Required: ~10GB, Available: $(df -h / | awk 'NR==2 {print $4}')${RESET}"
fi

echo ""

# Memory check
echo -e "${GREEN}=== Memory Analysis ===${RESET}"
AVAILABLE_MEM=$(free -m | awk 'NR==2{print $7}')
REQUIRED_MEM=2048  # 2GB minimum

if [ "$AVAILABLE_MEM" -gt "$REQUIRED_MEM" ]; then
    echo -e "${GREEN}✓ Sufficient memory available: ${AVAILABLE_MEM}MB${RESET}"
else
    echo -e "${RED}✗ Low memory. Available: ${AVAILABLE_MEM}MB, Recommended: 2GB+${RESET}"
fi

echo ""

# Create test directory structure
echo -e "${GREEN}=== Test Directory Creation ===${RESET}"
TEST_DIR="test-comfyui-setup"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo -e "${GREEN}✓ Created test directory: $(pwd)${RESET}"

# Test git clone
echo -e "${GREEN}=== Test Git Clone ===${RESET}"
echo "Testing git clone of ComfyUI..."
if git clone --depth 1 https://github.com/Comfy-Org/ComfyUI test-comfyui; then
    echo -e "${GREEN}✓ Git clone successful${RESET}"
    rm -rf test-comfyui
else
    echo -e "${RED}✗ Git clone failed${RESET}"
fi

# Test Python compilation
echo -e "${GREEN}=== Test Python Compilation ===${RESET}"
echo "Testing if Python can be compiled from source..."

# Check if we can download Python source
PYTHON_VER="3.12.10"
PYTHON_SRC_URL="https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz"

echo "Testing Python source download..."
if curl -L --connect-timeout 10 "$PYTHON_SRC_URL" -o test-python.tgz; then
    echo -e "${GREEN}✓ Python source download successful${RESET}"
    
    # Test extraction
    if tar -tzf test-python.tgz >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Python source archive valid${RESET}"
        rm -f test-python.tgz
    else
        echo -e "${RED}✗ Python source archive corrupted${RESET}"
    fi
else
    echo -e "${RED}✗ Python source download failed${RESET}"
fi

echo ""

# Summary
echo -e "${BLUE}=== Diagnostic Summary ===${RESET}"
echo "Check the log file: $LOG_FILE"
echo "Review any RED warnings above"
echo ""

echo -e "${GREEN}=== Recommendations ===${RESET}"
echo "1. Install missing dependencies if any RED items found"
echo "2. Ensure at least 10GB free disk space"
echo "3. Ensure at least 2GB RAM available"
echo "4. Check network connectivity to GitHub"
echo ""

echo -e "${BLUE}=== Diagnostic Complete ===${RESET}"
