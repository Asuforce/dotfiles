# Status for the agent working on the omarchy machine

Written 2026-10-01 on the mac. Read this first, then the 2026-09-28 files it
points to for the reasoning behind each decision. Update the "Implemented"
section whenever a change lands, and move items out of "Open decisions" once
the user settles them.

## Implemented

```text
make all
├── Darwin: xcode → link → brew → macos → llm → runtime
└── Linux : pkg → link → llm → runtime        (xcode, brew, macos skip)

scripts/pkg.sh     : config/packages/linux.txt → `omarchy pkg add` (official)
                     and `yay -S --needed` (aur)

scripts/link.sh
├── both   : zsh, tig, sheldon, bat, zsh-abbr, ghostty, git (config, ignore,
│            os-<kernel> as ~/.config/git/os, which carries the 1Password
│            signing program path)
├── Darwin : herdr, nvim, starship, btop, ssh, karabiner, hammerspoon,
│            /etc/shells, diff-highlight, .gitconfig copies
└── Linux  : keyd, marked blocks in hypr/input.lua and fcitx5/config, herdr
             prefix patched to ctrl+g (guarded by `herdr config check`),
             ~/.ssh/config generated from config/ssh/config with the Linux
             1Password socket, ~/.bashrc guarded `exec zsh` block

adopt_config       : on Linux deletes a regular file in the way, then links
                     (git config); the legacy ~/.config/ghostty/config is
                     deleted too. ~/.ssh/config alone is moved to
                     config.omarchy.bak

scripts/llm.sh     : settings.json untracked (created as `{}` if absent; hooks
                     and statusLine merged with jq, each only when missing);
                     skills linked one by one. No permissions, theme or model
                     are written.
scripts/runtime.sh : mise owns ~/.config/mise/config.toml; python, node (lts)
                     and ruby are added with `mise use -g` unless the file
                     already names them. runtime/config.toml is gone.
```

`link_config` in `link.sh` prints `skipped, already exists: <path>` when it
meets a path it did not create. On omarchy that line means the distro seeded the
file first and the repo's version is not applied.

Settled with the user on 2026-10-01: git `user.name` is `Shun Nishitsuji`;
Ghostty uses the repo's `config.ghostty` on Linux (omarchy's theme sync and
JetBrainsMono no longer apply; `ttf-hackgen` is in the package list); CSI-u
keybinds for shift+enter are not added, since herdr uses the kitty keyboard
protocol. omarchy's bash integration (aliases, `fns/`, `omarchy` completion,
inputrc) is not ported to zsh; zsh stays as the repo's own setup.

## Not implemented yet

- Linux sources for `hunk` and `blogsync`.
- `~/.ssh/config` no longer sets `IdentityAgent` for hosts other than
  github.com; add a `Host *` block if 1Password should serve them.

## Verified and not verified

Verified on the omarchy machine: the 1Password SSH agent works; after `make pkg
link llm runtime`, `ssh -T git@github.com` authenticates, git resolves
`gpg.ssh.program` to `/opt/1Password/op-ssh-sign` through the include, the herdr
prefix is `ctrl+g`, and python and ruby install through mise. Also observed:
`herdr pane layout` returns `.result.layout.panes` (herdr 0.8.2), `zsh -ic`
starts, installs the sheldon plugins on first run and leaves `EDITOR=nvim`,
`BAT_THEME` is `ansi`, and the Bash tool runs under bash with `SHELL` still
bash (`$ZSH_VERSION` empty).

Verified on the mac only, with `HOME` pointed at a temporary directory and `uname`
stubbed to report Linux: `link.sh`'s Linux branch is idempotent and reports
pre-existing files; the `.bashrc` block does not fire in a non-interactive
shell; the `llm.sh` hook merge adds each entry once and links every skill; a legacy directory-level skills link is
converted.

Read from `omacom/omarchy@quattro` and never run: everything about omarchy's
behaviour, including `omarchy-install-terminal`, `omarchy-refresh-shell`, the
bash defaults under `default/bash/`, and the package lists. Assumed, not
observed: `env-bootstrap` applies to a zsh login, and omarchy's bash files work
when sourced from zsh (they only pass `zsh -n`).

## Checks to run on the omarchy machine

Each line gives the command and what counts as a pass.

1. `make link llm` then read the output for `skipped, already exists`. Pass:
   no such line, or each one is understood. Look at `ls -la ~/.ssh
   ~/.config/mise ~/.claude ~/.config/git` first.
2. `herdr --version`, then inside a herdr pane `herdr pane layout --pane
   "$HERDR_PANE_ID"`. Pass: JSON with `.result.layout.panes`, which
   `llm/hooks/herdr-repo-workspace.sh` reads.
3. `ls /opt/1Password/op-ssh-sign`. Pass: the file exists. That is the path the
   Linux git config will need; a signed commit proves it once git is linked.
4. In Ghostty, with fcitx5/Mozc active, press herdr's prefix. Pass: herdr reacts
   to `ctrl+g`. A herdr server started before the prefix patch keeps
   `ctrl+space` until `herdr server reload-config` runs (`make link` now does
   that); before the reload, `ctrl+g` reached Claude Code, which opens
   `$EDITOR` on it.
5. Open a new Ghostty window and run `echo $ZSH_VERSION`. Then, from Claude Code
   on the same machine, run a Bash tool command that prints `$0` and
   `$ZSH_VERSION`. Pass: zsh in the terminal, and the Bash tool still works
   without being replaced. `exec zsh` leaves `$SHELL` as bash, so the Bash tool
   runs under bash and sources `.bashrc`, not `.zshrc`; PATH entries that exist
   only in `zshrc` (`$GOPATH/bin`, the aqua bin) are not visible to it. Note
   whether any tool the agent needs is missing there.
6. `echo $BAT_THEME` and `bat <file>`. Pass: the output is acceptable with
   omarchy's `ansi` theme in place of the repo's `OneHalfDark`.
7. After running `omarchy-reinstall-configs` or `omarchy-upgrade-to-quattro`
   (`omarchy-refresh-shell` only resets `shell.json` and leaves `~/.bashrc`
   alone), `tail -5 ~/.bashrc`. Pass: the marked block is still the last thing
   in the file. Anything appended below it never runs in an interactive shell,
   because `exec` has already replaced bash; if the block is gone or no longer
   last, remove it and re-run `make link`.

## Open decisions

None. Settled 2026-10-01: the terraform (aqua, tfenv) PATH lines and the gcloud
fzf widget stay mac-only, gated on Darwin in `zshrc`; kube-ps1 is dropped from
the `Brewfile` and the Linux list, and omarchy's starship config applies.
