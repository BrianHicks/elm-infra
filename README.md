# Elm Infra

Running Elm's websites in Docker so we can compose them a little bit better for reliability, etc.

## Docker Images

Docker ([docker.com](https://www.docker.com/)) is basically the backbone of this project.
It lets you create (semi-) reproducible builds and ship those built artifacts around.
It also does process management both locally and distributed (we use swarm-mode.)
In our configuration, it also does [layer 4 (TCP) load balancing](https://www.nginx.com/resources/glossary/layer-4-load-balancing/)
We use [Traefik](https://traefik.io/) to do [layer 7 (HTTP) load balancing](https://www.nginx.com/resources/glossary/layer-7-load-balancing/) and routing.

Docker containers run images, and images are built with `Dockerfile`s.
Those live in `docker` at the following locations:

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

Packer: [packer.io](http://packer.io/).
It creates VM images in whatever cloud you like so that you can spin up instances super quickly.
We use it to bake in OS updates and our configuration so we can launch and replace individual hosts without too much bother or wait for provisioning.

To get started, go grab a DigitalOcean account and API key, and set it in an environment variable:

```shell
DIGITALOCEAN_API_TOKEN="$(cat secure-token-location)"
```

Then run `packer validate packer/base-image.json`.
This will make sure you're set up.

If that runs successfully, you can run `packer build packer/base-image.json`.
This will create a base infrastructure node from which to create VMs.

## Terraform

Terraform: [terraform.io](https://www.terraform.io/).
It creates and coordiantes cloud infrastructure (firewalls, VMs, etc.)
It can also manage DNS, but we do this by hand.
The main benefit here is that we can see diffs of what's running vs what should be running.

Run `terraform init infra`.
Make sure you have your S3 keys set in the environment to pull down the state.

Then run `terraform plan infra` to see changes, and `terraform apply infra` to apply them.
The integration with swarm is not great right now since you can't seed the swarm token.
So if you're going to scale up, scale the managers first and then copy the swarm token into a variable somewhere and use it to bootstrap the workers.

## Playbooks

See playbooks under `playbooks/` for doing common operations.
