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

### Personal Machines

A few applications in the `Brewfile` are gated on `if personal`, because on
some machines they are provisioned outside Homebrew. Homebrew installs them
only where this marker exists, so create it before `make brew` on a machine
that manages its own applications:

```sh
make personal
```

That creates `~/.config/dotfiles/personal`, which is equivalent to:

```sh
mkdir -p "$HOME/.config/dotfiles"
touch "$HOME/.config/dotfiles/personal"
```

The path ignores `XDG_CONFIG_HOME` deliberately, because `brew bundle` scrubs
the environment before reading the `Brewfile` and cannot see that variable.

The marker is empty and is not tracked, so a machine opts in by its presence
alone. Run `brew bundle list --all` to confirm which entries are active.

## Backup

- .ssh
- .zsh_history
- .gitconfig-work
- .config/herdr/session.json
