#!/usr/bin/env zsh

# Path to the dotfiles
DOTFILES=$(readlink -f $0 | xargs dirname | xargs dirname)

# Stow files in homedir to users home directory
stow --dir=$DOTFILES/homedir --target=$HOME --stow .
