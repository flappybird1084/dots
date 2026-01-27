#!/bin/bash

# Script to find the first empty workspace (1-12) using aerospace
for n in {1..12}; do
    # Run aerospace list-windows for workspace n and capture output
    output=$(aerospace list-windows --workspace "$n" 2>/dev/null)

    # Check if output is empty
    if [ -z "$output" ]; then
        echo "$n"
        exit 0
    fi
done

# If no empty workspace is found, exit with code 1
exit 1
