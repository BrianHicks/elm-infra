#!/usr/bin/env bash
set -euo pipefail

HOST="$(./iac/inventory.py --host leader-0 | jq -r '.ipv4_address')"
USER="$(./iac/inventory.py --host leader-0 | jq -r '.ansible_user')"
KEY="$(./iac/inventory.py --host leader-0 | jq -r '.ansible_ssh_private_key_file')"

echo "==================================="
echo "I'm proxying cluster communication!"
echo "==================================="
echo

ssh -L 4646:localhost:4646 -L 8500:localhost:8500 -i "$KEY" "$USER@$HOST"
