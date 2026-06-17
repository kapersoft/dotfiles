#!/usr/bin/env zsh

pushd $DOTFILES

# Update brewfile
brew bundle dump --force --file=$DOTFILES/homedir/.Brewfile

# If there are no changes, exit
if git diff --quiet --exit-code $DOTFILES/homedir/.Brewfile; then
  echo "🙅🏼 No changes to Brewfile."
  exit 0
fi

# Commit changes
git add $DOTFILES/homedir/.Brewfile
git commit -m "Update Brewfile"

echo "✅ Brewfile updated and committed"
echo "👉🏼 Don't forget to push the changes."

popd
