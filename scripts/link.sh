#!/bin/bash

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

readonly OS="$(uname -s)"
readonly CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Never replaces an existing path. An existing path that is not already this
# link is reported: on omarchy the distro seeds some of these files first, and a
# silent skip would leave the repo's version unapplied without any sign of it.
link_config() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ ! -e "$dest" ] && [ ! -L "$dest" ]; then
    ln -s "$src" "$dest"
  elif [ "$(readlink "$dest" 2>/dev/null || true)" != "$src" ]; then
    printf "  skipped, already exists: %s\n" "$dest"
  fi
}

# Like link_config, but on Linux a regular file in the way is deleted first. For
# files where the repo's version is the one that applies; omarchy's seeded copy
# can be fetched from its repository again.
adopt_config() {
  local src="$1" dest="$2"
  if [[ "$OS" == "Linux" ]] && [ -f "$dest" ] && [ ! -L "$dest" ]; then
    rm "$dest"
    printf "  replaced omarchy's file: %s\n" "$dest"
  fi
  link_config "$src" "$dest"
}

# Link zsh config
printf "Linking Zsh config files...\n"
link_config "$REPO_DIR/config/zsh/zshrc" "$HOME/.zshrc"

# Link tig config
printf "Linking Tig config...\n"
link_config "$REPO_DIR/config/tig/tigrc" "$HOME/.tigrc"

# Link Sheldon config
printf "Linking Sheldon config...\n"
link_config "$REPO_DIR/config/sheldon/plugins.toml" "$CONFIG_HOME/sheldon/plugins.toml"

# Link bat config
printf "Linking bat config...\n"
link_config "$REPO_DIR/config/bat/config" "$CONFIG_HOME/bat/config"

# Link zsh-abbr abbreviations
printf "Linking zsh-abbr abbreviations...\n"
link_config "$REPO_DIR/config/zsh/abbreviations" "$CONFIG_HOME/zsh-abbr/abbreviations"

# Link Ghostty config. Ghostty also reads the legacy ~/.config/ghostty/config, and
# omarchy-install-terminal seeds that name, so on Linux it is removed or its
# settings would merge with the repo's.
printf "Linking Ghostty config...\n"
if [[ "$OS" == "Linux" ]] && [ -f "$CONFIG_HOME/ghostty/config" ] && [ ! -L "$CONFIG_HOME/ghostty/config" ]; then
  rm "$CONFIG_HOME/ghostty/config"
  printf "  removed omarchy's file: %s\n" "$CONFIG_HOME/ghostty/config"
fi
link_config "$REPO_DIR/config/ghostty/config.ghostty" "$CONFIG_HOME/ghostty/config.ghostty"

# Link git config files. os-<kernel> carries the 1Password signing program path.
printf "Linking Git config files...\n"
adopt_config "$REPO_DIR/config/git/config" "$CONFIG_HOME/git/config"
link_config "$REPO_DIR/config/git/ignore" "$CONFIG_HOME/git/ignore"
link_config "$REPO_DIR/config/git/os-$(uname -s | tr '[:upper:]' '[:lower:]')" "$CONFIG_HOME/git/os"

# Link Starship config
printf "Linking Starship config...\n"
adopt_config "$REPO_DIR/config/starship/starship.toml" "$CONFIG_HOME/starship.toml"

