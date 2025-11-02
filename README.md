# dotfiles

## Usage

```sh
# xcode setting
xcode-select --install

# Login 1password web

# Do setup script
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Asuforce/dotfiles/master/setup.sh)"

# Chnage shell
chsh -s /usr/local/bin/zsh
```

## Backup

- .ssh
- .zsh_history
- .gitconfig-work

## Manual setup

### Preferences

- General
  - Use dark menu bar and Dock
- Keyboard
  - Shortcuts
    - Spotlight: all check out
  - Continuous input
    - `defaults write -g ApplePressAndHoldEnabled -bool false`
- Trackpad
  - Tap to click
  - Tacking speed: Fast
  - Click: Light
- Accessbility
  - Mouse & Trackpad
    - Trackpad Options
      - Enable dragging: three finger drag
- Dock
  - Delete all default icon
  - Size: Small
  - Position on screen: Left
  - Minimize windows using: Scale effect
  - Automatically hide and show the Dock

### Menubar

- Battery
  - Show Percentage
