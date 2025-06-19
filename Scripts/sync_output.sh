#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default source and destination
SOURCE="/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI/output/"
DEST="/mnt/downloads/comfyui_output/"

# Help message
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Sync ComfyUI output to backup folder, only copying new or updated files."
    echo
    echo "Options:"
    echo "  -s SOURCE    Source directory (default: $SOURCE)"
    echo "  -d DEST      Destination directory (default: $DEST)"
    echo "  -n          Dry run - show what would be copied"
    echo "  -h          Show this help message"
    echo
    echo "Example:"
    echo "  $0 -s /path/to/output/ -d /path/to/backup/"
    echo
    echo "Note: Existing files in DEST will not be overwritten unless source is newer."
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

# Check source and destination
if [ ! -d "$SOURCE" ]; then
    echo -e "${RED}Source directory does not exist: $SOURCE${NC}"
    exit 1
fi
if [ ! -d "$DEST" ]; then
    echo -e "${YELLOW}Destination directory does not exist, creating: $DEST${NC}"
    mkdir -p "$DEST"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to create destination directory: $DEST${NC}"
        exit 1
    fi
fi

# Clean up old date-based folders in destination
echo -e "${YELLOW}Cleaning up old date-based folders in destination...${NC}"
find "$DEST" -maxdepth 1 -type d -regextype posix-extended -regex ".*/[0-9]{4}-[0-9]{2}-[0-9]{2}" -exec rm -rf {} +
echo -e "${GREEN}Old date-based folders removed (if any existed).${NC}"

# Count files in source and destination before syncing
SOURCE_FILE_COUNT=$(find "$SOURCE" -type f | wc -l)
DEST_FILE_COUNT_BEFORE=$(find "$DEST" -type f | wc -l)
echo -e "${YELLOW}Files in source: ${GREEN}$SOURCE_FILE_COUNT${NC}"
echo -e "${YELLOW}Files in destination: ${GREEN}$DEST_FILE_COUNT_BEFORE${NC}"

# Use rsync to sync files, only copying new or updated files
# -a: archive mode (preserves permissions, timestamps, etc.)
# -v: verbose output
# -u: skip files that are newer on the receiver
# --progress: show progress during transfer
echo -e "${BLUE}Syncing files from:${NC}"
echo -e "${BLUE}$SOURCE${NC}"
echo -e "${BLUE}to:${NC}"
echo -e "${BLUE}$DEST${NC}"

# If dry run, show what would be copied
if [ ! -z "$DRY_RUN" ]; then
    echo -e "${YELLOW}DRY RUN - showing what would be copied${NC}"
fi

# Sync files and capture output
SYNC_LOG=$(mktemp)
rsync -avu --progress --no-owner --no-group --no-perms $DRY_RUN "$SOURCE" "$DEST" | tee "$SYNC_LOG"

# Count new files copied (lines starting with >f)
NEW_FILES_COPIED=$(grep -c '^>f' "$SYNC_LOG")
rm -f "$SYNC_LOG"

# Count files in destination after sync
DEST_FILE_COUNT_AFTER=$(find "$DEST" -type f | wc -l)

# Show summary
echo -e "\n${GREEN}Sync complete!${NC}"
echo -e "${YELLOW}Files in source: ${GREEN}$SOURCE_FILE_COUNT${NC}"
echo -e "${YELLOW}Files in destination: ${GREEN}$DEST_FILE_COUNT_AFTER${NC}"
echo -e "${YELLOW}New files copied: ${GREEN}$NEW_FILES_COPIED${NC}"
