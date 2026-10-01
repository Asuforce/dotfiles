# Homebrew on mac, pacman+yay on omarchy, mise for shared runtimes

Considered Nix (nix-darwin + home-manager) for byte-identical packages across
both machines. Rejected: omarchy is already an opinionated, curated Arch
distro (pacman + AUR is omarchy's own official recommendation, confirmed via
the manual and DeepWiki), so a second declarative layer on top would just
double-manage the same packages. Revisit only if reproducibility across
machines becomes more valuable than following omarchy's own conventions.

For this repo's own CLI tools (bat, btop, eza, zoxide, ghq, delta, ...) on
omarchy: considered symlinking a package list onto omarchy's own
`install/omarchy-other.packages`. Rejected after reading omarchy's source —
that file lives under `/usr/share/omarchy/install/` and is omarchy's own
install-time manifest (pacman-owned in Quattro), not a user extension point;
`omarchy pkg add` doesn't even read it, and doesn't support AUR names either
(it's a thin `pacman -S --needed` wrapper, confirmed by reading
`bin/omarchy-pkg-add`).

Picked instead: this repo keeps its own declarative package list (parallel to
`Brewfile`), and a setup script loops over it calling `omarchy pkg add
<name>` for official-repo packages and `yay -S --needed <name>` directly for
AUR ones. Never touches any path omarchy itself owns.

1Password is not in `install/omarchy-base.packages` (confirmed by grep), so
it needs to be an explicit entry in that list — git/ssh config on omarchy
depend on it (see 2026-09-28-config-file-precedence.md).

Which repo tools omarchy already ships, and which repository each remaining one
comes from (checked 2026-10-01 against `omacom/omarchy@quattro`'s
`omarchy-base.packages` and the archlinux.org and AUR APIs):

```text
already in omarchy-base.packages (leave out of the Linux list)
  bat btop eza fd fzf git herdr jq lazydocker lazygit ripgrep starship zoxide
  obsidian neovim(nvim) mise(mise-bin) docker tmux ruby clang

official repo (extra), via `omarchy pkg add`
  argocd ghq git-delta go helix helm ipcalc jo k9s kubectx kubeseal kustomize
  kubectl php tig tree wget yq zsh sheldon ghostty

AUR, via `yay -S --needed`
  envchain go-jsonnet 1password 1password-cli google-chrome slack-desktop
  visual-studio-code-bin ttf-hackgen kube-ps1

not verified
  gh      no package of that name; likely `github-cli`
  hunk    (modem-dev/tap) Linux source unknown
  blogsync (songmu/tap) Linux source unknown
  watch   part of procps-ng, not a package of its own
```

Mac-only and left out: mas, lima, gnu-sed, grep, appcleaner, the-unarchiver,
gitify, gpg-suite, hammerspoon, karabiner-elements, raycast.
