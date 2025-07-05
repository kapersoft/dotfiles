# My Dotfiles

These are my personal dotfiles for setting up a new macOS machine. They are highly personalized to my workflow, but feel free to use them as a starting point for your own.

## What are dotfiles?

Dotfiles are configuration files for various programs. They are called "dotfiles" because they are typically hidden and their filenames start with a dot (e.g., `.zshrc`, `.vimrc`).

## Features

* **Zsh** as the default shell, with a customized prompt using [Powerlevel10k](https://github.com/romkatv/powerlevel10k).
* **[Zinit](https://github.com/zdharma-continuum/zinit)** for managing zsh plugins.
* **[Homebrew](https://brew.sh/)** for managing packages.
* **Lots of aliases** for common commands (see `aliases.zsh`).
* **[fzf](https://github.com/junegunn/fzf)** for fuzzy finding files and history.
* **[eza](https://github.com/eza-community/eza)** as a modern replacement for `ls`.
* **[Herd](https://herd.laravel.com/)** for a blazing fast local development environment for PHP and Laravel.

## Installation

1. Clone this repository to your home directory:

    ```bash
    git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
    ```

2. Run the installation script:

    ```bash
    cd ~/.dotfiles && ./install.zsh
    ```

The installation script will:

* Install [Homebrew](https://brew.sh/) if it's not already installed.
* Install the following packages with Homebrew: `stow`, `eza`, `fzf`, `zoxide`, `powerlevel10k`, `zsh-syntax-highlighting`, `zsh-completions`, `zsh-autosuggestions`, `fzf-tab`, `composer`, `herd`.
* Install [Oh My Zsh](https://ohmyz.sh/) by running the following command:

    ```bash
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```

* Install global composer packages.
* Start [Herd](httpss://herd.laravel.com).
* Stow the dotfiles to your home directory.

## Managing Your Dotfiles

This repository uses [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks for the configuration files. The `stow.zsh` script handles the symlinking process.

### File Structure

All the files that need to be symlinked to your home directory (`$HOME`) should be placed inside the `homedir/` directory. The structure within `homedir/` should mirror the structure of your `$HOME` directory.

For example:

* A file at `homedir/.zshrc` will be symlinked to `~/.zshrc`.
* A file at `homedir/.config/ghostty/config` will be symlinked to `~/.config/ghostty/config`.

### Adding a New File

1. Copy the configuration file you want to manage into the `homedir/` directory, preserving its path relative to your home directory.
2. Run the stow script to create the symlink:

    ```bash
    ./bin/stow.zsh
    ```

### Updating an Existing File

Simply edit the file within the `homedir/` directory. Since the file in your home directory is a symlink, the changes will be applied automatically.

### Applying Changes

After adding new files or moving them, run the stow script to update the symlinks:

```bash
./bin/stow.zsh
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
