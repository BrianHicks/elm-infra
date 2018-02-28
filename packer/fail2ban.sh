#!/usr/bin/env bash
set -euo pipefail

# dependencies
apt-get install --yes fail2ban

# we don't do any special configuration for fail2ban since the only port fail2ban
# can help us with is ssh on our particular stack.
