#!/bin/bash

# This script restores the dotfiles from this directory to their proper locations

echo "Restoring dotfiles..."

# Create necessary directories
mkdir -p ~/.config

# Restore fetch directory to parent (if it exists here)
if [ -d "./fetch" ]; then
    cp -r ./fetch ../
    echo "Restored fetch to ../fetch"
else
    echo "No fetch directory to restore"
fi

# Restore nvim directory to ~/.config (if it exists here)
if [ -d "./nvim" ]; then
    cp -r ./nvim ~/.config/
    echo "Restored nvim to ~/.config/nvim"
else
    echo "No nvim directory to restore"
fi

# Restore aerospace config (if it exists here and AeroSpace is installed)
if [ -d "./aerospace" ] && [ -f "./aerospace/default-config.toml" ]; then
    if [ -d "/Applications/AeroSpace.app" ]; then
        cp ./aerospace/default-config.toml /Applications/AeroSpace.app/Contents/Resources/default-config.toml
        echo "Restored aerospace config to /Applications/AeroSpace.app/Contents/Resources/default-config.toml"
    else
        echo "AeroSpace app not found, unable to restore aerospace config"
    fi
else
    echo "No aerospace config to restore or AeroSpace not installed"
fi

# Restore zshrc (if it exists here)
if [ -f "./.zshrc" ]; then
    cp ./.zshrc ~/.zshrc
    echo "Restored .zshrc to ~/.zshrc"
else
    echo "No .zshrc file to restore"
fi

# Restore tmux.conf (if it exists here)
if [ -f "./.tmux.conf" ]; then
    cp ./.tmux.conf ~/.tmux.conf
    echo "Restored .tmux.conf to ~/.tmux.conf"
else
    echo "No .tmux.conf file to restore"
fi

echo "Dotfiles restoration complete!"