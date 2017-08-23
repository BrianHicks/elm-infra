#!/usr/bin/env bash
set -euo pipefail

touch /etc/packages/done

for FILE in /etc/packages/*; do
    echo "Linking $FILE to $PWD/$(basename "$FILE")"
    ln -s "$FILE" "$(basename "$FILE")"
done

exec run-server -p 8000
