# Volume Problems

You may see log lines in `journalctl -lu docker | less` that indicate a volume cannot be detached.
If a volume won't detach you may need to manually do it with the `rexray` CLI (should be present in the image.)

Run `rexray volume ls` after setting authentication environment variables and `REXRAY_SERVICE=dobs`.

If the volume is marked as attached/mounted, you should run `rexray volume detach {name_or_id}`.

The volume should then be available for attachment/mounting elsewhere in the cluster.
