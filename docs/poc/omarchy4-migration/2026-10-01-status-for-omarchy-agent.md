# omarchy setup: what is implemented, why, and what is still owed

Written 2026-10-01 on the mac, revised 2026-10-02 on the omarchy machine. The
per-topic logs from 2026-09-28 (config precedence, herdr, llm, packages, repo
structure, shell and editor) were folded into this file once everything they
described had landed; they remain in git history. Update "Implemented" whenever
a change lands.

## Implemented

```text
make all
├── Darwin: xcode → link → brew → macos → llm → runtime
└── Linux : pkg → link → llm → runtime        (xcode, brew, macos skip)

scripts/pkg.sh     : config/packages/linux.txt → `omarchy pkg add` (official)
                     and `yay -S --needed` (aur)

scripts/link.sh
├── both   : zsh, tig, sheldon, bat, zsh-abbr, ghostty, starship, git (config,
│            ignore, os-<kernel> as ~/.config/git/os, which carries the
│            1Password signing program path)
├── Darwin : herdr, nvim, btop, ssh, karabiner, hammerspoon,
│            /etc/shells, diff-highlight, .gitconfig copies
└── Linux  : keyd, T2 Mac fixes, marked blocks in hypr/input.lua (Caps Lock as
             Control, trackpad, pointer speed) and hypr/bindings.lua
             (clipboard manager), hypr/monitors.lua scale 1, system
             monospace HackGen35 Console NF via omarchy-font-set,
             fcitx5/config (Muhenkan/Henkan), herdr
             [keys] cut to prefix = ctrl+g and copy_mode (guarded by
             `herdr config check`, followed by `herdr server reload-config`),
             ~/.ssh/config generated from config/ssh/config with the Linux
             1Password socket, ~/.bashrc guarded `exec zsh` block

adopt_config       : on Linux deletes a regular file in the way, then links
                     (git config); the legacy ~/.config/ghostty/config is
                     deleted too. ~/.ssh/config alone is moved to
                     config.omarchy.bak
scripts/llm.sh     : settings.json untracked (created as `{}` if absent; hooks
                     and statusLine merged with jq, each only when missing;
                     llm/permissions-allow.json unioned into
                     permissions.allow, Linux only); skills linked one by one. No theme or
                     model is written.
scripts/runtime.sh : mise owns ~/.config/mise/config.toml; python, node (lts)
                     and ruby are added with `mise use -g` unless the file
                     already names them.
```

`link_config` in `link.sh` prints `skipped, already exists: <path>` when it
meets a path it did not create. On omarchy that line means the distro seeded the
file first and the repo's version is not applied.

## Which side wins, per app

omarchy seeds its own defaults at several paths the repo also configures. There
is no single rule, so each overlap was decided on its own.

```text
git/config       repo wins. omarchy's is a minimal set whose alias names collide
                 with different definitions (`ci`). commit.gpgsign and the
                 1Password signing program live in the included git/os-<kernel>.
ghostty          repo wins on both OSes. omarchy's theme sync and JetBrainsMono
                 no longer apply; ttf-hackgen is in the package list.
herdr            omarchy's file stays; link.sh cuts [keys] to the prefix and
                 copy_mode so bindings match the mac. omarchy's tmux-mirroring
                 keymap made the same keys do different things on the two
                 machines.
btop             omarchy wins, untouched.
starship         repo wins (adopt_config replaces omarchy's file).
nvim             omarchy wins (omarchy-nvim, a maintained LazyVim setup); the
                 repo's init.lua stays mac-only.
mise config      mise owns it. omarchy seeds it and an old omarchy migration
                 `sed`s the node line, so a symlink into the repo would be
                 rewritten underneath it. Hence runtime.sh and no
                 runtime/config.toml.
ssh/config       generated, not linked: `UseKeychain` is a fatal bad option on
                 non-Apple OpenSSH (IgnoreUnknown covers it) and the
                 1Password socket path differs.
zsh, sheldon,    linked on both OSes; omarchy ships nothing at these paths.
tig, bat         BAT_THEME=ansi exported by omarchy overrides bat's --theme.
```

