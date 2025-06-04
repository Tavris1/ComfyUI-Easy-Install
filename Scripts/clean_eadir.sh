#!/bin/bash

# Function to print in color
print_yellow() {
    echo -e "\033[33m$1\033[0m"
}

print_red() {
    echo -e "\033[31m$1\033[0m"
}

print_green() {
    echo -e "\033[32m$1\033[0m"
}

# Show mounted drives
print_yellow "=== Mounted Drives ===="
df -h | grep -v tmpfs | grep -v devfs
echo

# Check if a path is provided
if [ $# -eq 0 ]; then
    print_red "Please provide the path to your USB drive as an argument"
    echo "Usage: $0 /path/to/usb/drive"
    exit 1
fi

USB_PATH="$1"

# Check if the path exists
if [ ! -d "$USB_PATH" ]; then
    print_red "Error: Directory $USB_PATH does not exist"
    exit 1
fi

# Find all eaDir directories, including hidden ones
print_yellow "Searching for eaDir directories in $USB_PATH..."
EADIR_LIST=$(find "$USB_PATH" -type d -name "@eaDir" 2>/dev/null)

# Check if any @eaDir directories were found
if [ -z "$EADIR_LIST" ]; then
    print_green "No @eaDir directories found."
    exit 0
fi

# Count and display found directories
COUNT=$(echo "$EADIR_LIST" | wc -l)
print_yellow "Found $COUNT @eaDir directories:"
echo "$EADIR_LIST"

# Ask for confirmation
read -p "Do you want to remove these @eaDir directories? (y/N) " confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
    print_yellow "Removing @eaDir directories..."
    echo "$EADIR_LIST" | while read dir; do
        if rm -rf "$dir"; then
            print_green "Removed: $dir"
        else
            print_red "Failed to remove: $dir"
        fi
    done
    print_green "Cleanup complete!"
else
    print_yellow "Operation cancelled. No directories were removed."
fi
