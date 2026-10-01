# dotfiles

## Usage

### Initial Setup

```sh
# Run bootstrap script (automatically clones repository and runs full setup)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Asuforce/dotfiles/master/scripts/bootstrap.sh)"

# Restart your shell
exec $SHELL -l
```

### Subsequent Setup

Navigate to the repository and use Make:

```sh
cd ~/dev/src/github.com/Asuforce/dotfiles

# Run complete setup
make all

# Or run individual setup targets
make link      # Create dotfile symlinks
make brew      # Install Homebrew packages (macOS)
make pkg       # Install Linux packages from config/packages/linux.txt (omarchy)
make macos     # Apply macOS settings
make llm       # Setup Claude Code configuration
make runtime   # Setup language runtimes
make xcode     # Install Xcode Command Line Tools

# Show available targets
make help
```

### omarchy (Arch Linux)

`make all` branches on `uname -s`: on Linux it runs `pkg → link → llm → runtime`
and skips the macOS-only targets. Several files are replaced by the repo's
version and the original is kept next to it as `<name>.omarchy.bak`. Read the
output of `make link` for `skipped, already exists` and `moved aside` lines.

### Personal Machines

A few applications in the `Brewfile` are gated on `if personal`, because on
some machines they are provisioned outside Homebrew. Homebrew installs them
only where this marker exists, so create it before `make brew` on a machine
that manages its own applications:

```sh
make personal
```

That creates the empty, untracked marker `~/.config/dotfiles/personal`.
Run `brew bundle list --all` to confirm which entries are active.

