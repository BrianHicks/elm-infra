# variable "rexray_token" {}

variable "region" {
  default = "nyc1"
}

variable "digitalocean_token" {}

provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "digitalocean_ssh_key" "local" {
  name       = "local from elm-infra"
  public_key = "${file("id_rsa.pub")}"
}

/* MANAGERS */


# module "manager-1-20170828-1" {
#   source       = "manager"
#   image_name   = "elm-infra-base_20170828-1"
#   name         = "manager-1-20170828-1"
#   tag          = "${digitalocean_tag.elm-manager.name}"
#   key_id       = "${digitalocean_ssh_key.local.id}"
#   region       = "${var.region}"
#   rexray_token = "${var.rexray_token}"
# }
