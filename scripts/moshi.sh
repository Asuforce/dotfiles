#!/bin/bash

set -euo pipefail

if [ -x "$HOME/.local/bin/moshi-hook" ]; then
  printf "✓ moshi-hook already installed (the daemon updates itself)\n"
else
  printf "Installing moshi-hook...\n"
  # The installer's first-run prompt defaults usage collection to on; choose
  # later with `moshi-hook set --first-run`.
  curl -fsSL https://getmoshi.app/install.sh | MOSHI_HOOK_SKIP_FIRST_RUN=1 sh
fi

# omarchy's ufw denies incoming by default, and mosh logs in over ssh before
# switching to a UDP port from this range. A failed rule must not abort make all.
if systemctl is-active --quiet ufw; then
  printf "Opening ssh and mosh in ufw...\n"
  sudo ufw allow 22/tcp comment ssh &&
    sudo ufw allow 60000:61000/udp comment mosh ||
    printf "Could not add the ufw rules; run the two commands above by hand.\n"
fi

printf "\nPairing needs the phone: run 'moshi-hook host setup' and scan the QR in Moshi.\n"
printf "For Claude Code hooks: moshi-hook install --target claude\n"
