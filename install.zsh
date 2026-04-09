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

# tmux plugin manager (for ~/.tmux.conf TPM plugins)
TPM_HOME="${HOME}/.tmux/plugins/tpm"
if [[ ! -d "$TPM_HOME" ]]; then
    mkdir -p "${HOME}/.tmux/plugins"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_HOME"
fi

# Free ^Space and ^⌥Space (Input Sources) for apps like IDEs
echo "Updating macOs defaults"
# 60 = Select the previous input source; 61 = Select next source in Input menu
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 '{enabled = 0;}'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 '{enabled = 0;}'

# English-only keyboard: ABC (en, layout ID 252 in AppleKeyboardLayouts)
defaults write com.apple.HIToolbox AppleEnabledInputSources -array \
    '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>252</integer><key>KeyboardLayout Name</key><string>ABC</string></dict>'
defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID -string 'com.apple.keylayout.ABC'
defaults delete com.apple.HIToolbox AppleInputSourceHistory 2>/dev/null || true
defaults delete com.apple.HIToolbox AppleSelectedInputSources 2>/dev/null || true

# Multitouch mouse (e.g. Magic Mouse): secondary click on right (TwoButtonSwapped = left)
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string TwoButton

# Stow homedir
$DOTFILES/bin/stow.zsh

# Instruct user to restart terminal
echo "Please close your terminal and open Ghossty to continue installation."
