#!/bin/bash

# Function to print in color
print_yellow() {
    echo -e "\033[33m$1\033[0m"
}

print_green() {
    echo -e "\033[32m$1\033[0m"
}

print_red() {
    echo -e "\033[31m$1\033[0m"
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
    echo "  -h           Show this help message"
    echo
    echo "Example:"
    echo "  $0 -s 1G /path/to/directory"
    echo
    echo "Example output:"
    echo -e "${GREEN}Found duplicates:${NC}"
    echo
    echo "SIZE    MD5                              FILES"
    echo "4.2G    e7d8f9a2b1c3...  /mnt/models/model1.safetensors"
    echo "                        /mnt/backup/model1_copy.safetensors"
    echo
    echo "2.1G    a1b2c3d4e5f6...  /mnt/models/sd15_base.ckpt"
    echo "                        /mnt/old/sd15.ckpt"
    echo "                        /mnt/backup/sd15_backup.ckpt"
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
    rm -rf "$TEMP_DIR" 2>/dev/null
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

# Show list of files that will be checked
print_yellow "\nFiles to check (sorted by size):"
echo "SIZE\tFILE"
find "$DIRECTORY" -type f -size "+$MIN_SIZE" -exec ls -lh {} \; | \
    sort -rh -k5 | \
    awk '{printf "%s\t%s\n", $5, $9}'
echo

# Create a temporary directory for progress tracking
TEMP_DIR=$(mktemp -d)
TEMP_HASHES="$TEMP_DIR/hashes.txt"

# Find files and calculate their hashes with progress
print_yellow "Calculating file hashes..."
COUNTER=0
find "$DIRECTORY" -type f -size "+$MIN_SIZE" -print0 | while IFS= read -r -d '' file; do
    COUNTER=$((COUNTER + 1))
    PROGRESS=$((COUNTER * 100 / TOTAL_FILES))
    printf "\rProcessing file %d/%d (%d%%) - %s" "$COUNTER" "$TOTAL_FILES" "$PROGRESS" "$(basename "$file")"
    md5sum "$file" >> "$TEMP_HASHES"
done
echo

# Move results to final location
mv "$TEMP_HASHES" "$TEMP_FILE"
rm -rf "$TEMP_DIR"

print_green "Found duplicates (sorted by size):"
echo

# Sort by MD5 hash and find duplicates
print_yellow "\nAnalyzing results..."
echo "SIZE    MD5     FILES"

# Create a temporary file for duplicate groups
DUP_GROUPS="/tmp/duplicate_groups_$$.txt"

# Find duplicates and write to temporary file
sort "$TEMP_FILE" | awk '
    {
        hash = $1
        file = substr($0, index($0, $2))
        files[hash] = files[hash] ? files[hash] "\n" file : file
        count[hash]++
    }
    END {
        for (hash in files) {
            if (count[hash] > 1) {
                print hash "\t" files[hash]
            }
        }
    }
' > "$DUP_GROUPS"

# Process each duplicate group in Bash
while IFS=$'\t' read -r hash files; do
    # Get first file that exists and its size
    size="N/A"
    first_file=""
    
    # Read each file path
    echo "$files" | while IFS= read -r file; do
        if [[ -n "$file" && -f "$file" ]]; then
            # Get size of first existing file
            size=$(ls -lh "$file" | awk '{print $5}')
            first_file="$file"
            break
        fi
    done
    
    # Print the duplicate group
    echo "$size    $hash        $files" | sed 's/^/        /;s/\n/\n\t\t/g'
    echo
    
done < "$DUP_GROUPS"

# Clean up
rm -f "$DUP_GROUPS"
