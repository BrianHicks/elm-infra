#!/usr/bin/env bash
# TODO: evaluate and/or remove
set -euo pipefail

# install rexray
curl -sSL https://dl.bintray.com/emccode/rexray/install | sh

# disable rexray system service (we install it after creating an instance via Terraform)
systemctl disable rexray

# create wrapper script
cat > /usr/local/bin/rexray <<EOF
#!/usr/bin/env bash
set -euo pipefail

export REXRAY_SERVICE="dobs"
export DOBS_REGION="\$(curl http://169.254.169.254/metadata/v1/region)"

if test -z "\$DOBS_TOKEN"; then echo '"DOBS_TOKEN" is not set, but is required'; exit 1; fi

exec /usr/bin/rexray "\$@"
EOF
chmod +x /usr/local/bin/rexray
