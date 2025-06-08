#!/bin/bash

# Model Cleanup Script - Proxmox Container Edition
# Simplified version specifically for Proxmox containers
# Scans directories for duplicate model files

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Function to prompt for directory with validation
prompt_directory() {
    local prompt="$1"
    local dir=""
    while true; do
        read -p "$prompt" dir
        if [ -d "$dir" ]; then
            echo "$dir"
            return 0
        else
            echo -e "${RED}Error: '$dir' is not a valid directory.${NC}"
        fi
    done
}

# Function to find model files recursively
find_model_files() {
    local search_dir="$1"
    find "$search_dir" -type f \( -name "*.safetensors" -o -name "*.ckpt" -o -name "*.pt" -o -name "*.pth" -o -name "*.bin" -o -name "*.gguf" \) 2>/dev/null
}

# Format time in human-readable format
format_time() {
    local seconds=$1
    local hours=$((seconds / 3600))
    local minutes=$(((seconds % 3600) / 60))
    local secs=$((seconds % 60))
    
    if ((hours > 0)); then
        printf "%dh %dm %ds" $hours $minutes $secs
    elif ((minutes > 0)); then
        printf "%dm %ds" $minutes $secs
    else
        printf "%ds" $secs
    fi
}

# Simple progress display
display_progress() {
    local current=$1
    local total=$2
    local percentage=$((current * 100 / total))
    printf "\rProcessing: %d/%d files (%d%%)" "$current" "$total" "$percentage"
}

# Get target directory
if [ -z "$1" ]; then
    target_dir=$(prompt_directory "Enter directory to scan for model files: ")
else
    if [ -d "$1" ]; then
        target_dir="$1"
    else
        echo -e "${RED}Error: '$1' is not a valid directory.${NC}"
        exit 1
    fi
fi

# Create temporary file
TMPFILE=$(mktemp)

# Count total files
echo -e "\n${YELLOW}=== Scanning for Model Files ===${NC}"
echo -e "${BLUE}Scanning directory:${NC} $target_dir"
echo -e "${BLUE}File types:${NC} .safetensors, .ckpt, .pt, .pth, .bin, .gguf"

# Count files first
total_files=$(find_model_files "$target_dir" | wc -l)

# Start timer
START_TIME=$(date +%s)

echo -e "\n${YELLOW}=== Calculating MD5 Checksums ===${NC}"
echo -e "${BLUE}Purpose:${NC} Finding duplicate files by content"
echo -e "${BLUE}Total files to process:${NC} $total_files"
echo -e "${BLUE}Estimated time:${NC} ~$(( total_files / 20 + 1 )) minutes (depends on file sizes)"
echo -e "${YELLOW}Starting checksum calculation...${NC}"

# Initialize counters
current_file=0
total_size=0
largest_file=0
largest_name=""
checksum_start=$(date +%s)

# Process each file
echo -e "\n${YELLOW}Processing files...${NC}"
# Use process substitution to avoid subshell issues with variables
while IFS= read -r file; do
    current_file=$((current_file + 1))
    
    # Get file size using du (disk usage) which is more reliable in containers
    if [ -f "$file" ]; then
        # Get size in bytes (-b) for a single file
        file_size=$(du -b "$file" 2>/dev/null | cut -f1)
        file_size=${file_size:-0} # Default to 0 if empty
        total_size=$((total_size + file_size))
    else
        file_size=0
    fi
    
    # Track largest file
    if (( file_size > largest_file )); then
        largest_file=$file_size
        largest_name="$file"
    fi
    
    # Show simple progress
    if (( current_file % 5 == 0 )); then
        display_progress "$current_file" "$total_files"
    fi
    
    # Calculate MD5 and append to file
    if [ -f "$file" ]; then
        md5sum "$file" >> "$TMPFILE"
    fi
done < <(find_model_files "$target_dir")

# Clear the progress line
echo

# Calculate average file size
avg_size=$((total_size / (total_files > 0 ? total_files : 1)))

# Calculate elapsed time
END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo -e "\n${GREEN}✓ Scan Complete!${NC}"
echo -e "${YELLOW}Total Files Processed:${NC} $total_files"
echo -e "${YELLOW}Scan Duration:${NC} $(format_time $ELAPSED)"
# Calculate files per second with better precision
if [ $ELAPSED -gt 0 ]; then
    files_per_second=$(($total_files / $ELAPSED))
    echo -e "${YELLOW}Average Speed:${NC} $files_per_second files/second"
else
    echo -e "${YELLOW}Average Speed:${NC} $total_files files/second (less than 1 second)"
fi
echo -e "${YELLOW}Total Size:${NC} $(human_size $total_size)"
echo -e "${YELLOW}Average File Size:${NC} $(human_size $avg_size)"
echo -e "${YELLOW}Largest File:${NC} $(basename "$largest_name") ($(human_size $largest_file))"

# Find duplicates
echo -e "\n${YELLOW}Finding duplicates...${NC}"
if [ -s "$TMPFILE" ]; then
    duplicates=$(sort "$TMPFILE" | uniq -w32 --all-repeated=separate)
else
    duplicates=""
fi

if [ -z "$duplicates" ]; then
    echo -e "${GREEN}No duplicates found!${NC}"
    rm "$TMPFILE"
    exit 0
fi

# Process duplicates
echo -e "\n${YELLOW}Found the following duplicate groups:${NC}"
echo "================================="

declare -A processed_groups
group_num=0
total_duplicates=0
total_size_saved=0

