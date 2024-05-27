# Path to the dotfiles
export DOTFILES=${${$(readlink -f $HOME/.zshrc):a:h}:a:h}

# Stow homedir
$DOTFILES/bin/stow.zsh

# Init terminal
source $DOTFILES/init.zsh

# Setup aliases
source $DOTFILES/aliases.zsh

# Setup custom commands
if [ -f $DOTFILES/custom.zsh ]; then
    source $DOTFILES/custom.zsh
fi
