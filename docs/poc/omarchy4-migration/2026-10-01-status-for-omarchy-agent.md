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

adopt_config       : on Linux moves a regular file in the way to
                     <name>.omarchy.bak, then links (git config)
                     the legacy ~/.config/ghostty/config and ~/.ssh/config are
                     moved aside the same way

scripts/llm.sh     : settings.json untracked (created as `{}`, hooks merged
                     with jq); skills linked one by one
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
prefix is `ctrl+g`, and python and ruby install through mise.

Verified on the mac only, with `HOME` pointed at a temporary directory and `uname`
stubbed to report Linux: `link.sh`'s Linux branch is idempotent and reports
pre-existing files; the `.bashrc` block does not fire in a non-interactive
shell; the `llm.sh` merge keeps `theme` and `model`, unions permissions without
duplicates, and links every skill; a legacy directory-level skills link is
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
   to `ctrl+g` after the prefix patch exists. Until then the default is
   `ctrl+space`, which fcitx5 may already use for toggling input.
5. Open a new Ghostty window and run `echo $ZSH_VERSION`. Then, from Claude Code
   on the same machine, run a Bash tool command that prints `$0` and
   `$ZSH_VERSION`. Pass: zsh in the terminal, and the Bash tool still works
   without being replaced. `exec zsh` leaves `$SHELL` as bash, so the Bash tool
   runs under bash and sources `.bashrc`, not `.zshrc`; PATH entries that exist
   only in `zshrc` (`$GOPATH/bin`, the aqua bin) are not visible to it. Note
   whether any tool the agent needs is missing there.
6. `echo $BAT_THEME` and `bat <file>`. Pass: the output is acceptable with
   omarchy's `ansi` theme in place of the repo's `OneHalfDark`.
7. `omarchy-refresh-shell` (or the equivalent that rewrites `~/.bashrc`), then
   `tail -5 ~/.bashrc`. Pass: the marked block is still the last thing in the
   file. Anything appended below it never runs in an interactive shell, because
   `exec` has already replaced bash; if the block is gone or no longer last,
   remove it and re-run `make link`.

## Open decisions

The user has not settled these. Do not choose for them.

- Whether the terraform (aqua, tfenv) PATH lines in `zshrc` and the gcloud fzf
  widget come to Linux. 2026-09-28-repo-structure.md keeps gcloud mac-only; the
  first version of 2026-09-28-shell-and-editor.md wanted it ported.
- Whether to give up kube-ps1, which omarchy's own `starship.toml` replaces, or
  enable starship's `kubernetes` module.
