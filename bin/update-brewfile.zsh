#!/usr/bin/env zsh

# Update brewfile
brew bundle cleanup --global --force

# If there are no changes, exit
if git diff --quiet --exit-code $DOTFILES/homedir/.Brewfile; then
  echo "No changes to Brewfile."
  exit 0
fi

# Commit changes
git add $DOTFILES/homedir/.Brewfile
git commit -m "Update Brewfile"
git push origin HEAD
