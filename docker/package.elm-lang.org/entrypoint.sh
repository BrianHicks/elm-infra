#!/usr/bin/env bash
set -euo pipefail

for FILE in /mnt/packages/*; do
    echo "Linking $FILE to $PWD/$(basename "$FILE")"
    ln -s "$FILE" "$(basename "$FILE")"
done

exec run-server -p 8000
