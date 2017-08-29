#!/usr/bin/env bash
set -euo pipefail

IP="${1:-}"
if test -z "$IP"; then
    echo "you need to provide the host IP for connection"
    exit 1
fi

ssh -i id_rsa -L 8080:127.0.0.1:8080 root@"$IP"
