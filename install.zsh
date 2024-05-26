# Go to dotfiles folder
cd $(dirname $(readlink -f $0))

# Link files in homedir folder to user homedir folder
stow --dir=$(dirname $(readlink -f $0))/homedir --target=$HOME --stow .