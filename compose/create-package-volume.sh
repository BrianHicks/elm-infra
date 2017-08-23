#!/usr/bin/env bash
set -euo pipefail

docker volume create \
       --driver=rexray/dobs \
       --opt size=4 \
       packages
