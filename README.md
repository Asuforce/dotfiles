# dotfiles

設定ファイル

VSCode の [cloudSettings](https://gist.github.com/Asuforce/3803eedb0aaeda0bf875d6583e0cf753) はこれ

## Usage

```sh
# xcode setting
xcode-select --install

# Login 1password web

# do setup script
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Asuforce/dotfiles/master/setup.sh)"

# chnage shell
chsh -s /usr/local/bin/zsh
```

## Backup

- .ssh
- .zsh_history
- .netrc
- .gitconfig-work

## Manual setup

### Preferences

- General
  - Use dark menu bar and Dock
- Keyboard
  - Keyboard
    - Touch Bar shows: `F key`
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
- Date & Time
  - Clock
    - Display the time with seconds
    - Use a 24-hour clock
    - Show date
- Dock
  - Delete all default icon
  - Size: Small
  - Position on screen: Left
  - Minimize windows using: Scale effect
  - Automatically hide and show the Dock

### Menubar

- Battery
  - Show Percentage

### Apps

- Karabiner
  - Simple Modifications
    - capslock <-> left control
  - Complex Modifications
    - Change right command + hjkl to arrow keys
    - Left command English
    - Right command Japanese
- Alfread
  - Preferancies -> Advanced -> syncing
- 1Password
  - Security
    - Allow Touch ID to unlock 1Password
- iTerm2
  - General
    - Zoom maxizes vartically only
    - Native full screen windows
  - Profiles
    - Window
      - Transparency: Opaque
      - Space: All Spaces
  - Keys
    - Hotkey: `opt + Space`
- VSCode
  - Install settingssync
