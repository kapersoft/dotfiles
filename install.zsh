#!/usr/bin/env zsh

# Path to the dotfiles
DOTFILES=$(readlink -f $0 | xargs dirname)

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for the current session
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed"
fi

# Install packages from Brewfile
if [[ -f "$DOTFILES/homedir/.Brewfile" ]]; then
    echo "Installing packages from Brewfile..."
    brew bundle --file="$DOTFILES/homedir/.Brewfile"
else
    echo "No Brewfile found at $DOTFILES/homedir/.Brewfile"
fi

# Stow homedir
$DOTFILES/bin/stow.zsh

# Instruct user to restart terminal
echo "Please close your terminal and open Ghossty to continue installation."
