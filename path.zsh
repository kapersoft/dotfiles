# Add directories to the PATH and prevent to add the same directory multiple times upon shell reload.
add_to_path() {
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}

# macOS
add_to_path "/usr/local/sbin"

# Dotfiles binaries
add_to_path "$DOTFILES/bin"

# Homebrew
add_to_path "/opt/homebrew/bin"

# Herd
add_to_path "$HOME/Library/Application Support/Herd/bin/"

# Global Composer
add_to_path "$HOME/.composer/vendor/bin"

# Use project specific binaries before global ones
add_to_path "vendor/bin"
add_to_path "node_modules/.bin"
