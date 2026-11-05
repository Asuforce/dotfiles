#!/bin/bash
set -euo pipefail

if [[ "$(uname -s)" != Linux ]]; then
  printf 'mcp-gdrive is Linux only.\n' >&2
  exit 1
fi

export GDRIVE_CREDS_DIR="$HOME/.config/mcp-gdrive"
keys="$GDRIVE_CREDS_DIR/gcp-oauth.keys.json"
if [[ ! -f "$keys" ]]; then
  printf 'Place Google Desktop App OAuth credentials at %s, then run bash %s to authenticate.\n' "$keys" "$0" >&2
  exit 1
fi
umask 077
export CLIENT_ID CLIENT_SECRET
CLIENT_ID="$(jq -er '.installed.client_id' "$keys")"
CLIENT_SECRET="$(jq -er '.installed.client_secret' "$keys")"
if [[ "${1:-}" == "--auth" ]]; then
  export GDRIVE_AUTH_SCRIPT="$(dirname "$(realpath "$0")")/mcp-gdrive-auth.mjs"
  exec npx -y --package @isaacphi/mcp-gdrive -c 'node "$GDRIVE_AUTH_SCRIPT" "$(command -v mcp-gdrive)"'
fi
exec npx -y @isaacphi/mcp-gdrive