if [[ "$OS" == "Darwin" ]]; then
  if [[ "$(uname -m)" == "arm64" ]]; then
    BREW_DIR="/opt/homebrew"
  else
    BREW_DIR="/usr/local"
  fi

  # Link herdr config
  printf "Linking herdr config...\n"
  link_config "$REPO_DIR/config/herdr/config.toml" "$CONFIG_HOME/herdr/config.toml"

  # Copy git user config files (not symlinked)
  readonly COPY_DOT_FILES=(.gitconfig .gitconfig-work)
  for file in "${COPY_DOT_FILES[@]}"; do
    dest_file="$HOME/$file"
    [ ! -e "$dest_file" ] && cp "$REPO_DIR/config/git/$file" "$dest_file"
  done

  # Copy zsh work config (not symlinked, not git-managed)
  readonly ZSHRC_WORK="$HOME/.zshrc.work"
  [ ! -e "$ZSHRC_WORK" ] && cp "$REPO_DIR/config/zsh/zshrc.work" "$ZSHRC_WORK"

  # Link Neovim config
  printf "Linking Neovim config...\n"
  link_config "$REPO_DIR/config/nvim/init.lua" "$CONFIG_HOME/nvim/init.lua"

  # Link btop config
  printf "Linking btop config...\n"
  link_config "$REPO_DIR/config/btop/btop.conf" "$CONFIG_HOME/btop/btop.conf"

  # Set default shell to Zsh
  printf "Setting default shell to Zsh...\n"
  readonly ZSH_DIR="$BREW_DIR/bin/zsh"
  readonly SHELL_FILE="/etc/shells"
  if ! grep -q "$ZSH_DIR" "$SHELL_FILE"; then
    echo "$ZSH_DIR" | sudo tee -a "$SHELL_FILE" > /dev/null
  fi

  # Create SSH directory and copy config
  printf "Setting up SSH directory...\n"
  readonly SSH_DIR="$HOME/.ssh"
  if [ ! -d "$SSH_DIR" ]; then
    mkdir -p "$SSH_DIR/conf.d"
    chmod -R 700 "$SSH_DIR"
    cp "$REPO_DIR/config/ssh/config" "$SSH_DIR/config"
  fi

  # Link Karabiner config
  printf "Linking Karabiner config...\n"
  link_config "$REPO_DIR/config/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

  # Link diff-highlight
  printf "Linking diff-highlight...\n"
  readonly DIFF_HIGHLIGHT_FILE="$BREW_DIR/bin/diff-highlight"
  [ ! -f "$DIFF_HIGHLIGHT_FILE" ] && ln -s "$BREW_DIR/share/git-core/contrib/diff-highlight/diff-highlight" "$DIFF_HIGHLIGHT_FILE"

  # Link Hammerspoon config
  printf "Linking Hammerspoon config...\n"
  link_config "$REPO_DIR/config/hammerspoon/init.lua" "$HOME/.hammerspoon/init.lua"
else
  # keyd reads only /etc/keyd, so the file is copied there rather than linked.
  # keyd is in config/packages/linux.txt; the guard below only covers running
  # `make link` on its own.
  printf "Setting up keyd...\n"
  readonly KEYD_SRC="$REPO_DIR/config/keyd/default.conf"
  readonly KEYD_DEST="/etc/keyd/default.conf"
  if ! command -v keyd >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm keyd
  fi
  if ! cmp -s "$KEYD_SRC" "$KEYD_DEST"; then
    sudo install -Dm644 "$KEYD_SRC" "$KEYD_DEST"
  fi
  sudo systemctl enable --now keyd
  sudo keyd reload

  # T2 Macs (MacBookPro15,2 and kin) have an Apple T2 bridge on PCI 106b:1801.
  if lspci -d 106b:1801 2>/dev/null | grep -q .; then
    # supergfxd is for hybrid-GPU laptops. With no NVIDIA card its suspend hook
    # failed to switch to Vfio and held every resume for about 15 seconds.
    if pacman -Qq supergfxctl >/dev/null 2>&1 && ! lspci | grep -qi nvidia; then
      printf "Removing supergfxctl (no discrete GPU)...\n"
      sudo systemctl disable --now supergfxd 2>/dev/null || true
      sudo pacman -Rns --noconfirm supergfxctl
      sudo rm -f /etc/supergfxd.conf /etc/modprobe.d/supergfxd.conf /run/omarchy-force-igpu-integrated
    fi

    printf "Setting up T2 NetworkManager config...\n"
    readonly IBRIDGE_SRC="$REPO_DIR/config/t2/90-ibridge-unmanaged.conf"
    readonly IBRIDGE_DEST="/etc/NetworkManager/conf.d/90-ibridge-unmanaged.conf"
    if ! cmp -s "$IBRIDGE_SRC" "$IBRIDGE_DEST"; then
      sudo install -Dm644 "$IBRIDGE_SRC" "$IBRIDGE_DEST"
      sudo systemctl reload NetworkManager
    fi

    printf "Setting up tiny-dfr resume hook...\n"
    readonly TINYDFR_SRC="$REPO_DIR/config/t2/tiny-dfr-resume"
    readonly TINYDFR_DEST="/usr/lib/systemd/system-sleep/tiny-dfr"
    if ! cmp -s "$TINYDFR_SRC" "$TINYDFR_DEST"; then
      sudo install -Dm755 "$TINYDFR_SRC" "$TINYDFR_DEST"
    fi
  fi

  # omarchy seeds these two files, so link_config would skip them. A marked
  # block is appended instead, and a file that already carries the setting is
  # reported and left alone.
  # ctrl:nocaps puts Control on Caps Lock; dropping omarchy's compose:caps is
  # what lets that take effect, and Compose sequences are not used here.
  printf "Applying Hyprland keyboard options...\n"
  readonly HYPR_INPUT="$CONFIG_HOME/hypr/input.lua"
  readonly HYPR_INPUT_MARKER="-- dotfiles: Caps Lock is Control"
  if [ ! -f "$HYPR_INPUT" ] || ! grep -qF -- "$HYPR_INPUT_MARKER" "$HYPR_INPUT"; then
    mkdir -p "$(dirname "$HYPR_INPUT")"
    cat >>"$HYPR_INPUT" <<EOF

