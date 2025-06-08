#!/bin/bash

# Model Cleanup Script - Proxmox Container Edition
# Simplified version for Proxmox containers
# Scans all subdirectories for duplicate model files

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
    local dir
    while true; do
        read -p "$prompt: " dir
        dir="${dir/#\~/$HOME}"  # Expand ~ to home directory
        if [ -d "$dir" ]; then
            echo "$(realpath "$dir")"  # Return absolute path
            return 0
        else
            echo -e "${RED}Error: Directory does not exist. Please try again.${NC}"
            read -p "Would you like to create this directory? (y/n): " create_dir
            if [[ "$create_dir" =~ ^[Yy]$ ]]; then
                mkdir -p "$dir" && echo -e "${GREEN}Created directory: $dir${NC}" && echo "$(realpath "$dir")" && return 0
            fi
        fi
    done
}

# Function to find all model files recursively
find_model_files() {
    local dir="$1"
    find "$dir" -type f \( -name "*.safetensors" -o -name "*.ckpt" -o -name "*.pt" -o -name "*.pth" -o -name "*.bin" -o -name "*.gguf" \) 2>/dev/null
}

# Main script
echo -e "\n${YELLOW}=== Model Cleanup Script ===${NC}"
echo "This script will help you find and remove duplicate model files recursively."
echo -e "${YELLOW}Please enter the directory to scan for model files:${NC}"

target_dir=$(prompt_directory "Enter directory to scan (e.g., /mnt/models):")

# Create a temporary file for storing checksums
TMPFILE=$(mktemp)

# Start timer
START_TIME=$(date +%s)

# Function to display simple progress
display_progress() {
    local current=$1
    local total=$2
    local percentage=$((current * 100 / total))
    
    # Simple progress indicator
    printf "\rProcessing: %d/%d files (%d%%)" "$current" "$total" "$percentage"
}

# Function to format time
format_time() {
    local seconds=$1
    local minutes=$((seconds / 60))
    local hours=$((minutes / 60))
    
    seconds=$((seconds % 60))
    minutes=$((minutes % 60))
    
    if ((hours > 0)); then
        printf "%dh %dm %ds" $hours $minutes $seconds
    elif ((minutes > 0)); then
        printf "%dm %ds" $minutes $seconds
    else
        printf "%ds" $seconds
    fi
}

# Find all model files and calculate checksums
echo -e "\n${YELLOW}=== Starting Model File Scan ===${NC}"
echo -e "${YELLOW}Directory:${NC} $target_dir"
echo -e "${YELLOW}File Types:${NC} .safetensors, .ckpt, .pt, .pth, .bin, .gguf"
echo -e "${YELLOW}Scanning all subdirectories...${NC}"
echo -e "${YELLOW}This might take a while for large directories.${NC}"

# Count total files first for progress
echo -e "${YELLOW}Counting files...${NC}"
total_files=$(find_model_files "$target_dir" | wc -l)
echo -e "Found ${GREEN}$total_files${NC} model files to process."

if [ "$total_files" -eq 0 ]; then
    echo -e "${RED}No model files found in the specified directory.${NC}"
    rm "$TMPFILE"
    exit 1
fi

echo -e "\n${YELLOW}=== Calculating MD5 Checksums ===${NC}"
echo -e "${BLUE}Purpose:${NC} Finding duplicate files by content (not just filename)"
echo -e "${BLUE}Method:${NC} MD5 hash calculation for each file"
echo -e "${BLUE}Total files to process:${NC} $total_files"
echo -e "${BLUE}Estimated time:${NC} ~$(( total_files / 20 + 1 )) minutes (depends on file sizes)"
echo -e "${YELLOW}Starting checksum calculation...${NC}"
echo -e "${BLUE}Progress:${NC}"

# Initialize counters
current_file=0
total_size=0
largest_file=0
largest_name=""
checksum_start=$(date +%s)

# Process each file
echo -e "\n${YELLOW}Processing files...${NC}"
find_model_files "$target_dir" | while read -r file; do
    current_file=$((current_file + 1))
    
    # Get file size
    file_size=$(stat -c %s "$file" 2>/dev/null)
    total_size=$((total_size + file_size))
    
    # Track largest file
    if (( file_size > largest_file )); then
        largest_file=$file_size
        largest_name="$file"
    fi
    
    # Show simple progress
    if (( current_file % 10 == 0 )); then
        display_progress "$current_file" "$total_files"
    fi
    
    # Calculate MD5 and append to file
    md5sum "$file" 2>/dev/null >> "$TMPFILE"
