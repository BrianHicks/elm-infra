#!/usr/bin/env bash
set -euo pipefail

PORT=4646
HOST="$(./iac/inventory.py --host leader-0 | jq -r '.ipv4_address')"
USER="$(./iac/inventory.py --host leader-0 | jq -r '.ansible_user')"
KEY="$(./iac/inventory.py --host leader-0 | jq -r '.ansible_ssh_private_key_file')"

echo "================================================================================="
echo "I'm proxying port $PORT! Don't close this shell until you're done with that port."
echo "================================================================================="
echo

ssh -L "$PORT:localhost:$PORT" -i "$KEY" "$USER@$HOST"
