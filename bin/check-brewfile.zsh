#!/bin/zsh

# Check if Brewfile is up to date
# Usage: check-brewfile.zsh

set -e

BREWFILE="$DOTFILES/homedir/.Brewfile"
TEMP_BREWFILE=$(mktemp)

# Clean up temp file on exit
trap "rm -f $TEMP_BREWFILE" EXIT

echo "Generating current brew bundle dump..."
brew bundle dump --force --describe --file="$TEMP_BREWFILE"

echo "Comparing with existing Brewfile..."

if cmp -s "$BREWFILE" "$TEMP_BREWFILE"; then
    echo "✅ Your Brewfile is up to date!"
    exit 0
else
    echo "❌ Your Brewfile is NOT up to date!"
    echo ""
    echo "Differences found:"
    echo "=================="

    # Show diff with some color if available
    if command -v git >/dev/null 2>&1; then
        git diff --no-index --color=always "$BREWFILE" "$TEMP_BREWFILE" || true
    else
        diff -u "$BREWFILE" "$TEMP_BREWFILE" || true
    fi

    exit 1
fi
