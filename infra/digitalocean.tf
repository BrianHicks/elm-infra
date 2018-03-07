# variable "rexray_token" {}

variable "region" {
  default = "nyc1"
}

variable "public_key" {}
variable "private_key" {}
variable "base_image" {}
variable "digitalocean_token" {}

provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "digitalocean_ssh_key" "local" {
  name       = "local from elm-infra"
  public_key = "${file(var.public_key)}"
}

/* LEADERS */

module "leader" {
  source = "leader"

  name        = "elm-leader"
  image       = "${var.base_image}"
  tag         = "${digitalocean_tag.elm-leader.name}"
  key_id      = "${digitalocean_ssh_key.local.id}"
  region      = "${var.region}"
  private_key = "${var.private_key}"
}

module "worker-alpha" {
  count = 1
  source      = "worker"
  name_prefix = "elm-worker"
  image       = "${var.base_image}"
  tag         = "${digitalocean_tag.elm-worker.name}"
  key_id      = "${digitalocean_ssh_key.local.id}"
  region      = "${var.region}"
  private_key = "${var.private_key}"
}
