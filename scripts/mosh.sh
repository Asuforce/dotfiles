#!/bin/bash

set -euo pipefail

# omarchy's ufw denies incoming by default, and mosh logs in over ssh before
# switching to a UDP port from this range. A failed rule must not abort make all.
if systemctl is-active --quiet ufw; then
  printf "Opening ssh and mosh in ufw...\n"
  sudo ufw allow 22/tcp comment ssh &&
    sudo ufw allow 60000:61000/udp comment mosh ||
    printf "Could not add the ufw rules; run the two commands above by hand.\n"
fi
