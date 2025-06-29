#!/bin/bash

# Exit on error, unset variable usage, and pipeline errors
set -euo pipefail

# Colors and formatting
# Text colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;94m'      # Brighter blue
PURPLE='\033[0;35m'
CYAN='\033[0;96m'      # Brighter cyan
WHITE='\033[1;37m'

# Background colors
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_MAGENTA='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

# Text formatting
BOLD='\033[1m'
DIM='\033[2m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
INVERT='\033[7m'
HIDDEN='\033[8m'

# Reset everything
NC='\033[0m'  # No Color

# Custom styles
SUCCESS="${BOLD}${GREEN}"
WARNING="${BOLD}${YELLOW}"
ERROR="${BOLD}${RED}"
INFO="${BOLD}${BLUE}"
DEBUG="${BOLD}${PURPLE}"
HIGHLIGHT="${BOLD}${CYAN}"
DIMTEXT="${DIM}${WHITE}"
HEADER="${BOLD}${WHITE}${BG_BLUE}"
SEPARATOR="${DIM}${BLUE}────────────────────────────────────────────${NC}"

# Default configuration
SOURCE="/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI/output"
DEST="/mnt/downloads/comfyui_output"
LOG_FILE=""
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
VERSION="1.3.0"
SYNC_MODE="source-to-dest"  # Default sync mode

# Ensure we have a clean exit
cleanup() {
    if [ -f "${SYNC_LOG:-}" ]; then
        rm -f "$SYNC_LOG"
    fi
    echo -e "\n${BLUE}Script completed at $(date)${NC}"
}
trap cleanup EXIT

# Help message
show_help() {
    echo -e "${GREEN}ComfyUI Output Sync Tool v$VERSION${NC}"
    echo "Sync ComfyUI output to backup folder, only copying new or updated files."
    echo -e "${YELLOW}Usage:${NC} $0 [OPTIONS]"
    echo
    echo -e "${YELLOW}Options:${NC}"
    echo -e "  -s SOURCE    Source directory (default: $SOURCE)"
    echo -e "  -d DEST      Destination directory (default: $DEST)"
    echo -e "  -l LOG_FILE  Log file (default: none)"
    echo -e "  -n           Dry run (don't actually sync)"
    echo -e "  -f           Force mode (don't ask for confirmation)"
    echo -e "  -m MODE      Sync mode (see below)"
    echo -e "  -h           Show this help message"
    echo
    echo -e "${YELLOW}Sync Modes:${NC}"
    echo -e "  source-to-dest: Copy from source to destination (default)"
    echo -e "  dest-to-source: Copy from destination to source"
    echo -e "  mirror-source: Make destination identical to source"
    echo -e "  mirror-dest:   Make source identical to destination"
    echo
    echo -e "${YELLOW}Examples:${NC}"
    echo "  $0 -s /path/to/output -d /path/to/backup"
    echo "  $0 -s /path/to/output -d /path/to/backup -n"
    echo "  $0 -s /path/to/output -d /path/to/backup -l sync_${TIMESTAMP}.log"
    echo
    echo -e "${YELLOW}Notes:${NC}"
    echo "  - Existing files in DEST will not be overwritten unless source is newer"
    echo "  - Use trailing slash in source to copy contents, not the directory itself"
    echo "  - Logs include timestamps for better tracking"
}

# Logging function with enhanced formatting
log() {
    local level="$1"
    local message="${*:2}"
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Define colors and icons based on log level
    case "$level" in
        "INFO") 
            local color="$INFO"
            local icon="ℹ️"
            ;;
        "WARN") 
            local color="$WARNING"
            local icon="⚠️ "
            ;;
        "ERROR") 
            local color="$ERROR"
            local icon="❌"
            ;;
        "SUCCESS") 
            local color="$SUCCESS"
            local icon="✅"
            ;;
        "DEBUG") 
            local color="$DEBUG"
            local icon="🐞"
            ;;
        *) 
            local color="$NC"
            local icon="➡️ "
            ;;
    esac
    
    # Format the output with colors and icons
    local log_message="${DIMTEXT}[${timestamp}] ${color}${icon} ${level}${NC}: ${message}${NC}"
    
    # Print to console
    if [ "$level" = "ERROR" ] || [ "$level" = "WARN" ]; then
        echo -e "$log_message" >&2
    else
        echo -e "$log_message"
    fi
    
    # Log to file (without colors and icons)
    if [ -n "$LOG_FILE" ]; then
        echo "[${timestamp}] $level: $message" >> "$LOG_FILE"
    fi
}