$HYPR_INPUT_MARKER
hl.config({ input = { kb_options = "ctrl:nocaps,shift:both_capslock_cancel" } })
EOF
    command -v hyprctl >/dev/null 2>&1 && hyprctl reload >/dev/null 2>&1 || true
  fi

  # Natural scrolling, three-finger drag and a four-finger workspace swipe, as
  # on the mac. The swipe takes four fingers because three are the drag's.
  # Tap-to-click and two-finger right-click are already omarchy's defaults.
  printf "Applying Hyprland trackpad settings...\n"
  readonly HYPR_TRACKPAD_MARKER="-- dotfiles: trackpad matches the mac"
  if ! grep -qF -- "$HYPR_TRACKPAD_MARKER" "$HYPR_INPUT"; then
    cat >>"$HYPR_INPUT" <<EOF

$HYPR_TRACKPAD_MARKER
hl.config({ input = { touchpad = { natural_scroll = true, drag_3fg = 1 } } })
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
EOF
    command -v hyprctl >/dev/null 2>&1 && hyprctl reload >/dev/null 2>&1 || true
  fi

  # A palm brushing the pad while typing registers as a tap and moves the caret
  # out of the field, so the next keys reach the page. Physical clicks remain.
  printf "Applying Hyprland tap-to-click setting...\n"
  readonly HYPR_TAP_MARKER="-- dotfiles: tap-to-click is off"
  if ! grep -qF -- "$HYPR_TAP_MARKER" "$HYPR_INPUT"; then
    cat >>"$HYPR_INPUT" <<EOF

$HYPR_TAP_MARKER
hl.config({ input = { touchpad = { tap_to_click = false } } })
EOF
    command -v hyprctl >/dev/null 2>&1 && hyprctl reload >/dev/null 2>&1 || true
  fi

  # 1.0 is the top of libinput's pointer speed range, the nearest match to the
  # mac's fastest tracking speed. The adaptive acceleration profile is kept,
  # since macOS accelerates too.
  printf "Applying Hyprland pointer speed...\n"
  readonly HYPR_POINTER_MARKER="-- dotfiles: pointer speed is maximum"
  if ! grep -qF -- "$HYPR_POINTER_MARKER" "$HYPR_INPUT"; then
    cat >>"$HYPR_INPUT" <<EOF

