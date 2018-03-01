variable "image" {}
variable "key_id" {}
variable "name" {}
variable "tag" {}
variable "region" {}

data "digitalocean_image" "elm-infra-base" {
  name = "${var.image}"
}

resource "digitalocean_droplet" "leader" {
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

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = "${file("id_rsa")}"
    }

    inline = [
      "echo pub:${digitalocean_droplet.leader.ipv4_address} priv:${digitalocean_droplet.leader.ipv4_address_private}",
    ]
  }
}

output "ipv4_address" {
  value = "${digitalocean_droplet.leader.ipv4_address}"
}

output "private_ipv4_address" {
  value = "${digitalocean_droplet.leader.ipv4_address_private}"
}
