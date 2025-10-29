#!/bin/bash
# ComfyUI Backup Script
# Pixaroma Community Edition
# by ivo
# Creates timestamped backups of ComfyUI input, output, and user directories

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Default paths
COMFY_DIR="${HOME}/ComfyUI-Easy-Install/ComfyUI"
BACKUP_DIR="${COMFY_DIR}/user_backups"
USER_DIR="${COMFY_DIR}/user"
INPUT_DIR="${COMFY_DIR}/input"
OUTPUT_DIR="${COMFY_DIR}/output"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="comfyui_backup_${TIMESTAMP}"

# Check if directories exist
if [ ! -d "$USER_DIR" ]; then
    echo -e "${RED}Error: User directory not found at $USER_DIR${NC}"
    exit 1
fi
if [ ! -d "$INPUT_DIR" ]; then
    echo -e "${YELLOW}Warning: Input directory not found at $INPUT_DIR - skipping${NC}"
fi
if [ ! -d "$OUTPUT_DIR" ]; then
    echo -e "${YELLOW}Warning: Output directory not found at $OUTPUT_DIR - skipping${NC}"
fi

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to create backup directory $BACKUP_DIR${NC}"
    exit 1
fi

# Create the backup
echo -e "${YELLOW}Creating backup of ComfyUI directories...${NC}"
mkdir -p "${BACKUP_DIR}/${BACKUP_NAME}"
rsync -a --delete \
    --exclude='__pycache__' \
    --exclude='.git' \
    --exclude='*.tmp' \
    --exclude='*.bak' \
    --exclude='*.swp' \
    "${USER_DIR}/" "${BACKUP_DIR}/${BACKUP_NAME}/user/"
if [ -d "$INPUT_DIR" ]; then
    rsync -a --delete \
        --exclude='__pycache__' \
        --exclude='.git' \
        --exclude='*.tmp' \
        --exclude='*.bak' \
        --exclude='*.swp' \
        "${INPUT_DIR}/" "${BACKUP_DIR}/${BACKUP_NAME}/input/"
fi
if [ -d "$OUTPUT_DIR" ]; then
    rsync -a --delete \
        --exclude='__pycache__' \
        --exclude='.git' \
        --exclude='*.tmp' \
        --exclude='*.bak' \
        --exclude='*.swp' \
        "${OUTPUT_DIR}/" "${BACKUP_DIR}/${BACKUP_NAME}/output/"
fi

# Check if backup was successful
if [ $? -eq 0 ]; then
    # Create a symlink to the latest backup
    ln -sfn "${BACKUP_DIR}/${BACKUP_NAME}" "${BACKUP_DIR}/latest"
    
    # Clean up old backups (keep last 10)
    echo -e "${YELLOW}Cleaning up old backups...${NC}"
    ls -dt "${BACKUP_DIR}/comfyui_backup_"* | tail -n +11 | xargs -r rm -rf
    
    # Show backup info
    BACKUP_SIZE=$(du -sh "${BACKUP_DIR}/${BACKUP_NAME}" | cut -f1)
    BACKUP_COUNT=$(find "${BACKUP_DIR}" -maxdepth 1 -type d -name "comfyui_backup_*" | wc -l)
    
    echo -e "\n${GREEN}Backup completed successfully!${NC}"
    echo -e "Backup location: ${BACKUP_DIR}/${BACKUP_NAME}"
    echo -e "Backup size: ${BACKUP_SIZE}"
    echo -e "Total backups kept: ${BACKUP_COUNT}"
    echo -e "Latest backup: ${BACKUP_NAME}"
else
    echo -e "${RED}Error: Backup failed${NC}"
    exit 1
fi

# Create a restore script
cat > "${BACKUP_DIR}/restore_latest.sh" << 'EOF'
#!/bin/bash
# Script to restore the latest ComfyUI backup

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LATEST_BACKUP="${BACKUP_DIR}/latest"
TARGET_DIR="$(dirname "$BACKUP_DIR")"

if [ ! -d "$LATEST_BACKUP" ]; then
    echo "Error: No backup found to restore"
    exit 1
fi

echo "Restoring ComfyUI directories from latest backup..."
if [ -d "$LATEST_BACKUP/user" ]; then
    rsync -a --delete "${LATEST_BACKUP}/user/" "${TARGET_DIR}/user/"
fi
if [ -d "$LATEST_BACKUP/input" ]; then
    rsync -a --delete "${LATEST_BACKUP}/input/" "${TARGET_DIR}/input/"
fi
if [ -d "$LATEST_BACKUP/output" ]; then
    rsync -a --delete "${LATEST_BACKUP}/output/" "${TARGET_DIR}/output/"
fi

if [ $? -eq 0 ]; then
    echo "Restore completed successfully!"
else
    echo "Error: Restore failed"
    exit 1
fi
EOF

chmod +x "${BACKUP_DIR}/restore_latest.sh"
echo -e "\n${YELLOW}Restore script created: ${BACKUP_DIR}/restore_latest.sh${NC}"
