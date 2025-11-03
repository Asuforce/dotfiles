# dotfiles

## Usage

### Initial Setup (First Time)

```sh
# Run bootstrap script (automatically clones repository and runs full setup)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Asuforce/dotfiles/master/scripts/bootstrap.sh)"

# Restart your shell
exec $SHELL -l
```

### Subsequent Setup (After Repository Cloned)

Navigate to the repository and use Make:

```sh
cd ~/dev/src/github.com/Asuforce/dotfiles

# Run complete setup
make all

# Or run individual setup targets
make link      # Create dotfile symlinks only
make brew      # Install Homebrew packages only
make macos     # Apply macOS settings only
make llm       # Setup Claude Code configuration only
make runtime   # Setup language runtimes only
make xcode     # Install Xcode Command Line Tools only

# Show available targets
make help
```

## Backup

- .ssh
- .zsh_history
- .gitconfig-work
