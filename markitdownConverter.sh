#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

TARGET_DIR="${1:-.}"
TARGET_FILE_TYPE="${2:-pdf}"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

if ! command -v markitdown &> /dev/null; then
    echo "Error: 'markitdown' is not installed or not in your PATH."
    exit 1
fi

files_found=0

echo "Scanning '$TARGET_DIR' for '.$TARGET_FILE_TYPE' files..."

shopt -s nullglob
for file in "$TARGET_DIR"/*."$TARGET_FILE_TYPE"; do
    files_found=1
    
    base_name="${file%.$TARGET_FILE_TYPE}"
    md_file="${base_name}.md"
 	  
    if [ -f "$md_file" ]; then
        echo "Skipping: $(basename "$file") -> $(basename "$md_file") already exists."
        continue
    fi	
 
    echo "Converting: $(basename "$file") -> $(basename "$md_file")"
    
    if markitdown "$file" -o "$md_file"; then
        echo "Success: $(basename "$md_file") created."
    else
        echo "Error: Failed to convert $(basename "$file")."
    fi
done

if [ $files_found -eq 0 ]; then
    echo "No '.$TARGET_FILE_TYPE' files found in '$TARGET_DIR'."
else
    echo "Conversion process completed."
fi