# Function to print section headers
print_header() {
    local title="$1"
    local color="${2:-$BLUE}"
    local width=60
    local padding=$(( (width - ${#title} - 2) / 2 ))
    local header=$(printf "%${padding}s" | tr ' ' '=')
    echo -e "\n${color}${header} ${BOLD}${WHITE}${title} ${color}${header}${NC}\n"
}

# Function to print a separator line
print_separator() {
    echo -e "${SEPARATOR}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Parse command line options
DRY_RUN=""
FORCE=false
while getopts "s:d:l:nfhm:" opt; do
    case $opt in
        s) SOURCE="$OPTARG" ;;
        d) DEST="$OPTARG" ;;
        l) LOG_FILE="$OPTARG" ;;
        n) DRY_RUN="--dry-run" ;;
        f) FORCE=true ;;
        m) SYNC_MODE="$OPTARG" ;;
        h) show_help; exit 0 ;;
        *) show_help; exit 1 ;;
    esac
done

# Ensure rsync is installed
if ! command_exists rsync; then
    log "ERROR" "rsync is required but not installed. Please install it first."
    exit 1
fi

# Create log directory if needed
if [ -n "$LOG_FILE" ]; then
    mkdir -p "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE" || {
        log "ERROR" "Cannot write to log file: $LOG_FILE"
        exit 1
    }
    log "INFO" "Logging to: $LOG_FILE"
fi

# Validate source and destination
log "INFO" "Validating source and destination directories..."

# Check source
if [ ! -d "$SOURCE" ]; then
    log "ERROR" "Source directory does not exist: $SOURCE"
    exit 1
fi

# Check source readability
if [ ! -r "$SOURCE" ]; then
    log "ERROR" "No read permission for source directory: $SOURCE"
    exit 1
fi

# Check destination
if [ ! -d "$DEST" ]; then
    log "WARN" "Destination directory does not exist, creating: $DEST"
    mkdir -p "$DEST" || {
        log "ERROR" "Failed to create destination directory: $DEST"
        exit 1
    }
fi

# Check destination writability
if [ ! -w "$DEST" ]; then
    log "ERROR" "No write permission for destination directory: $DEST"
    exit 1
fi

# Check if source and destination are the same
if [ "$(realpath "$SOURCE")" = "$(realpath "$DEST")" ]; then
    log "ERROR" "Source and destination directories are the same!"
    exit 1
fi

# Function to perform a sync
perform_sync() {
    local src="$1"
    local dst="$2"
    local direction="$3"
    local mirror_mode="$4"  # Whether to use --delete flag
    
    log "INFO" "Syncing ${HIGHLIGHT}${direction}${NC} from ${src} to ${dst}"
    
    # Common rsync options
    local RSYNC_OPTS=(
        -a  # archive mode
        -v  # verbose
        --progress
        --no-owner
        --no-group
        --no-perms
        --stats
        --human-readable
        --exclude='*.tmp'
        --exclude='*.temp'
        --exclude='.DS_Store'
        --exclude='Thumbs.db'
        --exclude='.Spotlight-V100'
        --exclude='.Trashes'
        --exclude='.fseventsd'
        --exclude='.sync_*'
        $DRY_RUN
    )
    
    # In mirror mode, use --delete to make destination identical to source
    if [ "$mirror_mode" = "true" ]; then
        RSYNC_OPTS+=(--delete)
        log "INFO" "${YELLOW}Mirror mode: Destination will be made identical to source${NC}"
    else
        RSYNC_OPTS+=(-u)  # Skip files that are newer on the receiver
        log "INFO" "${BLUE}Copy mode: Only copying new/updated files${NC}"
    fi
    
    RSYNC_CMD=(
        rsync
        "${RSYNC_OPTS[@]}"
        "$src"
        "$dst"
    )
    
    # Execute rsync and capture output
    local RSYNC_EXIT=0
    {
        echo "=== RSYNC ${direction} STARTED AT $(date) ==="
        echo "Command: ${RSYNC_CMD[*]}"
        echo
        "${RSYNC_CMD[@]}" || RSYNC_EXIT=$?
        echo
        echo "=== RSYNC ${direction} COMPLETED WITH EXIT CODE $RSYNC_EXIT ==="
    } 2>&1 | tee -a "$SYNC_LOG"
    
    return $RSYNC_EXIT
}

