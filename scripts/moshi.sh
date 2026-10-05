#!/bin/bash

set -euo pipefail

# The installer's first-run prompt defaults usage collection and background
# discovery to on, so it is skipped; run `moshi-hook set --first-run` to choose.
if [ -x "$HOME/.local/bin/moshi-hook" ]; then
  printf "✓ moshi-hook already installed (the daemon updates itself)\n"
else
  printf "Installing moshi-hook...\n"
  curl -fsSL https://getmoshi.app/install.sh | MOSHI_HOOK_SKIP_FIRST_RUN=1 sh
fi

# mosh-server picks a UDP port from this range for each session.
if systemctl is-active --quiet ufw; then
  printf "Opening mosh's UDP range in ufw...\n"
  sudo ufw allow 60000:61000/udp comment mosh
fi

printf "\nPairing needs the phone: run 'moshi-hook host setup' and scan the QR in Moshi.\n"
printf "For Claude Code hooks: moshi-hook install --target claude\n"
