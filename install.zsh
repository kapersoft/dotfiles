# Path to the dotfiles
DOTFILES=$(readlink -f $0 | xargs dirname)

# Stow homedir
$DOTFILES/bin/stow.zsh