# First pass: group duplicates
while IFS= read -r line; do
    if [[ "$line" == "" ]]; then
        group_num=$((group_num + 1))
        continue
    fi
    
    if [ -z "${processed_groups[$group_num]}" ]; then
        processed_groups[$group_num]=1
        eval "group_${group_num}_files=()"
        eval "group_${group_num}_size=0"
    fi
    
    # Extract filename, handling different md5sum output formats
    if [[ "$line" =~ ^[0-9a-f]{32}[[:space:]]+ ]]; then
        # Standard md5sum output
        file="${line:34}" # Skip the MD5 hash and two spaces
    else
        # Alternative format
        file="$(echo "$line" | cut -d' ' -f3-)"
    fi
    eval "group_${group_num}_files+=(\"$file\")"
    
    # Get file size using du
    if [ -f "$file" ]; then
        file_size=$(du -b "$file" 2>/dev/null | cut -f1)
        file_size=${file_size:-0} # Default to 0 if empty
    else
        file_size=0
    fi
    
    # Fix variable substitution for group size
    group_var="group_${group_num}_size"
    current_size=$(eval echo "\${$group_var}")
    eval "$group_var=$((current_size + file_size))"
    
    total_duplicates=$((total_duplicates + 1))
    total_size_saved=$((total_size_saved + file_size))
    
done <<< "$duplicates"

# Show duplicates
for ((i=1; i<=group_num; i++)); do
    eval "files=(\"\${group_${i}_files[@]}\")"
    eval "group_size=\${group_${i}_size}"
    
    if [ ${#files[@]} -eq 0 ]; then
        continue
    fi
    
    echo -e "\n${YELLOW}Group $i (Potential space saved: $(human_size $((group_size - group_size / ${#files[@]}))))${NC}"
    for ((j=0; j<${#files[@]}; j++)); do
        file_size=$(stat -c %s "${files[$j]}" 2>/dev/null)
        echo "  [$((j+1))] ${files[$j]} ($(human_size $file_size))"
    done
done

# Ask user what to do
echo -e "\n${YELLOW}What would you like to do?${NC}"
echo "1. Keep first file in each group, remove others"
echo "2. Keep newest file in each group, remove others"
echo "3. Keep file in shortest path, remove others"
echo "4. Keep file in longest path, remove others"
echo "5. Create hard links instead of removing duplicates"
echo "6. Create symbolic links instead of removing duplicates"
echo "7. Do nothing and exit"
read -p "Enter your choice (1-7): " choice

case $choice in
    1) action="keep_first" ;;
    2) action="keep_newest" ;;
    3) action="keep_shortest_path" ;;
    4) action="keep_longest_path" ;;
    5) action="hardlink" ;;
    6) action="symlink" ;;
    *) echo "Exiting without making changes."; rm "$TMPFILE"; exit 0 ;;
esac

# Process the duplicates
for ((i=1; i<=group_num; i++)); do
    eval "files=(\"\${group_${i}_files[@]}\")"
    if [ ${#files[@]} -eq 0 ]; then
        continue
    fi
    
    echo -e "\n${YELLOW}Processing group $i:${NC}"
    
    # Determine which file to keep
    case $action in
        "keep_first")
            keep_index=0
            keep_reason="first file"
            ;;
        "keep_newest")
            newest=0
            newest_time=0
            for ((j=0; j<${#files[@]}; j++)); do
                file_time=$(stat -c %Y "${files[$j]}" 2>/dev/null)
                if ((file_time > newest_time)); then
                    newest_time=$file_time
                    newest=$j
                fi
            done
            keep_index=$newest
            keep_reason="newest file"
            ;;
        "keep_shortest_path")
            shortest=0
            shortest_length=${#files[0]}
            for ((j=1; j<${#files[@]}; j++)); do
                if ((${#files[$j]} < shortest_length)); then
                    shortest_length=${#files[$j]}
                    shortest=$j
                fi
            done
            keep_index=$shortest
            keep_reason="shortest path"
            ;;
        "keep_longest_path")
            longest=0
            longest_length=${#files[0]}
            for ((j=1; j<${#files[@]}; j++)); do
                if ((${#files[$j]} > longest_length)); then
                    longest_length=${#files[$j]}
                    longest=$j
                fi
            done
            keep_index=$longest
            keep_reason="longest path"
            ;;
        *)
            keep_index=0
            keep_reason="first file"
            ;;
    esac
    
    # Show which file we're keeping
    echo -e "${GREEN}Keeping ${keep_reason}:${NC} ${files[$keep_index]}"
    
    # Process other files
    for ((j=0; j<${#files[@]}; j++)); do
        if ((j == keep_index)); then
            continue
        fi
        
        current_file="${files[$j]}"
        # Get file size using du
        if [ -f "$current_file" ]; then
            file_size=$(du -b "$current_file" 2>/dev/null | cut -f1)
            file_size=${file_size:-0} # Default to 0 if empty
        else
            file_size=0
        fi
        
        case $action in
            "hardlink")
                echo -n "Creating hard link for: $current_file... "
                rm "$current_file" && ln "${files[$keep_index]}" "$current_file" && echo -e "${GREEN}Done${NC}" || echo -e "${RED}Failed${NC}"
                ;;
            "symlink")
                echo -n "Creating symbolic link for: $current_file... "
                rm "$current_file" && ln -s "${files[$keep_index]}" "$current_file" && echo -e "${GREEN}Done${NC}" || echo -e "${RED}Failed${NC}"
                ;;
            *)
                echo -n "Removing: $current_file ($(human_size $file_size))... "
                rm "$current_file" && echo -e "${GREEN}Done${NC}" || echo -e "${RED}Failed${NC}"
                ;;
        esac
    done
done

# Clean up
rm "$TMPFILE"

echo -e "\n${GREEN}Cleanup complete!${NC}"
