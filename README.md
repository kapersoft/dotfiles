# Dotfiles

Personal macOS dotfiles for a modern development environment focused on web development, Laravel/PHP, and productivity.

## What are dotfiles?

Dotfiles are configuration files for Unix-like systems that typically start with a dot (`.`). They store user preferences, environment settings, aliases, and other customizations that make your terminal and development environment uniquely yours. This repository manages and synchronizes these configurations across machines.

## Features

### 🚀 Modern Shell Setup

- **Zsh** with [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
- [Zinit](https://github.com/zdharma-continuum/zinit) plugin manager for fast loading
- Syntax highlighting, autosuggestions, and fuzzy tab completion
- Rich history configuration with search capabilities

### 📦 Package Management

- **Homebrew** integration with automated Brewfile management
- Pre-configured packages for development (Node.js, PHP, Git tools, etc.)
- Mac App Store apps and VS Code extensions included
- Brewfile validation and update scripts

### ⚡ Development Tools

- **Laravel & PHP** optimized with Herd integration
- Git aliases and shortcuts for common workflows
- tmux configuration with modern theme
- Modern CLI replacements (eza, bat, fzf, etc.)

### 🛠 Utility Scripts

- `update.zsh` - Updates all packages (Homebrew, Composer, pnpm, macOS)
- `check-brewfile.zsh` - Validates Brewfile against installed packages
- `update-brewfile.zsh` - Automatically updates and commits Brewfile changes
- `tag-major.zsh` / `tag-minor.zsh` - Git tagging helpers
- `lavlog` - Colored Laravel log viewer
- `importdb` - Database import utility

### 🎨 Terminal Enhancements

- Solarized color scheme with custom dircolors
- Modern file listing with icons and git integration
- Fuzzy finding and smart directory navigation
- Custom prompt with git status and context

## Requirements

- **macOS** (tested on recent versions)
- **Git** - For repository management
- **Internet connection** - For downloading Homebrew and packages

## Installation

1. **Clone the repository** to the recommended location:

   ```bash
   git clone https://github.com/kapersoft/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the install script**:

   ```bash
   ./install.zsh
   ```

   The install script will automatically.
    - Install Homebrew if not already present
    - Install all packages defined in the Brewfile
    - Use GNU Stow to create symlinks from `~/dotfiles/homedir/` to your home directory

3. **Close your terminal and open Ghostty**

   *Note: The first time you open Ghostty, it will automatically download and configure Zinit and zsh plugins. This is normal and only happens once.*

## Usage

### Daily Workflow

- The configuration loads automatically when you open a new terminal
- All aliases and functions are immediately available
- Run `reload` to refresh the shell configuration after changes

### Key Aliases

```bash
# Git shortcuts
gs          # git status
gc          # git fetch && git checkout
commit      # git add . && git commit -m
amend       # git add . && git commit --amend --no-edit
push/pull   # git push/pull with sensible defaults

# Directory navigation
projects    # cd ~/Code
dotfiles    # cd $DOTFILES
home        # cd $HOME

# Modern CLI tools
ls          # eza with icons and colors
l           # detailed eza listing with git info
tree        # eza tree view
```

### Package Management

```bash
# Update everything
update.zsh

# Check Brewfile status
check-brewfile.zsh

# Update Brewfile with current packages
update-brewfile.zsh
```

## File Structure

```
~/dotfiles/
├── homedir/              # Files symlinked to home directory
│   ├── .zshrc           # Main shell configuration
│   ├── .tmux.conf       # Tmux configuration
│   ├── .p10k.zsh        # Powerlevel10k theme
│   ├── .dircolors       # Color scheme for ls/eza
│   ├── .Brewfile        # Homebrew package definitions
│   └── .config/         # Application configurations
│       └── ghostty/     # Ghostty terminal config
├── bin/                 # Utility scripts
│   ├── stow.zsh        # Symlink management
│   ├── update.zsh      # System update script
│   └── check-brewfile.zsh # Brewfile validation
├── init.zsh            # Zsh initialization (plugins, etc.)
├── aliases.zsh         # Command aliases and functions
├── path.zsh           # PATH management
└── install.zsh        # Installation script
```

### Configuration Locations

- **Shell**: `homedir/.zshrc` → `~/.zshrc`
- **Terminal multiplexer**: `homedir/.tmux.conf` → `~/.tmux.conf`
- **Package management**: `homedir/.Brewfile` → `~/.Brewfile`
- **Colors**: `homedir/.dircolors` → `~/.dircolors`
- **Theme**: `homedir/.p10k.zsh` → `~/.p10k.zsh`
- **Apps**: `homedir/.config/` → `~/.config/`

## Testing

The repository includes GitHub Actions workflows for automated testing:

### Workflows

- **Test Install** (`.github/workflows/test-install.yml`):
  - Tests installation on macOS runners
  - Verifies symlinks are created correctly
  - Runs on every push and pull request

- **Format** (`.github/workflows/format.yml`):
  - Auto-formats shell scripts with shfmt
  - Commits formatting changes automatically

- **Release** (`.github/workflows/release.yml`):
  - Creates releases when version tags are pushed
  - Triggered by tags matching `v*` pattern

### Manual Testing

You can test the installation locally:

```bash
# Test the install script
./install.zsh

# Verify symlinks were created
ls -la ~ | grep dotfiles

# Test that zsh loads without errors
zsh -c "source ~/.zshrc && echo 'Configuration loaded successfully'"
```

## Contact

For questions, suggestions, or issues:

- **Email**: [kapersoft@gmail.com](mailto:kapersoft@gmail.com)
- **GitHub**: Open an issue in this repository

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

*These dotfiles are personal configurations optimized for web development with PHP/Laravel. Feel free to fork and adapt them to your needs!*