## Decisions and the alternatives dropped

- One repo for both machines, branching on `uname -s`, rather than a second
  omarchy-only repo. OS is cheap to detect, unlike the `personal` flag, which
  is a policy choice. Work-only config (`.gitconfig-work`, `zshrc.work`, the
  gcloud widget, terraform PATH lines) stays on the mac.
- Packages: a repo-owned list beside the `Brewfile`, not Nix. omarchy is a
  curated Arch distro and Nix would double-manage its packages. Symlinking onto
  omarchy's `omarchy-other.packages` was not possible: it is pacman-owned and
  `omarchy pkg add` does not read it. 1Password is not in omarchy's base
  packages, so it is an explicit entry; git and ssh depend on it.
- zsh stays the shell, entered from `~/.bashrc` with `exec zsh`, not `chsh` and
  not a bash port. bash has no equivalent of autosuggestions, abbr or the `zle`
  fzf widgets, and omarchy's scripts assume bash as the login shell. The
  `[[ $- == *i* ]]` guard keeps Claude Code's non-interactive snapshot, ssh
  commands and uwsm in bash. Variables omarchy exported carry into zsh; its
  aliases and functions (`hdl`/`hds`, eza `ls`, zoxide `cd`) do not and are not
  ported.
- Claude Code skills are linked one by one into `~/.claude/skills`, because
  omarchy creates that directory first. settings.json is untracked because the
  template had drifted from the mac's file and held per-machine choices.
- The mac-only `credential.helper` (gcm-core) was dropped outright; every
  tracked remote uses ssh.
- Ghostty is not in omarchy's base packages (the default terminal is foot);
  `omarchy-install-terminal ghostty` installs it and wires Super+Return.
- `blogsync` is not wanted on Linux. `hunk` is installed by hand in
  `~/.local/bin` and has no package source.
- Mac-only and left out: mas, lima, gnu-sed, grep, appcleaner, the-unarchiver,
  gitify, gpg-suite, hammerspoon, karabiner-elements, raycast.
- CSI-u keybinds for shift+enter are not added; herdr uses the kitty keyboard
  protocol. The repo's starship config applies.

## Verified

On the omarchy machine, 2026-10-01 and 2026-10-02: the 1Password SSH agent
works and `ssh -T git@github.com` authenticates; git resolves `gpg.ssh.program`
to `/opt/1Password/op-ssh-sign` through the include; `herdr config check` is ok,
the prefix is `ctrl+g`, and `herdr pane layout` (herdr 0.9.3) returns
`.result.layout.panes`; every package in `linux.txt` is installed; `link.sh`
re-runs with no `skipped` line; keyd is active; mise has python, node and ruby;
`zsh -ic` starts and leaves `EDITOR=nvim`; `BAT_THEME` is `ansi`; the Bash tool
runs under bash with `SHELL` still bash; `tail ~/.bashrc` ends with the marked
block.

## Still owed on the omarchy machine

1. In Ghostty with fcitx5/Mozc active, press herdr's prefix. Pass: herdr reacts
   to `ctrl+g`. A server started before the prefix patch keeps its old prefix
   until `herdr server reload-config`, which `make link` runs.
2. `bat <file>`. Pass: the output is acceptable with omarchy's `ansi` theme in
   place of the repo's `OneHalfDark`.
3. After `omarchy-reinstall-configs` or `omarchy-upgrade-to-quattro`, `tail -5
   ~/.bashrc`. Pass: the marked block is still the last thing in the file;
   anything below it never runs in an interactive shell. If it is gone or no
   longer last, remove it and re-run `make link`. (`omarchy-refresh-shell` only
   resets `shell.json`.)

`omarchy-refresh-config` does `cp -f` through a symlink, so a manual reset of a
linked config (git, ghostty) overwrites the repo's file. Nothing calls it
automatically for those paths, and `git status` shows the damage.

## Not implemented

- A Linux source for `hunk`.
- `~/.ssh/config` sets `IdentityAgent` for github.com only; add a `Host *`
  block if 1Password should serve other hosts.
