# Manage mac and omarchy4 from one repo, branching by `uname -s`

Considered a separate omarchy-only repo instead, kept simpler by not sharing
anything. Rejected because mise/git/ssh/nvim-adjacent config and the `personal`
flag pattern in `Brewfile` are worth reusing as-is, and a second repo would
mean maintaining two copies of anything genuinely shared.

`scripts/link.sh`/`Makefile` gain an automatic Darwin/Linux branch (`uname -s`),
mirroring the existing arm64/x86 Homebrew-prefix detection — chosen over an
explicit `make link-omarchy` target because OS is an objective, cheap-to-detect
fact, unlike `personal` which is a real policy choice.

Target machine: a separate x86-64 PC/VM running omarchy4, personal-use only
(not a work machine) — used side by side with the existing mac, not replacing
it. `.gitconfig-work`, `zshrc.work`, and the gcloud fzf binding stay mac-only;
no omarchy equivalent is needed.

Hammerspoon and Karabiner (macOS-only automation/keyremap) are out of scope
for this pass — get the CLI/shell/editor/herdr layer working first, revisit
Hyprland keybinding design later if the omarchy machine sees daily use.

Decided not to keep a docs/adr convention for this project beyond this PoC
log; PR/commit messages carry ongoing detail.
