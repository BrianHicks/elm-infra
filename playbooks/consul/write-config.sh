#!/usr/bin/env bash
set -euo pipefail

PRIVATE_IPV4="$(curl -sSf http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)"

jq --arg ip "$PRIVATE_IPV4" \
   '. | .advertise_addr = $ip' \
   > /etc/consul/config.json \
   <<CONFIG
{
  "log_level": "INFO",
  "server": true,
  "ui": false,
  "data_dir": "/opt/consul/data",
  "bootstrap_expect": {{ groups.leader | length }},
  "client_addr": "127.0.0.1 172.17.0.1",
  "service": {
    "name": "consul"
  }
}
CONFIG
