# herdr on omarchy: use the shipped herdr, patch only the prefix key

Initially assumed herdr's pane/tab model was a mac-side import that might
clash with Hyprland's own tiling. That turned out to be wrong: herdr ships in
`install/omarchy-base.packages` and is a default of omarchy4 (Quattro) — DHH
confirmed on X ("Herdr is shipping as part of Omarchy Quattro"), and omarchy
wires it deeply (Hyprland keybind `SUPER+CTRL+RETURN`, a keybinding-help menu,
theme sync across `herdr machine list`). It runs inside whatever terminal
omarchy launches.

Revised 2026-10-01: the same log first claimed Ghostty needs no install. It is
not in the base packages (the default terminal is foot), and the user wants
Ghostty on this machine. `omarchy-install-terminal ghostty` installs it from
`extra`, copies omarchy's own Ghostty config when `~/.config/ghostty` is
missing, and rewrites `~/.config/xdg-terminals.list` so Super+Return opens it.
See 2026-09-28-config-file-precedence.md for which Ghostty config applies.

Considered symlinking this repo's mac-style `config/herdr/config.toml`
(minimal: theme + `prefix=ctrl+g` + ui bits, relying on herdr's own built-in
keybinding defaults) onto omarchy. Rejected after reading omarchy's own
shipped `config/herdr/config.toml`: it's a large, deliberately-built keymap
that mirrors omarchy's tmux config 1:1 (every split/resize/tab/workspace
action individually bound to match tmux muscle memory). Replacing it with the
sparse mac file would throw away that entire keymap.

Picked instead: keep omarchy's seeded `config.toml` as the base, apply only
an idempotent patch to the `[keys] prefix` line (default in omarchy's file is
`ctrl+space`; herdr's own tool-level default is `ctrl+b` — neither is what we
want), changing it to `ctrl+g` to match mac muscle memory. Same shape as how
`llm.sh` already merges into `~/.claude/settings.json` with `jq`, except TOML
needs a guarded `sed` instead, validated with `herdr config check`.

IME-related experimental settings (`reveal_hidden_cursor_for_cjk_ime`,
`cjk_ime_agents`) intentionally left out of the patch for now — cross-platform
support isn't confirmed. `switch_ascii_input_source_in_prefix` is confirmed
macOS/Windows-only (no-op elsewhere) per herdr's own docs, so it's harmless to
leave in a shared file if it ever ends up in one, but doesn't help on Linux
either. Revisit after first boot: verify `ctrl+g` actually reaches herdr while
fcitx5/Mozc is active; add the IME keys to the patch if cursor-tracking turns
out to need them.

`omarchy-refresh-config` (which `omarchy-refresh-herdr` calls) does `cp -f`
through a symlink, so a user-triggered "reset herdr config" would overwrite
the patched file's on-disk content — recoverable via `git status`/`git
checkout` since it's tracked, but only if noticed. No migration was found
that calls this automatically for herdr, so the risk is manual-trigger-only.