$HYPR_POINTER_MARKER
hl.config({ input = { sensitivity = 1.0, accel_profile = "adaptive" } })
EOF
    command -v hyprctl >/dev/null 2>&1 && hyprctl reload >/dev/null 2>&1 || true
  fi

  printf "Applying Hyprland clipboard manager binding...\n"
  readonly HYPR_BINDINGS="$CONFIG_HOME/hypr/bindings.lua"
  readonly HYPR_CLIPBOARD_MARKER="-- dotfiles: clipboard manager on Super+Shift+V"
  if [ ! -f "$HYPR_BINDINGS" ] || ! grep -qF -- "$HYPR_CLIPBOARD_MARKER" "$HYPR_BINDINGS"; then
    mkdir -p "$(dirname "$HYPR_BINDINGS")"
    cat >>"$HYPR_BINDINGS" <<EOF

$HYPR_CLIPBOARD_MARKER
o.bind("SUPER + SHIFT + V", "Clipboard manager", "omarchy menu clipboard")
EOF
    command -v hyprctl >/dev/null 2>&1 && hyprctl reload >/dev/null 2>&1 || true
  fi

  # The installer seeds 1.25 here; 1 is the scale chosen on this machine.
  printf "Applying Hyprland monitor scale...\n"
  readonly HYPR_MONITORS="$CONFIG_HOME/hypr/monitors.lua"
  if [ -f "$HYPR_MONITORS" ] && ! grep -qxF "local omarchy_monitor_scale = 1" "$HYPR_MONITORS"; then
    sed -i 's/^local omarchy_monitor_scale = .*/local omarchy_monitor_scale = 1/' "$HYPR_MONITORS"
    command -v hyprctl >/dev/null 2>&1 && hyprctl reload >/dev/null 2>&1 || true
  fi

  # Same HackGen35 family as the mac's Ghostty; the NF variant carries the icon
  # glyphs the omarchy bar needs.
  printf "Setting the system monospace font...\n"
  readonly MONO_FONT="HackGen35 Console NF"
  if command -v omarchy-font-set >/dev/null 2>&1 \
    && ! grep -qF -- "<string>$MONO_FONT</string>" "$CONFIG_HOME/fontconfig/fonts.conf" 2>/dev/null; then
    omarchy-font-set "$MONO_FONT" || printf "  omarchy-font-set failed for %s\n" "$MONO_FONT" >&2
  fi

  # keyd sends Muhenkan/Henkan on a lone left/right command tap; fcitx5 turns
  # them into off/on. fcitx5 seeds the file with these sections commented out.
  printf "Binding Muhenkan/Henkan in fcitx5...\n"
  readonly FCITX5_CONFIG="$CONFIG_HOME/fcitx5/config"
  readonly FCITX5_MARKER="# dotfiles: Muhenkan/Henkan switch the input method"
  if [ -f "$FCITX5_CONFIG" ] && grep -qE '^\[Hotkey/(Activate|Deactivate)Keys\]' "$FCITX5_CONFIG" \
    && ! grep -qF "$FCITX5_MARKER" "$FCITX5_CONFIG"; then
    printf "  skipped, already set: %s\n" "$FCITX5_CONFIG"
  elif [ ! -f "$FCITX5_CONFIG" ] || ! grep -qF "$FCITX5_MARKER" "$FCITX5_CONFIG"; then
    mkdir -p "$(dirname "$FCITX5_CONFIG")"
    cat >>"$FCITX5_CONFIG" <<EOF

$FCITX5_MARKER
[Hotkey/ActivateKeys]
0=Henkan

