pushd $HOME/Documents/Obsidian/Remindo

# Check for changes in settings only
DOT_CHANGES=$(git status --porcelain | grep -E '^(\?\?|\ M|\M |\A |\ D|\D ) \.')
if [[ -n $DOT_CHANGES ]]; then
    git add .[^.]*
    git commit -m "$(date +%Y-%m-%d\ %H:%M:%S) Update settings"
fi

# Check for changes in notes only
NOTES_CHANGES=$(git status --porcelain | grep -E '^(\?\?|\ M|\M |\A |\ D|\D ) ')
if [[ -n $NOTES_CHANGES ]]; then
    git add .
    git commit -m "$(date +%Y-%m-%d\ %H:%M:%S) Update notes"
fi

# Check for unpushed commits
UNPUSHED_COMMITS=$(git log --oneline @{u}..HEAD 2>/dev/null | wc -l)
if [[ $UNPUSHED_COMMITS -gt 0 ]]; then
    echo "Unpushed commits: $UNPUSHED_COMMITS"
    git push
fi

# Pull the latest changes from the remote repository
git pull --rebase

popd
