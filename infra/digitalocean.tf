# variable "rexray_token" {}

variable "region" {
  default = "nyc1"
}

variable "base_image" {}
variable "digitalocean_token" {}

provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "digitalocean_ssh_key" "local" {
  name       = "local from elm-infra"
  public_key = "${file("id_rsa.pub")}"
}

/* LEADERS */

module "leader" {
  source = "leader"

  name   = "elm-leader"
  image  = "${var.base_image}"
  tag    = "${digitalocean_tag.elm-leader.name}"
  key_id = "${digitalocean_ssh_key.local.id}"
  region = "${var.region}"
}
