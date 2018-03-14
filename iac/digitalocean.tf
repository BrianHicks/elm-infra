/* PROVIDERS */

variable "digitalocean_token" {}

provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

/* VARIABLES */

variable "public_key" {}
variable "private_key" {}

variable "region" {
  default = "nyc1"
}

resource "digitalocean_ssh_key" "local" {
  name       = "local from elm-infra"
  public_key = "${file(var.public_key)}"
}

/* SERVERS */

resource "digitalocean_tag" "leader" {
  name = "leader"
}

resource "digitalocean_droplet" "leader" {
  count = 3

  image              = "ubuntu-16-04-x64"
  name               = "leader-${count.index}"
  region             = "${var.region}"
  size               = "s-1vcpu-1gb"
  tags               = ["${digitalocean_tag.leader.id}"]
  ssh_keys           = ["${digitalocean_ssh_key.local.id}"]
  private_networking = true

  lifecycle {
    # we're managing volume attachments dynamically, and if we let Terraform
    # manage them it'll detach volumes willy nilly every time we apply. We have a
    # little more nuance than that, so we need to ignore it here.
    ignore_changes = ["volume_ids"]
  }
}

resource "digitalocean_firewall" "web" {
  name = "web"

  droplet_ids = ["${digitalocean_droplet.leader.*.id}"]

  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "1-65535"
      source_addresses = ["${digitalocean_droplet.leader.*.ipv4_address_private}"]
    },
    {
      protocol         = "udp"
      port_range       = "1-65535"
      source_addresses = ["${digitalocean_droplet.leader.*.ipv4_address_private}"]
    },
  ]

  outbound_rule = [
    {
      protocol              = "tcp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "udp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "icmp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]
}
