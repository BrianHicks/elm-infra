#!/usr/bin/env bash
set -euo pipefail

LEADER=${1:-}
WORKER=${2:-}

if test -z "$LEADER" || test -z "$WORKER"; then
   echo "usage: $0 leader_ip worker_ip"
   exit 1
fi

JOIN_COMMAND="$(ssh "root@$LEADER" "kubeadm token create --description '$WORKER' --ttl 30s --print-join-command")"
ssh "root@$WORKER" "$JOIN_COMMAND"
