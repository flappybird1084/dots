#!/bin/bash

# Remove existing directories and files
rm -rf ./fetch
rm -rf ./nvim
rm -rf ./aerospace
rm -f .zshrc
rm -f .tmux.conf

# Copy fetch directory from parent (if it exists)
if [ -d "../fetch" ]; then
    cp -r ../fetch .
    # Remove lines containing 'api' from all text files in fetch directory
    find ./fetch -type f -name "*.sh" -o -name "*.json" -o -name "*.jsonc" -o -name "*.conf" -o -name "*.toml" -o -name "*.lua" -o -name "*.txt" -o -name "*rc" | while read -r file; do
        sed -i '' '/api/d' "$file"
    done
else
    echo "Warning: ../fetch does not exist, skipping"
fi

# Copy nvim directory from ~/.config (if it exists)
if [ -d ~/.config/nvim ]; then
    cp -r ~/.config/nvim .
    # Remove lines containing 'api' from all text files in nvim directory
    # find ./nvim -type f -name "*.lua" -o -name "*.vim" -o -name "*.conf" -o -name "*.txt" -o -name "*rc" | while read -r file; do
    #     sed -i '' '/api/d' "$file"
    # done
else
    echo "Warning: ~/.config/nvim does not exist, skipping"
fi

# Copy aerospace config (if AeroSpace is installed)
# if [ -f "/Applications/AeroSpace.app/Contents/Resources/default-config.toml" ]; then
#     mkdir -p aerospace
#     cp /Applications/AeroSpace.app/Contents/Resources/default-config.toml ./aerospace
#     # Remove lines containing 'api' from aerospace config
#     sed -i '' '/api/d' ./aerospace/default-config.toml
# else
#     echo "Warning: AeroSpace config does not exist, skipping"
# fi
if [ -f "~/.aerospace.toml" ]; then
    mkdir -p aerospace
    cp ~/.aerospace.toml ./aerospace
    # Remove lines containing 'api' from aerospace config
    sed -i '' '/api/d' ./aerospace/default-config.toml
else
    echo "Warning: AeroSpace config does not exist, skipping"
fi

# Copy zshrc (if it exists)
if [ -f ~/.zshrc ]; then
    cp ~/.zshrc .
    # Remove lines containing 'api' from .zshrc on macOS (BSD sed syntax)
    sed -i '' '/api/d' .zshrc
    sed -i '' '/API/d' .zshrc
else
    echo "Warning: ~/.zshrc does not exist, skipping"
fi

# Copy tmux.conf (if it exists)
if [ -f ~/.tmux.conf ]; then
    cp ~/.tmux.conf .
    # Remove lines containing 'api' from tmux.conf
    sed -i '' '/api/d' .tmux.conf
else
    echo "Warning: ~/.tmux.conf does not exist, skipping"
fi