done

# Clear the progress line
echo

# Clear the progress display lines
echo -en "\n\n"

# Calculate average file size
avg_size=$((total_size / (total_files > 0 ? total_files : 1)))

# Calculate elapsed time
END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo -e "\n\n${GREEN}✓ Scan Complete!${NC}"
echo -e "${YELLOW}Total Files Processed:${NC} $total_files"
echo -e "${YELLOW}Scan Duration:${NC} $(format_time $ELAPSED)"
echo -e "${YELLOW}Average Speed:${NC} $(($total_files / ($ELAPSED > 0 ? $ELAPSED : 1))) files/second"
echo -e "${YELLOW}Total Size:${NC} $(human_size $total_size)"
echo -e "${YELLOW}Average File Size:${NC} $(human_size $avg_size)"
echo -e "${YELLOW}Largest File:${NC} $(basename "$largest_name") ($(human_size $largest_file))"

# Find duplicates
echo -e "\n${YELLOW}Finding duplicates...${NC}"
# Find duplicates using GNU uniq (standard on Linux)
duplicates=$(sort "$TMPFILE" | uniq -w32 --all-repeated=separate)

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
    
    file="${line:33}"
    eval "group_${group_num}_files+=(\"$file\")"
    
    # Use different stat formats for Linux vs macOS
    if [[ "$(uname)" == "Darwin" ]]; then
        file_size=$(stat -f%z "$file")
    else
        file_size=$(stat -c %s "$file")
    fi
    # Fix variable substitution for group size
    group_var="group_${group_num}_size"
    current_size=$(eval echo "\${$group_var}")
    eval "$group_var=$((current_size + file_size))"
    total_duplicates=$((total_duplicates + 1))
    total_size_saved=$((total_size_saved + file_size))
    
done <<< "$duplicates"

# Moving this function to the top of the script for availability

# Show duplicates
for ((i=1; i<=group_num; i++)); do
    eval "files=(\"\${group_${i}_files[@]}\")"
    eval "group_size=\${group_${i}_size}"
    
    if [ ${#files[@]} -eq 0 ]; then
        continue
    fi
    
    echo -e "\n${YELLOW}Group $i (Potential space saved: $(human_size $((group_size - group_size / ${#files[@]}))))${NC}"
    for ((j=0; j<${#files[@]}; j++)); do
        # Get file size (Linux format)
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
                file_time=$(stat -c %Y "${files[$j]}" 2>/dev/null || stat -f %m "${files[$j]}")
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
            # For symlink/hardlink, keep the first file and link others to it
            keep_index=0
            keep_reason="first file (linking others)"
            ;;
    esac
    
    keep_file="${files[$keep_index]}"
    echo "  Keeping: $keep_file ($keep_reason)"
    
    # Process other files in the group
    for ((j=0; j<${#files[@]}; j++)); do
        if [ $j -eq $keep_index ]; then
            continue
        fi
        
        current_file="${files[$j]}"
        # Get file size (Linux format)
        file_size=$(stat -c %s "$current_file" 2>/dev/null)
        
        case $action in
            "hardlink")
                echo "  Creating hard link: $current_file -> $keep_file"
                rm -f "$current_file"
                ln "$keep_file" "$current_file"
                ;;
            "symlink")
                echo "  Creating symbolic link: $current_file -> $keep_file"
                rm -f "$current_file"
                ln -s "$keep_file" "$current_file"
                ;;
            *)
                echo "  Removing: $current_file ($(human_size $file_size))"
                rm -f "$current_file"
                ;;
        esac
    done
done

# Cleanup
rm "$TMPFILE"
echo -e "\n${GREEN}Cleanup complete!${NC}"
echo -e "Total duplicates processed: $((total_duplicates - group_num))"
echo -e "${YELLOW}Estimated space saved:${NC} $(human_size $((total_size_saved - (total_size_saved / (total_duplicates > 0 ? total_duplicates : 1) * (group_num > 0 ? group_num : 1)))))"
echo -e "\n${GREEN}Thank you for using the Model Cleanup Script!${NC}"
echo -e "Estimated space saved: $(human_size $((total_size_saved - (total_size_saved / (group_num > 0 ? group_num : 1) * (group_num > 0 ? group_num : 1)))))${NC}"