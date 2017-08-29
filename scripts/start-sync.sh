#!/usr/bin/env bash
set -euo pipefail

IP="${1:-}"
if test -z "$IP"; then
    echo "you need to provide the host IP for connection"
    exit 1
fi

while true; do
    find compose -type f | entr -cd rsync -rzv compose root@"$IP":~/
done
