#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Default source and destination
SOURCE="/mnt/pve/Models/"
DEST="/mnt/models/"

# Help message
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Sync models with detailed progress"
    echo
    echo "Options:"
    echo "  -s SOURCE    Source directory (default: $SOURCE)"
    echo "  -d DEST      Destination directory (default: $DEST)"
    echo "  -n          Dry run - show what would be copied"
    echo "  -h          Show this help message"
    echo
    echo "Example:"
    echo "  $0 -s /path/to/source/ -d /path/to/dest/"
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

# Ensure paths end with /
[[ "$SOURCE" != */ ]] && SOURCE="$SOURCE/"
[[ "$DEST" != */ ]] && DEST="$DEST/"

# Validate directories
if [ ! -d "$SOURCE" ]; then
    echo -e "${RED}Error: Source directory $SOURCE does not exist${NC}"
    exit 1
fi

if [ ! -d "$DEST" ]; then
    echo -e "${RED}Error: Destination directory $DEST does not exist${NC}"
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

# Ask for confirmation
if [ -z "$DRY_RUN" ]; then
    read -p "Continue with transfer? (yes/no): " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        echo -e "${YELLOW}Operation cancelled${NC}"
        exit 1
    fi
fi

# Test transfer speed first with larger file and sustained write
echo -e "\n${YELLOW}Testing transfer speed...${NC}"
echo -e "${YELLOW}Initial speed (1GB):${NC}"
dd if=/dev/zero of="${DEST}test_speed" bs=64M count=16 conv=fdatasync 2>&1 | tail -n 1

echo -e "\n${YELLOW}Sustained speed (4GB):${NC}"
dd if=/dev/zero of="${DEST}test_speed" bs=1G count=4 conv=fdatasync 2>&1 | tail -n 1

rm "${DEST}test_speed"
echo -e "\n${YELLOW}Note: Actual transfer speed may be lower due to file sizes and drive characteristics${NC}"

# Perform the sync with enhanced progress
echo -e "\n${YELLOW}Starting transfer...${NC}"
rsync -avh --progress --stats --inplace $DRY_RUN \
    --info=progress2,name0,remove0,stats2 \
    --bwlimit=0 \
    --no-compress \
    --exclude=".*" \
    --exclude="@eaDir" \
    "$SOURCE" "$DEST" 2>&1 | \
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*[0-9]+% ]]; then
            # Progress line
            PERCENT=$(echo "$line" | grep -oE '^[[:space:]]*[0-9]+%' | tr -d ' %')
            SPEED=$(echo "$line" | grep -oE '[0-9.]+[kMG]B/s')
            REMAINING=$(echo "$line" | grep -oE '[0-9]+:[0-9]+:[0-9]+ *$')
            echo -ne "\r${GREEN}Progress: $PERCENT% | Speed: $SPEED | ETA: $REMAINING${NC}"
        elif [[ $line =~ ^[^/]+/[^/]+$ ]]; then
            # Current file
            echo -e "\n${YELLOW}Copying: $line${NC}"
        else
            echo "$line"
        fi
    done

# Check result
if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}Transfer completed successfully${NC}"
    if [ -z "$DRY_RUN" ]; then
        echo -e "\n${YELLOW}Final space usage:${NC}"
        df -h "$DEST"
    fi
else
    echo -e "\n${RED}Transfer failed${NC}"
    exit 1
fi
