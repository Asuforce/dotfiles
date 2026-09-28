# Keep bash + omarchy-nvim on omarchy; don't port the zsh/LazyVim-alternative setup

Considered bringing zsh + sheldon + zsh-abbr over to match mac exactly.
Rejected: omarchy's `default/bash/` ships real integration this repo would
otherwise lose — herdr layout helpers (`hdl`/`hds`/`hdlm`/`hsl`), `alias
h='herdr'`, an ssh-reconnect wrapper, eza-based `ls`, and a zoxide-backed
`cd`/`zd` function — none of it ported to zsh (`omarchy-zsh` exists as a
package but doesn't carry these functions). Matches the general "stay close
to omarchy's recommended environment" preference for this machine.

Considered bringing this repo's hand-written `config/nvim/init.lua` (lazy.nvim
+ onedark + nvim-tree) instead of omarchy's default. Rejected: omarchy ships
`omarchy-nvim`, a maintained LazyVim setup wired into omarchy's own theme
switching. Using it means give up mac-identical nvim keybindings on omarchy;
worth it to stay on the maintained path instead of hand-rolling a second
config to keep in sync.

Gaps in omarchy's bash defaults that still need porting: ghq repo switcher,
git branch switcher, gcloud project switcher (zoxide/file-search/history fzf
widgets are already covered natively). New file `config/bash/rc` holds them,
appended into `~/.bashrc`'s user section via one idempotent `source` line —
not a symlink over `~/.bashrc` itself, since omarchy seeds that file to source
its own `default/bash/rc` first.

Key assignment: `ctrl+r`/`ctrl+t`/`alt+c` are taken by fzf's own
`key-bindings.bash`, `ctrl+g` is herdr's prefix, and `ctrl+[` is the ESC byte
(unusable in bash's `bind -x`). Proposed `ctrl+]` for the branch switcher
(currently unbound). Bash's `bind -x` can't submit the line directly the way
zsh's `zle accept-line` does — needs a helper macro that sends `\C-m`;
confirm the exact mechanism when implementing.