[Hotkey/DeactivateKeys]
0=Muhenkan
EOF
    command -v fcitx5-remote >/dev/null 2>&1 && fcitx5-remote -r >/dev/null 2>&1 || true
  fi

  # omarchy seeds herdr's config with a tmux-mirroring keymap. [keys] is reduced
  # to the prefix and copy_mode (unbound in herdr's defaults), so the bindings are
  # herdr's defaults, as on the mac; the rest of the file (accent, pane borders,
  # mouse) stays omarchy's. `herdr config check` guards the edit.
  printf "Aligning herdr keys with the mac...\n"
  readonly HERDR_CONFIG="$CONFIG_HOME/herdr/config.toml"
  if [ -f "$HERDR_CONFIG" ]; then
    HERDR_TMP="$(mktemp)"
    awk '
      /^\[/ { in_keys = ($0 == "[keys]") }
      in_keys && /^prefix = / { print "prefix = \"ctrl+g\""; next }
      in_keys && /^copy_mode = / { print; next }
      in_keys && (/^[[:space:]]*#/ || /^[a-z_]+ = / || /^[[:space:]]*$/) { next }
      { print }
    ' "$HERDR_CONFIG" > "$HERDR_TMP"
    if cmp -s "$HERDR_TMP" "$HERDR_CONFIG"; then
      rm -f "$HERDR_TMP"
    else
      cp "$HERDR_CONFIG" "$HERDR_CONFIG.dotfiles.bak"
      cp "$HERDR_TMP" "$HERDR_CONFIG"
      rm -f "$HERDR_TMP"
      if command -v herdr >/dev/null 2>&1 && ! herdr config check >/dev/null 2>&1; then
        mv "$HERDR_CONFIG.dotfiles.bak" "$HERDR_CONFIG"
        printf "  herdr config check failed; key alignment reverted\n" >&2
      else
        rm -f "$HERDR_CONFIG.dotfiles.bak"
        # A running server keeps the old keys until it reloads.
        herdr server reload-config >/dev/null 2>&1 || true
      fi
    fi
  fi

  # The mac IdentityAgent path does not exist here, so ~/.ssh/config is generated
  # from the repo's file with the 1Password Linux socket instead of linked. An
  # existing file that is not a generated one (omarchy or the user wrote it) is
  # moved aside once.
  printf "Generating ssh config...\n"
  readonly SSH_CONFIG="$HOME/.ssh/config"
  readonly SSH_MARKER="# Generated by dotfiles scripts/link.sh from config/ssh/config. Do not edit."
  readonly SSH_TMP="$(mktemp)"
  {
    printf "%s\n" "$SSH_MARKER"
    sed 's|"~/Library/Group Containers/[^"]*"|~/.1password/agent.sock|' "$REPO_DIR/config/ssh/config"
  } >"$SSH_TMP"
  mkdir -p "$HOME/.ssh/conf.d"
  chmod 700 "$HOME/.ssh"
  if ! cmp -s "$SSH_TMP" "$SSH_CONFIG"; then
    if [ -f "$SSH_CONFIG" ] && ! grep -qF "$SSH_MARKER" "$SSH_CONFIG"; then
      mv "$SSH_CONFIG" "$SSH_CONFIG.omarchy.bak"
      printf "  moved aside: %s -> %s\n" "$SSH_CONFIG" "$SSH_CONFIG.omarchy.bak"
    fi
    install -m600 "$SSH_TMP" "$SSH_CONFIG"
  fi
  rm -f "$SSH_TMP"

  # omarchy owns the login shell and seeds ~/.bashrc, so zsh is entered from
  # there rather than through chsh or a replaced ~/.bashrc. Interactive-only:
  # Claude Code snapshots ~/.bashrc non-interactively, and an exec there would
  # replace that shell. exec keeps the variables omarchy's bash already exported.
  printf "Handing interactive bash over to zsh...\n"
  readonly BASHRC="$HOME/.bashrc"
  readonly BASHRC_MARKER="# dotfiles: hand interactive shells over to zsh"
  if [ ! -f "$BASHRC" ] || ! grep -qF "$BASHRC_MARKER" "$BASHRC"; then
    cat >>"$BASHRC" <<EOF

$BASHRC_MARKER
if [[ \$- == *i* ]] && [[ -z \${ZSH_VERSION:-} ]] && command -v zsh >/dev/null 2>&1; then
  exec zsh
fi
EOF
  fi
fi

printf "All symlinks created successfully.\n"
