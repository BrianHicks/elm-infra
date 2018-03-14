#!/usr/bin/env bash
set -euo pipefail

HOSTNAME="${1:-}"
if test -z "$HOSTNAME"; then
    echo "argument (a host to connect to) is required"
    exit 1
fi

INFO="$(./iac/inventory.py --host "$HOSTNAME")"
IP="$(echo "$INFO" | jq -r '.ipv4_address')"
USER="$(echo "$INFO" | jq -r '.ansible_user')"
KEY="$(echo "$INFO" | jq -r '.ansible_ssh_private_key_file')"

exec ssh -i "$KEY" "$USER@$IP"
