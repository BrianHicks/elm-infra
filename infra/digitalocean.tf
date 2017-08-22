provider "digitalocean" {}

resource "digitalocean_ssh_key" "local" {
  name       = "local from elm-infra"
  public_key = "${file("id_rsa.pub")}"
}

data "digitalocean_image" "elm-infra-base" {
  name = "elm-infra-base"
}

resource "digitalocean_droplet" "elm-manager" {
  image              = "${data.digitalocean_image.elm-infra-base.image}"
  name               = "elm-manager"
  region             = "nyc1"
  size               = "1gb"
  ssh_keys           = ["${digitalocean_ssh_key.local.id}"]
  tags               = ["${digitalocean_tag.elm-manager.id}"]
  private_networking = true

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "root"
      private_key = "${file("id_rsa")}"
    }

    inline = ["docker swarm init --advertise-addr=${digitalocean_droplet.elm-manager.ipv4_address_private} --listen-addr=${digitalocean_droplet.elm-manager.ipv4_address_private}:2377 --autolock"]
  }
}

resource "digitalocean_tag" "elm-manager" {
  # including this to future-proof. If we ever have followers, we should add a
  # related tag and use these to restrict traffic via the firewalls.
  name = "elm-manager"
}

resource "digitalocean_firewall" "elm-manager" {
  name        = "elm-manager"
  droplet_ids = ["${digitalocean_droplet.elm-manager.id}"]

  inbound_rule = [
    {
      # ping
      protocol = "icmp"
    },
    {
      # SSH
      protocol   = "tcp"
      port_range = "22"

      # TODO: lock down access with source_address?
    },
    {
      # HTTP
      protocol   = "tcp"
      port_range = "80"
    },
    {
      # HTTPS
      protocol   = "tcp"
      port_range = "443"
    },
  ]
  outbound_rule = [
    {
      protocol = "icmp"
    },
    {
      protocol   = "tcp"
      port_range = "all"
    },
    {
      protocol   = "udp"
      port_range = "all"
    },
  ]
}

output "address" {
  value = "${digitalocean_droplet.elm-manager.ipv4_address}"
}
