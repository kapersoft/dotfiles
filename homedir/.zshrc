#!/usr/bin/env zsh

# Skip when running in cursor or vscode
if [[ "$TERM_PROGRAM" == "vscode" && ! -t 1 ]]; then
  return
fi

# Start tmux
if [ -z "$TMUX" ]; then
  # exec tmux new-session -A -s base
  exec tmux new-session -t base
fi

# Path to the dotfiles
export DOTFILES=${${$(readlink -f $HOME/.zshrc):a:h}:a:h}

# Stow homedir
$DOTFILES/bin/stow.zsh

# Source exports
source $DOTFILES/exports.zsh

# Set $PATH
source $DOTFILES/path.zsh

# Init terminal
source $DOTFILES/init.zsh

# Setup aliases
source $DOTFILES/aliases.zsh

# Setup custom commands
if [ -f $DOTFILES/custom.zsh ]; then
    source $DOTFILES/custom.zsh
fi


# Herd injected NVM configuration
export NVM_DIR="/Users/jwkaper/Library/Application Support/Herd/config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"

# Herd injected PHP binary.
export PATH="/Users/jwkaper/Library/Application Support/Herd/bin/":$PATH


# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="/Users/jwkaper/Library/Application Support/Herd/config/php/83/"


# Herd injected PHP 8.2 configuration.
export HERD_PHP_82_INI_SCAN_DIR="/Users/jwkaper/Library/Application Support/Herd/config/php/82/"


# Herd injected PHP 8.1 configuration.
export HERD_PHP_81_INI_SCAN_DIR="/Users/jwkaper/Library/Application Support/Herd/config/php/81/"


# Herd injected PHP 8.0 configuration.
export HERD_PHP_80_INI_SCAN_DIR="/Users/jwkaper/Library/Application Support/Herd/config/php/80/"


# Herd injected PHP 7.4 configuration.
export HERD_PHP_74_INI_SCAN_DIR="/Users/jwkaper/Library/Application Support/Herd/config/php/74/"


# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/jwkaper/Library/Application Support/Herd/config/php/84/"
