#!/usr/bin/env bash
set -euo pipefail

# base dependencies
apt-get update
apt-get install --yes apt-transport-https ca-certificates curl software-properties-common
