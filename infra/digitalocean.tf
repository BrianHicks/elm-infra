variable "rexray_token" {}

variable "region" {
  default = "nyc1"
}

provider "digitalocean" {}

resource "digitalocean_ssh_key" "local" {
  name       = "local from elm-infra"
  public_key = "${file("id_rsa.pub")}"
}

/* MANAGERS */

resource "digitalocean_tag" "elm-manager" {
  # including this to future-proof. If we ever have followers, we should add a
  # related tag and use these to restrict traffic via the firewalls.
  name = "elm-manager"
}

module "manager-0-20170828-1" {
  source       = "manager"
  image_name   = "elm-infra-base_20170828-1"
  name         = "manager-0-20170828-1"
  tag          = "${digitalocean_tag.elm-manager.name}"
  key_id       = "${digitalocean_ssh_key.local.id}"
  region       = "${var.region}"
  rexray_token = "${var.rexray_token}"
}

resource "digitalocean_firewall" "elm-manager" {
  name = "elm-manager"
  tags = ["${digitalocean_tag.elm-manager.name}"]

  # these are in a wacky order because the DigitalOcean API considers these a
  # set and returns them in whatever order it likes. Terraform, on the other
  # hand, assumes that they're as specified by the last run. So we just need to
  # set our source order to the same implementation order of the API so we don't
  # get weird diffs.
  #
  # TODO: follow https://github.com/terraform-providers/terraform-provider-digitalocean/issues/30 and upgrade when it's fixed.
  inbound_rule = [
    {
      # SSH
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0", "::/0"]

      # TODO: lock down access with source_address?
    },
    {
      # HTTP
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      # HTTPS
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      # ping
      protocol         = "icmp"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      # docker
      protocol    = "tcp"
      port_range  = "all"
      source_tags = ["${digitalocean_tag.elm-manager.name}"]
    },
  ]

  outbound_rule = [
    {
      protocol              = "icmp"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "tcp"
      port_range            = "all"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "udp"
      port_range            = "all"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]
}
