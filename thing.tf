variable "do_token" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "local" {
  name       = "local from elm-infra"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "digitalocean_droplet" "test" {
  image     = "coreos-stable"
  name      = "elm-infra-test"
  region    = "nyc3"
  size      = "512mb"
  user_data = "${file("coreos/config.json")}"
  ssh_keys  = ["${digitalocean_ssh_key.local.id}"]
}

output "address" {
  value = "${digitalocean_droplet.test.ipv4_address}"
}
