# Elm Infra

Running Elm's websites in Docker so we can compose them a little bit better for reliability, etc.

## Docker Images

### `elm-dev`

This contains the Elm platform in Docker. Mostly using [this guide](https://github.com/elm-lang/elm-platform/blob/master/README.md).

### `elm-lang.org`

[elm-lang.org](http://elm-lang.org/), packaged as minimally as possible (no compilation artifacts aside from the binaries we need, etc)

### `package.elm-lang.org`

[package.elm-lang.org](http://package.elm-lang.org/), packaged as minimally as possible.
There is a major caveat here: the current (0.18) implementation of the package site works off a couple JSON files on disk.
This is a problem scaling up, and we'll see if that changes in the future.
For now, we're going to pretend it's stateless and add statefulness as needed.

## Packer

To get started, go grab a DigitalOcean account and API key, and set it in an environment variable:

```shell
DIGITALOCEAN_API_TOKEN="$(cat secure-token-location)"
```

Then run `packer validate packer/base-image.json`.
This will make sure you're set up.

If that runs successfully, you can run `packer build packer/base-image.json`.
This will create a base infrastructure node from which to create VMs.

## Terraform

Run `terraform init infra`.
Make sure you have your S3 keys set in the environment to pull down the state.

Then run `terraform plan infra` to see changes, and `terraform apply infra` to apply them.
The integration with swarm is not great right now since you can't seed the swarm token.
So if you're going to scale up, scale the managers first and then copy the swarm token into a variable somewhere and use it to bootstrap the workers.

## Playbooks

See playbooks under `playbooks/` for doing common operations.
