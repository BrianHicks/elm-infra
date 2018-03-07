variable "image" {}
variable "key_id" {}
variable "private_key" {}
variable "name" {}
variable "tag" {}
variable "region" {}

data "digitalocean_image" "elm-infra-base" {
  name = "${var.image}"
}

resource "digitalocean_droplet" "worker" {
  image              = "${data.digitalocean_image.elm-infra-base.image}"
  name               = "${var.name}"
  region             = "${var.region}"
  size               = "1gb"
  ssh_keys           = ["${var.key_id}"]
  tags               = ["${var.tag}"]
  private_networking = true

  lifecycle {
    ignore_changes = [
      # we're managing volume attachments with Kubernetes, and if we let
      # Terraform manage them it'll detach volumes willy nilly every time we
      # apply. We have a little more nuance than that, so we need to ignore it
      # here.
      "volume_ids",
    ]
  }
}
