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
    echo "Sync ComfyUI output with detailed progress and date-based organization"
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
    echo "Note: Files will be organized in date-based folders (YYYY-MM-DD)"
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

# Create date directory
TODAY=$(date +"%Y-%m-%d")
DATE_DIR="$DEST/$TODAY"

echo -e "\n${BLUE}Creating date directory: $DATE_DIR${NC}"
mkdir -p "$DATE_DIR"
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to create date directory $DATE_DIR${NC}"
    exit 1
fi

# Check for existing files first
echo -e "\n${YELLOW}Checking for existing files...${NC}"

# Get list of files in source
SOURCE_FILES=("$SOURCE"*)
NEW_FILES=0
SKIPPED_FILES=0

# Create a temporary file to store file checksums
TMP_CHECKSUMS=$(mktemp)

# If date directory already exists, calculate checksums for existing files
if [ -d "$DATE_DIR" ] && [ "$(ls -A "$DATE_DIR" 2>/dev/null)" ]; then
    echo -e "${BLUE}Found existing files in $DATE_DIR, calculating checksums...${NC}"
    find "$DATE_DIR" -type f -exec md5sum {} \; | awk '{print $1, $2}' > "$TMP_CHECKSUMS"
    echo -e "${GREEN}Done calculating checksums for existing files${NC}"
fi

# Perform the sync with date-based organization and skip existing files
echo -e "\n${YELLOW}Starting sync to date folder: $TODAY${NC}"

# Use rsync with --ignore-existing to skip files that already exist
rsync -rltDv --ignore-existing --no-owner --no-group --no-perms --progress $DRY_RUN "$SOURCE"* "$DATE_DIR/"

# Count new and existing files
for file in "${SOURCE_FILES[@]}"; do
    if [ -f "$file" ]; then
        # Get just the filename without path
        filename=$(basename "$file")
        dest_file="$DATE_DIR/$filename"
        
        # Check if file exists in destination
        if [ -f "$dest_file" ]; then
            # Compare checksums to see if it's the same file
            src_md5=$(md5sum "$file" | cut -d' ' -f1)
            dest_md5=$(grep -F "$dest_file" "$TMP_CHECKSUMS" | cut -d' ' -f1)
            
            if [ "$src_md5" = "$dest_md5" ]; then
                SKIPPED_FILES=$((SKIPPED_FILES + 1))
            else
                NEW_FILES=$((NEW_FILES + 1))
            fi
        else
            NEW_FILES=$((NEW_FILES + 1))
        fi
    fi
done

# Clean up temporary file
rm -f "$TMP_CHECKSUMS"

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}Sync completed successfully!${NC}"
    echo -e "Files organized in: ${BLUE}$DATE_DIR${NC}"
    
    # Count total files
    TOTAL_FILES=$(find "$DATE_DIR" -type f | wc -l)
    echo -e "New files synced: ${GREEN}$NEW_FILES${NC}"
    echo -e "Files skipped (already exist): ${YELLOW}$SKIPPED_FILES${NC}"
    echo -e "Total files in destination: ${GREEN}$TOTAL_FILES${NC}"
else
    echo -e "\n${RED}Error: Sync failed${NC}"
    exit 1
fi
