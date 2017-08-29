# Software Upgrades

When major versions of the VM software change, we should upgrade the image and re-roll the VMs to get a consistent and clean environment.

## Upgrade the Image

1. Update the `snapshot_name` in `packer/base-image.json`
2. Run `packer validate packer/base-image.json` to make sure you have a good manifest.
3. Run `packer build packer/base-image.json` to build the new image.
   If there's a snapshot name conflict, you'll need to remove the old image

If you delete an image: be careful that there are no VMs running it.
We won't be able to recreate them from the image if you delete the image without migrating them.

## Re-Roll the VMs

Follow the instructions in the adding and retiring nodes playbooks.
