#!/bin/bash

# Script to generate images for all logos supported by fastfetch
# This script lists all logos, extracts their names from quotes,
# and runs fastfetch with each logo to generate images

# Check if fastfetch is installed
if ! command -v fastfetch &> /dev/null; then
    echo "Error: fastfetch is not installed"
    exit 1
fi

# Get all logo names from fastfetch list command
echo "Getting list of all logos..."
fastfetch --list-logos | grep -o '"[^"]*"' | sed 's/"//g' | while read -r logo; do
    # Skip empty lines
    if [ -n "$logo" ]; then
        echo "Generating image for logo: $logo"
        fastfetch -l "$logo"
        echo "----------------------------------------"
    fi
done

echo "Done processing all logos!"