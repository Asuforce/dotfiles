# Which config files win: repo vs omarchy's own seed, per app

omarchy seeds its own defaults for several apps this repo also configures,
at the identical XDG path (confirmed via `gh api
repos/omacom/omarchy/contents/config?ref=quattro`). Every overlap needed its
own call — there's no single rule, since the amount of divergence differs a
lot per app:

```text
config/                         fate on omarchy
├── git/config      (~/.config/git/config)
│                    → repo wins (force-overwrite)
│                      delta, ghq root, full alias set; omarchy's own is a
│                      minimal generic set, and some
│                      alias names collide with different definitions
│                      (e.g. `ci` = "commit" vs repo's "commit -v")
├── herdr/config.toml (~/.config/herdr/config.toml)
│                    → omarchy wins, repo patches one line
│                      see 2026-09-28-herdr-integration.md
├── starship/starship.toml
│                    → omarchy wins, untouched
├── ghostty/config.ghostty
│                    → omarchy wins for now; Ghostty is installed with
│                      `omarchy-install-terminal ghostty` (see
│                      2026-09-28-herdr-integration.md). The repo file is
│                      mac-only: `macos-*` options, `cmd` binds, HackGen,
│                      a fixed theme that would defeat omarchy's theme sync.
│                      Sharing part of it through `config-file = ?...` is
│                      an open decision (2026-10-01-status-for-omarchy-agent.md)
├── btop/btop.conf
│                    → omarchy wins, untouched
├── nvim/init.lua
│                    → omarchy wins (omarchy-nvim/LazyVim), repo file stays
│                      mac-only — see 2026-09-28-shell-and-editor.md
├── zsh/*, sheldon/*, tig/tigrc, bat/config
│                    → linked on both OSes, omarchy has no shipped default at
│                      these paths (zsh is entered from ~/.bashrc, see
│                      2026-09-28-shell-and-editor.md). `BAT_THEME=ansi`
│                      exported by omarchy overrides bat's `--theme`
└── ssh/config, hammerspoon/, karabiner/
                     → see below / mac-only (2026-09-28-repo-structure.md)
```

Within git config, one setting is mac-only and needs an OS split via
`[include] path = ...` (git supports this natively, silently skipping a
missing file — same mechanism as Ghostty's own `?config-file` include, which
is why this repo's Ghostty file could have used the same pattern if it were
still shared):

- `commit.gpgsign = true` + `gpg.ssh.program = /Applications/1Password.app/...`
  — the mac path, would fail every commit on Linux as-is. Needs the Linux
  1Password `op-ssh-sign` path (commonly `/opt/1Password/op-ssh-sign`) once
  1Password is added to the omarchy package list (see
  2026-09-28-package-management.md — it's not in omarchy's base packages).

`credential.helper` (`git-credential-manager`/gcm-core) no longer needs this
treatment: checking actual remotes across every tracked repo on the mac
machine turned up zero `https://` origins (all 24 are ssh), so the cask and
this config line were dead weight and got removed outright rather than
carried to omarchy.

`config/ssh/config` needs its own OS split: `UseKeychain yes` is a fatal
"Bad configuration option" error on non-Apple OpenSSH (would break ssh
entirely on omarchy, git-over-ssh included) — either `IgnoreUnknown
UseKeychain` or drop the line on Linux. The 1Password `IdentityAgent` socket
path also differs from the mac `~/Library/Group Containers/...` path.

Checked and ruled out as a real risk: `omarchy-refresh-config` is never
invoked automatically against `git/config` (no migration references it for
that path), so the git symlink isn't at risk from omarchy's own updates —
unlike herdr's config, which is (see 2026-09-28-herdr-integration.md).

`~/.config/mise/config.toml` is a smaller, lower-probability version of the
same class of risk: one historical omarchy migration does a one-time `sed`
on a `node = "x.y.z"`-shaped line in that file, which would match this repo's
own `runtime/config.toml` format if it's ever symlinked there. Low risk since
it's a single past migration, not a routine operation, but worth knowing
before assuming the symlink is inert.
