#!/bin/bash

# Find Duplicates Script - Proxmox Container Edition
# Optimized for Proxmox environments to find duplicate files

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print in color
print_yellow() {
    echo -e "${YELLOW}$1${NC}"
}

print_green() {
    echo -e "${GREEN}$1${NC}"
}

print_red() {
    echo -e "${RED}$1${NC}"
}

print_blue() {
    echo -e "${BLUE}$1${NC}"
}

# Human-readable size function
human_size() {
    local bytes=$1
    local unit=0
    local units=("B" "KB" "MB" "GB" "TB")
    while ((bytes > 1024)) && ((unit < ${#units[@]} - 1)); do
        bytes=$((bytes / 1024))
        unit=$((unit + 1))
    done
    echo "$bytes ${units[$unit]}"
}

# Default values
DIRECTORY="."
MIN_SIZE="100M"
TEMP_FILE="/tmp/duplicate_search_$$.txt"

# Help function
show_help() {
    echo "Usage: $0 [OPTIONS] DIRECTORY"
    echo "Find duplicate files in specified directory"
    echo
    echo "Options:"
    echo "  -s SIZE       Minimum file size to check (default: 100M)"
    echo "                Examples: 1G, 100M, 50K"
    echo "  -h            Show this help message"
    echo
    echo "Example:"
    echo "  $0 -s 1G /path/to/directory"
}

# Parse command line options
while getopts "s:h" opt; do
    case $opt in
        s) MIN_SIZE="$OPTARG";;
        h) show_help; exit 0;;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
    esac
done

# Remove the options from the positional parameters
shift $((OPTIND-1))

# Get directory from command line or use default
if [ $# -gt 0 ]; then
    DIRECTORY="$1"
fi

# Check if directory exists
if [ ! -d "$DIRECTORY" ]; then
    print_red "Error: Directory '$DIRECTORY' does not exist"
    exit 1
fi

# Cleanup function
cleanup() {
    rm -f "$TEMP_FILE"
}

# Set cleanup on script exit
trap cleanup EXIT

print_yellow "Searching for files larger than $MIN_SIZE in $DIRECTORY..."
print_yellow "This may take a while for large directories..."
echo

# First count total files to process
print_yellow "Counting files..."
TOTAL_FILES=$(find "$DIRECTORY" -type f -size "+$MIN_SIZE" | wc -l)
print_yellow "Found $TOTAL_FILES files to process"
echo

# Show list of files that will be checked
print_yellow "Files to check (sorted by size):"
echo -e "${BLUE}SIZE\tFILE${NC}"
find "$DIRECTORY" -type f -size "+$MIN_SIZE" -exec ls -lh {} \; | \
    sort -rh -k5 | \
    awk '{printf "%s\t%s\n", $5, $9}'
echo

# Start timer
START_TIME=$(date +%s)

# Find files and calculate their hashes with progress
print_yellow "Calculating file hashes..."
COUNTER=0

# Process each file and calculate MD5
find "$DIRECTORY" -type f -size "+$MIN_SIZE" -print0 | while IFS= read -r -d '' file; do
    COUNTER=$((COUNTER + 1))
    PROGRESS=$((COUNTER * 100 / TOTAL_FILES))
    
    # Simple progress display that updates every 5 files
    if (( COUNTER % 5 == 0 || COUNTER == TOTAL_FILES )); then
        printf "\rProcessing file %d/%d (%d%%)" "$COUNTER" "$TOTAL_FILES" "$PROGRESS"
    fi
    
    # Calculate MD5 and write directly to temp file
    md5sum "$file" >> "$TEMP_FILE"
done

# Clear the progress line
echo
echo

# Calculate elapsed time
END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
MINUTES=$((ELAPSED / 60))
SECONDS=$((ELAPSED % 60))

print_green "Hash calculation complete in ${MINUTES}m ${SECONDS}s"
echo

# Find and display duplicates
print_yellow "Analyzing results..."
echo

# Create a temporary file for sorted results
SORTED_FILE="/tmp/sorted_duplicates_$$.txt"

# Sort by MD5 hash
sort "$TEMP_FILE" > "$SORTED_FILE"

# Find duplicate hashes
declare -A hash_count
declare -A hash_files
declare -A hash_size

while read -r line; do
    hash=$(echo "$line" | awk '{print $1}')
    file=$(echo "$line" | cut -d' ' -f3-)
    
    # Count occurrences of each hash
    if [ -z "${hash_count[$hash]}" ]; then
        hash_count[$hash]=1
        hash_files[$hash]="$file"
    else
        hash_count[$hash]=$((hash_count[$hash] + 1))
        hash_files[$hash]="${hash_files[$hash]}|$file"
    fi
    
    # Get file size only once per hash
    if [ -z "${hash_size[$hash]}" ]; then
        size=$(stat -c %s "$file" 2>/dev/null)
        hash_size[$hash]=$size
    fi
done < "$SORTED_FILE"

# Display duplicates
echo -e "${BLUE}SIZE\tMD5\tFILES${NC}"

# Sort hashes by file size (largest first)
for hash in "${!hash_count[@]}"; do
    if [ "${hash_count[$hash]}" -gt 1 ]; then
        echo "$hash ${hash_size[$hash]}" 
    fi
done | sort -k2 -nr | while read -r hash size; do
    # Display human-readable size
    hr_size=$(human_size "$size")
    
    # Display hash
    echo -e "${hr_size}\t${hash}"
    
    # Display files
    IFS='|' read -ra files <<< "${hash_files[$hash]}"
    for file in "${files[@]}"; do
        echo -e "\t\t$file"
    done
    echo
done

# Clean up
rm -f "$SORTED_FILE"

print_green "Duplicate analysis complete!"
