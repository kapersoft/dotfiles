#!/bin/zsh


# Check if Brewfile exists
BREWFILE="$DOTFILES/homedir/.Brewfile"
if [ ! -f "$BREWFILE" ]; then
    echo "Error: Brewfile not found at $BREWFILE."
    echo "Please ensure your Brewfile exists in your dotfiles directory."
    exit 1
fi

echo "--- Checking Brewfile status ---"

# Get a list of all currently installed formulae (for missing check)
ALL_INSTALLED_FORMULAE=$(brew list --formula 2>/dev/null)
# Get a list of all currently installed formulae that are leaves (for untracked check)
INSTALLED_FORMULAE=$(brew leaves 2>/dev/null)
# Get a list of all currently installed casks
INSTALLED_CASKS=$(brew list --cask 2>/dev/null)
# Get a list of all currently installed mas apps (if mas is installed)
if command -v mas &> /dev/null; then
    INSTALLED_MAS=$(mas list | awk '{$1=""; sub(/ \([^)]+\)$/, ""); sub(/^ +/, ""); print}' 2>/dev/null)
else
    INSTALLED_MAS=""
fi


# Get a list of formulae, casks, and mas apps listed in the Brewfile
# We need to parse the brew bundle list output for each type
BREWFILE_FORMULAE=$(brew bundle list --file="$BREWFILE" --formula 2>/dev/null | grep -v '^tap:')
BREWFILE_CASKS=$(brew bundle list --file="$BREWFILE" --cask 2>/dev/null)
BREWFILE_MAS=$(brew bundle list --file="$BREWFILE" --mas 2>/dev/null)

# Convert MAS lists to arrays, splitting on newlines
BREWFILE_MAS_ARRAY=("${(@f)BREWFILE_MAS}")
INSTALLED_MAS_ARRAY=("${(@f)INSTALLED_MAS}")

# Convert cask lists to arrays, splitting on newlines
BREWFILE_CASKS_ARRAY=("${(@f)BREWFILE_CASKS}")
INSTALLED_CASKS_ARRAY=("${(@f)INSTALLED_CASKS}")

# Convert formula lists to arrays, splitting on newlines
BREWFILE_FORMULAE_ARRAY=("${(@f)BREWFILE_FORMULAE}")
INSTALLED_FORMULAE_ARRAY=("${(@f)INSTALLED_FORMULAE}")
INSTALLED_FORMULAE_ARRAY_STRIPPED=("${(@f)$(printf '%s\n' "${INSTALLED_FORMULAE_ARRAY[@]}" | sed 's#.*/##')}")
INSTALLED_FORMULAE_ARRAY_STRIPPED=("${(@)INSTALLED_FORMULAE_ARRAY_STRIPPED:#}")

# Strip tap prefixes from Brewfile and installed formulae for comparison
BREWFILE_FORMULAE_ARRAY_STRIPPED=("${(@f)$(printf '%s\n' "${BREWFILE_FORMULAE_ARRAY[@]}" | sed 's#.*/##')}")
ALL_INSTALLED_FORMULAE_ARRAY=("${(@f)ALL_INSTALLED_FORMULAE}")
ALL_INSTALLED_FORMULAE_ARRAY_STRIPPED=("${(@f)$(printf '%s\n' "${ALL_INSTALLED_FORMULAE_ARRAY[@]}" | sed 's#.*/##')}")

# Remove empty entries from arrays
BREWFILE_FORMULAE_ARRAY_STRIPPED=("${(@)BREWFILE_FORMULAE_ARRAY_STRIPPED:#}")
INSTALLED_FORMULAE_ARRAY_STRIPPED=("${(@)INSTALLED_FORMULAE_ARRAY_STRIPPED:#}")
ALL_INSTALLED_FORMULAE_ARRAY_STRIPPED=("${(@)ALL_INSTALLED_FORMULAE_ARRAY_STRIPPED:#}")

# --- Check for missing applications (in Brewfile but not installed) ---
MISSING_APPS=()
for app in "${BREWFILE_FORMULAE_ARRAY_STRIPPED[@]}"; do
    if ! printf '%s\n' "${ALL_INSTALLED_FORMULAE_ARRAY_STRIPPED[@]}" | grep -qiw "^${app}\$"; then
        MISSING_APPS+=("brew: $app")
    fi
done
for app in "${BREWFILE_CASKS_ARRAY[@]}"; do
    if ! printf '%s\n' "${INSTALLED_CASKS_ARRAY[@]}" | grep -qiw "^${app}\$"; then
        MISSING_APPS+=("cask: $app")
    fi
done
for app in "${BREWFILE_MAS_ARRAY[@]}"; do
    if ! printf '%s\n' "${INSTALLED_MAS_ARRAY[@]}" | grep -qiw "^${app}\$"; then
        MISSING_APPS+=("mas: $app")
    fi
done

# --- Check for extra applications (installed but not in Brewfile) ---
EXTRA_APPS=()
for app in "${INSTALLED_FORMULAE_ARRAY_STRIPPED[@]}"; do
    if ! printf '%s\n' "${BREWFILE_FORMULAE_ARRAY_STRIPPED[@]}" | grep -qiw "^${app}\$"; then
        EXTRA_APPS+=("brew: $app")
    fi
done
for app in "${INSTALLED_CASKS_ARRAY[@]}"; do
    if ! printf '%s\n' "${BREWFILE_CASKS_ARRAY[@]}" | grep -qiw "^${app}\$"; then
        EXTRA_APPS+=("cask: $app")
    fi
done
for app in "${INSTALLED_MAS_ARRAY[@]}"; do
    if ! printf '%s\n' "${BREWFILE_MAS_ARRAY[@]}" | grep -qiw "^${app}\$"; then
        EXTRA_APPS+=("mas: $app")
    fi
done

# --- Determine final status message ---

if [ ${#MISSING_APPS[@]} -eq 0 ] && [ ${#EXTRA_APPS[@]} -eq 0 ]; then
    echo "Brewfile is up-to-date with your installed applications."
else
    echo "Brewfile is not up-to-date because it's missing applications or contains untracked/uninstalled applications."
    if [ ${#MISSING_APPS[@]} -gt 0 ]; then
        echo ""
        echo "Missing applications (in Brewfile, not installed):"
        for app in "${MISSING_APPS[@]}"; do echo "  - $app"; done
    fi
    if [ ${#EXTRA_APPS[@]} -gt 0 ]; then
        echo ""
        echo "Untracked applications (installed, not in Brewfile):"
        for app in "${EXTRA_APPS[@]}"; do echo "  - $app"; done
    fi
fi

echo "--- Check complete ---"
