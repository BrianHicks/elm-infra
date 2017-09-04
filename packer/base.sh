#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

# base dependencies
apt-get update
apt-get install --yes apt-transport-https ca-certificates curl software-properties-common htop

apt-get upgrade --yes --quiet
