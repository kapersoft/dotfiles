#!/usr/bin/env zsh

# Update brewfile
brew bundle dump --global --force --file=$DOTFILES/homedir/.Brewfile --describe

# If there are no changes, exit
if git diff --quiet --exit-code $DOTFILES/homedir/.Brewfile; then
  echo "No changes to Brewfile."
  exit 0
fi

# Commit changes
git add $DOTFILES/homedir/.Brewfile
git commit -m "Update Brewfile"

echo "Brewfile updated and committed. Don't forget to push the changes."
