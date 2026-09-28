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
