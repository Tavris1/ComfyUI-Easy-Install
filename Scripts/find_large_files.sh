#!/bin/bash

# Function to print in color
print_yellow() {
    echo -e "\033[33m$1\033[0m"
}

print_green() {
    echo -e "\033[32m$1\033[0m"
}

# Default values
DIRECTORY="."
NUM_FILES=20
MIN_SIZE="100M"

# Help function
show_help() {
    echo "Usage: $0 [OPTIONS] DIRECTORY"
    echo "Find largest files in specified directory"
    echo
    echo "Options:"
    echo "  -n NUMBER     Show top NUMBER files (default: 20)"
    echo "  -s SIZE       Minimum file size (default: 100M)"
    echo "                Examples: 1G, 100M, 50K"
    echo "  -h           Show this help message"
    echo
    echo "Example:"
    echo "  $0 -n 10 -s 1G /path/to/directory"
}

# Parse command line options
while getopts "n:s:h" opt; do
    case $opt in
        n) NUM_FILES="$OPTARG";;
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
    echo "Error: Directory '$DIRECTORY' does not exist"
    exit 1
fi

print_yellow "Searching for files larger than $MIN_SIZE in $DIRECTORY..."
print_yellow "This may take a while for large directories..."
echo

# Find and sort files
print_green "Top $NUM_FILES largest files:"
find "$DIRECTORY" -type f -size "+$MIN_SIZE" -exec ls -lh {} \; | \
    sort -rh -k5 | \
    head -n "$NUM_FILES" | \
    awk '{printf "%s\t%s\n", $5, $9}'
