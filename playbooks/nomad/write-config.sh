#!/usr/bin/env bash
set -euo pipefail

PRIVATE_IPV4="$(curl -sSf http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)"

# echo "bind_addr = \\"\$PRIVATE_IPV4\\"" > /etc/nomad/config.hcl
cat > /etc/nomad/config.hcl <<EOF
data_dir = "/opt/nomad/data"

advertise {
  http = "$PRIVATE_IPV4"
  rpc  = "$PRIVATE_IPV4"
  serf = "$PRIVATE_IPV4"
}

server {
  enabled          = true
  bootstrap_expect = {{ groups.all | length }}
}

client {
  enabled = true
}

consul {
  address = "127.0.0.1:8500"
}
EOF