# Create a temporary file for tracking sync operations
SYNC_LOG=$(mktemp)
log "DEBUG" "Temporary sync log: $SYNC_LOG"

# Handle different sync modes
case "$SYNC_MODE" in
    "source-to-dest")
        log "INFO" "${BLUE}Copying files from source to destination...${NC}"
        perform_sync "$SOURCE/" "$DEST" "Source → Destination" "false"
        ;;
    "dest-to-source")
        log "INFO" "${BLUE}Copying files from destination to source...${NC}"
        perform_sync "$DEST/" "$SOURCE" "Destination → Source" "false"
        ;;
    "mirror-source")
        log "INFO" "${YELLOW}Making destination identical to source...${NC}"
        
        if [ -z "$DRY_RUN" ] && [ "$FORCE" != true ]; then
            echo -e "${RED}WARNING: Mirror mode will delete files in destination that don't exist in source.${NC}"
            read -p "Are you sure you want to continue? (y/N) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log "INFO" "Operation cancelled by user"
                exit 0
            fi
        fi
        
        perform_sync "$SOURCE/" "$DEST" "Source → Destination (mirror)" "true"
        ;;
    "mirror-dest")
        log "INFO" "${YELLOW}Making source identical to destination...${NC}"
        
        if [ -z "$DRY_RUN" ] && [ "$FORCE" != true ]; then
            echo -e "${RED}WARNING: Mirror mode will delete files in source that don't exist in destination.${NC}"
            read -p "Are you sure you want to continue? (y/N) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log "INFO" "Operation cancelled by user"
                exit 0
            fi
        fi
        
        perform_sync "$DEST/" "$SOURCE" "Destination → Source (mirror)" "true"
        ;;
    *)
        log "ERROR" "Unknown sync mode: $SYNC_MODE"
        show_help
        exit 1
        ;;
esac

# Calculate disk usage and file counts
log "INFO" "Calculating file statistics..."

# Get source stats
SOURCE_FILE_COUNT=$(find "$SOURCE" -type f 2>/dev/null | wc -l)
SOURCE_SIZE=$(du -sh "$SOURCE" 2>/dev/null | cut -f1) || SOURCE_SIZE="unknown"

# Get destination stats
DEST_FILE_COUNT_BEFORE=$(find "$DEST" -type f 2>/dev/null | wc -l)
DEST_SIZE_BEFORE=$(du -sh "$DEST" 2>/dev/null | cut -f1) || DEST_SIZE_BEFORE="unknown"

# Display stats
log "INFO" "Source: $SOURCE (${SOURCE_FILE_COUNT} files, ${SOURCE_SIZE})"
log "INFO" "Destination: $DEST (${DEST_FILE_COUNT_BEFORE} files, ${DEST_SIZE_BEFORE})"

# Check available disk space
if command_exists df; then
    DEST_FREE_SPACE=$(df -h "$DEST" | awk 'NR==2 {print $4}')
    log "INFO" "Free space in destination: $DEST_FREE_SPACE"
fi
if [ -n "$DRY_RUN" ]; then
    log "WARN" "DRY RUN - No files will be modified"
fi

# Execute rsync and capture output
SYNC_LOG=$(mktemp)
log "INFO" "Temporary log file: $SYNC_LOG"

# Run rsync with progress
{
    echo "=== RSYNC STARTED AT $(date) ==="
    echo "Command: ${RSYNC_CMD[*]}"
    echo
    "${RSYNC_CMD[@]}"
    RSYNC_EXIT=$?
    echo
    echo "=== RSYNC COMPLETED WITH EXIT CODE $RSYNC_EXIT ==="
} 2>&1 | tee "$SYNC_LOG"

# Process rsync output
NEW_FILES_COPIED=$(grep -c '^>f' "$SYNC_LOG" || true)
FILES_UPDATED=$(grep -c '^>f[^.]' "$SYNC_LOG" || true)
FILES_VERIFIED=$(grep -c '^\.f' "$SYNC_LOG" || true)
FILES_DELETED=$(grep -c '^\*deleting' "$SYNC_LOG" || true)

