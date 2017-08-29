variable "image_name" {}
variable "key_id" {}
variable "name" {}
variable "rexray_token" {}
variable "tag" {}

variable "region" {
  default = "nyc1"
}

data "digitalocean_image" "elm-infra-base" {
  name = "${var.image_name}"
}

resource "digitalocean_droplet" "elm-manager" {
  image              = "${data.digitalocean_image.elm-infra-base.image}"
  name               = "${var.name}"
  region             = "${var.region}"
  size               = "1gb"
  ssh_keys           = ["${var.key_id}"]
  tags               = ["${var.tag}"]
  private_networking = true

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = "${file("id_rsa")}"
    }

    inline = [
      "docker plugin install --grant-all-permissions rexray/dobs DOBS_REGION=${var.region} DOBS_TOKEN=${var.rexray_token}",
    ]
  }
}

output "ipv4_address" {
  value = "${digitalocean_droplet.elm-manager.ipv4_address}"
}

output "private_ipv4_address" {
  value = "${digitalocean_droplet.elm-manager.private_ipv4_address}"
}
