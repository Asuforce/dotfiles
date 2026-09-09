# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This repository manages macOS dotfiles via symlinks. The `config/` directory holds the source-of-truth config files; `scripts/link.sh` creates symlinks from there to the appropriate locations. See `Makefile` for available commands.

All setup scripts are idempotent: they check for file/directory existence before creating symlinks or copying files, so re-running them will not overwrite existing configurations.

### Key notes

- All scripts use `set -euo pipefail` and check existence before creating links/dirs.
- Architecture detection (arm64 vs x86) determines Homebrew prefix (`/opt/homebrew` vs `/usr/local`).
- `config/git/.gitconfig` and `config/git/.gitconfig-work` are copied rather than symlinked to allow local modification; they are listed in the backup section of README.
- Files that are copied (not symlinked) allow local modification: git configs, SSH config, and work-specific zsh config (`~/.zshrc.work`, not git-managed).
- Terminal multiplexing (panes, tabs, workspaces, copy mode) is owned by herdr, not by the terminal emulator. `config/wezterm/wezterm.lua` deliberately binds no leader key and no pane/tab keys; herdr holds the prefix `ctrl+g` (`config/herdr/config.toml`). Do not re-add pane or tab bindings to the terminal config; they would shadow herdr's prefix.
- `config/herdr/config.toml` records only intentional deviations from `herdr --default-config`, so version upgrades do not turn it into a full-file diff.