# If not dry run, verify the sync
if [ -z "$DRY_RUN" ]; then
    # Get updated destination stats
    DEST_FILE_COUNT_AFTER=$(find "$DEST" -type f 2>/dev/null | wc -l)
    DEST_SIZE_AFTER=$(du -sh "$DEST" 2>/dev/null | cut -f1) || DEST_SIZE_AFTER="unknown"
    
    # Calculate files added
    FILES_ADDED=$((DEST_FILE_COUNT_AFTER - DEST_FILE_COUNT_BEFORE + FILES_DELETED))
    
    log "INFO" "Destination after sync: ${DEST_FILE_COUNT_AFTER} files, ${DEST_SIZE_AFTER}"
    log "INFO" "Files processed: ${NEW_FILES_COPIED} (${FILES_ADDED} added, ${FILES_UPDATED} updated, ${FILES_VERIFIED} verified, ${FILES_DELETED} deleted)"
fi

# Clean up log file
if [ -f "$SYNC_LOG" ]; then
    if [ -n "$LOG_FILE" ]; then
        cat "$SYNC_LOG" >> "$LOG_FILE"
    fi
    rm -f "$SYNC_LOG"
fi

# Show summary
print_header "SYNC SUMMARY" "$CYAN"

if [ -z "$DRY_RUN" ]; then
    if [ "$TWO_WAY_SYNC" = true ]; then
        log "SUCCESS" "${BOLD}Two-way synchronization completed successfully!"
    else
        log "SUCCESS" "${BOLD}One-way synchronization completed successfully!"
    fi
    echo -e "\n${HIGHLIGHT}📊 Source:${NC} ${SOURCE_FILE_COUNT} files, ${GREEN}${BOLD}${SOURCE_SIZE}${NC}"
    echo -e "${HIGHLIGHT}📁 Destination:${NC} ${DEST_FILE_COUNT_AFTER} files, ${GREEN}${BOLD}${DEST_SIZE_AFTER}${NC}"
    
    # Show file operation stats
    echo -e "\n${UNDERLINE}File Operations:${NC}"
    echo -e "${GREEN}✓ Added:   ${FILES_ADDED}${NC}"
    echo -e "${BLUE}↻ Updated: ${FILES_UPDATED}${NC}"
    echo -e "${CYAN}✓ Verified: ${FILES_VERIFIED}${NC}"
    
    # Calculate sync statistics
    if [ "$DEST_FILE_COUNT_BEFORE" -gt 0 ]; then
        print_separator
        echo -e "${HIGHLIGHT}📈 File Count Change:${NC}"
        echo -e "  Before: ${DIMTEXT}${DEST_FILE_COUNT_BEFORE}${NC}"
        echo -e "  After:  ${GREEN}${BOLD}${DEST_FILE_COUNT_AFTER}${NC} (${GREEN}+$((DEST_FILE_COUNT_AFTER - DEST_FILE_COUNT_BEFORE))${NC})"
        
        if command -v bc >/dev/null 2>&1; then
            PERCENT_INCREASE=$(echo "scale=2; (($DEST_FILE_COUNT_AFTER - $DEST_FILE_COUNT_BEFORE) / $DEST_FILE_COUNT_BEFORE) * 100" | bc 2>/dev/null)
            if [ -n "$PERCENT_INCREASE" ]; then
                # Color code percentage based on value
                if (( $(echo "$PERCENT_INCREASE > 0" | bc -l) )); then
                    PERCENT_COLOR="${GREEN}▲"
                elif (( $(echo "$PERCENT_INCREASE < 0" | bc -l) )); then
                    PERCENT_COLOR="${RED}▼"
                else
                    PERCENT_COLOR="${BLUE}●"
                fi
                echo -e "  Change: ${PERCENT_COLOR} ${PERCENT_INCREASE}%${NC}"
            fi
        fi
    fi
else
    print_header "DRY RUN SUMMARY" "$YELLOW"
    log "WARN" "${BOLD}No files were actually synchronized (dry run)"
    echo -e "\n${HIGHLIGHT}📋 Files that would be processed:${NC} ${YELLOW}${BOLD}${NEW_FILES_COPIED}${NC}"
    echo -e "${DIMTEXT}Source:      ${SOURCE}${NC}"
    echo -e "${DIMTEXT}Destination: ${DEST}${NC}"
fi

# Final status
if [ -n "$LOG_FILE" ]; then
    print_separator
    echo -e "${DIMTEXT}📝 Detailed log saved to: ${UNDERLINE}${LOG_FILE}${NC}"
fi

# Add a nice footer
print_separator
echo -e "${DIMTEXT}✨ ${BOLD}Sync completed at $(date +"%Y-%m-%d %H:%M:%S")${NC} ${DIMTEXT}✨${NC}"
print_separator

exit 0
