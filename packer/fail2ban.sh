#!/usr/bin/env bash
set -euo pipefail

# dependencies
apt-get install --yes fail2ban

# we don't do any special configuration for fail2ban since the only port
# fail2ban can only help us with SSHD on our particular stack.
