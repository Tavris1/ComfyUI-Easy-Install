	#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Default source and destination
SOURCE="/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI/output/"
DEST="/mnt/downloads/comfyui_output/"

# Help message
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Sync ComfyUI output with detailed progress"
    echo
    echo "Options:"
    echo "  -s SOURCE    Source directory (default: $SOURCE)"
    echo "  -d DEST      Destination directory (default: $DEST)"
    echo "  -n          Dry run - show what would be copied"
    echo "  -h          Show this help message"
    echo
    echo "Example:"
    echo "  $0 -s /path/to/output/ -d /path/to/backup/"
}

# Parse command line options
DRY_RUN=""
while getopts "s:d:nh" opt; do
    case $opt in
        s) SOURCE="$OPTARG";;
        d) DEST="$OPTARG";;
        n) DRY_RUN="--dry-run";;
        h) show_help; exit 0;;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
    esac
done

# Validate directories
if [ ! -d "$SOURCE" ]; then
    echo -e "${RED}Error: Source directory $SOURCE does not exist${NC}"
    exit 1
fi

# Create destination if it doesn't exist
mkdir -p "$DEST"
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to create destination directory $DEST${NC}"
    exit 1
fi

# Show summary before starting
echo -e "${YELLOW}Transfer Summary:${NC}"
echo "From: $SOURCE"
echo "To:   $DEST"
if [ ! -z "$DRY_RUN" ]; then
    echo -e "${YELLOW}DRY RUN - No files will be copied${NC}"
fi

# Calculate total size
echo -e "\n${YELLOW}Calculating total size...${NC}"
TOTAL_SIZE=$(du -sh "$SOURCE" 2>/dev/null | cut -f1)
echo -e "Total size to transfer: ${GREEN}$TOTAL_SIZE${NC}"

# Ask for confirmation if not a dry run
if [ -z "$DRY_RUN" ]; then
    read -p "Continue with transfer? (yes/no): " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        echo -e "${YELLOW}Operation cancelled${NC}"
        exit 1
    fi
fi

# Perform the sync
echo -e "\n${YELLOW}Starting sync...${NC}"
rsync -rltDv --no-owner --no-group --no-perms --progress $DRY_RUN "$SOURCE"* "$DEST"

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}Sync completed successfully!${NC}"
else
    echo -e "\n${RED}Error: Sync failed${NC}"
    exit 1
fi
