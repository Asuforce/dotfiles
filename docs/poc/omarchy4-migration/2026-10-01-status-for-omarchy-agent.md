# Status for the agent working on the omarchy machine

Written 2026-10-01 on the mac. Read this first, then the 2026-09-28 files it
points to for the reasoning behind each decision. Update the "Implemented"
section whenever a change lands, and move items out of "Open decisions" once
the user settles them.

## Implemented

One change so far, covering the OS branch and the shell hand-over. Everything
else below is decided but not written.

```text
make all
├── Darwin: xcode → link → brew → macos → llm → runtime
└── Linux : link → llm → runtime              (xcode, brew, macos skip)

scripts/link.sh
├── both   : zsh, tig, sheldon, bat, zsh-abbr
├── Darwin : ghostty, herdr, git, nvim, starship, btop, ssh, karabiner,
│            hammerspoon, /etc/shells, diff-highlight
└── Linux  : keyd (pacman install, /etc/keyd/default.conf copied from
             config/keyd, service enabled), marked blocks appended to
             ~/.config/hypr/input.lua (ctrl:nocaps, no compose:caps) and
             ~/.config/fcitx5/config (Henkan/Muhenkan), and ~/.bashrc gets
             a guarded `exec zsh` block (marker comment)

scripts/llm.sh
├── settings.json : no longer tracked (llm/settings.json is deleted);
│                   created as `{}` when absent, and only the hook
│                   registrations edit it, with jq
└── skills        : linked one by one into ~/.claude/skills; a legacy
                    directory-level link to llm/skills is replaced

scripts/runtime.sh : installs mise through brew on Darwin only; on Linux it
                     exits with a message if mise is missing
config/zsh/zshrc   : the Homebrew PATH block runs on Darwin only
```

`link_config` in `link.sh` prints `skipped, already exists: <path>` when it
meets a path it did not create. On omarchy that line means the distro seeded the
file first and the repo's version is not applied.

## Not implemented yet

Decided in the 2026-09-28 files; none of it exists in the repo.

- Linux package list and the script that feeds it to `omarchy pkg add` and
  `yay -S --needed` (2026-09-28-package-management.md). `make brew` skips on
  Linux until then. Without zsh installed the `.bashrc` guard keeps bash; once
  zsh is installed without `sheldon`, `~/.zshrc` errors at `sheldon source`, and
  `ghq` and `git-delta` stay missing.
- Linux handling for git and ssh: an `[include]` split for the 1Password signing
  program, and `UseKeychain` plus the `IdentityAgent` path in `config/ssh/config`
  (2026-09-28-config-file-precedence.md). `link.sh` links neither on Linux, so
  git signing and the repo's aliases are not in effect there.
- The herdr prefix patch to `ctrl+g` with `herdr config check`
  (2026-09-28-herdr-integration.md).
- A Ghostty install step (`omarchy-install-terminal ghostty`).
- zsh-side ports of omarchy's bash integration (2026-09-28-shell-and-editor.md).
- `CLAUDE.md` and `README.md` still describe a mac-only repository.

## Verified and not verified

Verified on the omarchy machine: the 1Password SSH agent works and its key shows
in `ssh-add -L`.

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
6. In zsh, `source /usr/share/omarchy/default/bash/fns/herdr` and run `hdl` in a
   herdr pane; repeat for `fns/tmux`. Pass: no wrong or empty pane layout.
   zsh arrays start at 1, which these files do not account for.
7. `echo $BAT_THEME` and `bat <file>`. Pass: the output is acceptable with
   omarchy's `ansi` theme in place of the repo's `OneHalfDark`.
8. `omarchy-refresh-shell` (or the equivalent that rewrites `~/.bashrc`), then
   `tail -5 ~/.bashrc`. Pass: the marked block is still the last thing in the
   file. Anything appended below it never runs in an interactive shell, because
   `exec` has already replaced bash; if the block is gone or no longer last,
   remove it and re-run `make link`.

## Open decisions

The user has not settled these. Do not choose for them.

- Ghostty config: include a shared repo file through `config-file = ?...`, or use
  omarchy's config only.
- Whether `ttf-hackgen` is wanted, or omarchy's JetBrainsMono Nerd Font is enough.
- Whether the terraform (aqua, tfenv) PATH lines in `zshrc` and the gcloud fzf
  widget come to Linux. 2026-09-28-repo-structure.md keeps gcloud mac-only; the
  first version of 2026-09-28-shell-and-editor.md wanted it ported.
- Whether to give up kube-ps1, which omarchy's own `starship.toml` replaces, or
  enable starship's `kubernetes` module.
