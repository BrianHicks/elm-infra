variable "do_token" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "local" {
  name       = "local from elm-infra"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "digitalocean_volume" "etcd" {
  region      = "nyc1"
  name        = "elm-etcd"
  size        = 1
  description = "etcd backup"
}

resource "digitalocean_droplet" "elm-leader" {
  image      = "ubuntu-16-04-x64"
  name       = "elm-leader"
  region     = "nyc1"
  size       = "1gb"
  ssh_keys   = ["${digitalocean_ssh_key.local.id}"]
  volume_ids = ["${digitalocean_volume.etcd.id}"]
  tags       = ["${digitalocean_tag.elm-leader.id}"]
}

resource "digitalocean_tag" "elm-leader" {
  # including this to future-proof. If we ever have followers, we should add a
  # related tag and use these to restrict traffic via the firewalls.
  name = "elm-leader"
}

resource "digitalocean_firewall" "elm-leader" {
  name        = "elm-leader"
  droplet_ids = ["${digitalocean_droplet.elm-leader.id}"]

  # note: this is the complete set of ports we need to have available. We
  # *don't* need to expose all of them. But if you need more access, here's
  # *where to add it!
  #
  # | Port Range   | Purpose                                     |
  # |==============|=============================================|
  # | 22           | SSH (should be exposed)                     |
  # | 80           | HTTP (should be exposed)                    |
  # | 443          | HTTPS (should be exposed)                   |
  # | 6443         | Kubernetes API server (should be exposed)   |
  # | 2379-2380    | etcd server client API (internal)           |
  # | 10250        | Kubelet API (internal)                      |
  # | 10251        | kube-scheduler (internal?)                  |
  # | 10252        | kube-controller-manager (internal?)         |
  # | 10255        | Read-only Kubelet API (Heapster) (internal) |
  #
  # from https://kubernetes.io/docs/setup/independent/install-kubeadm/

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
    {
      # Kubernetes API server
      protocol   = "tcp"
      port_range = "6443"
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

# note: when/if we add them, the worker nodes need:
#
# | Port Range  | Purpose                                  |
# |=============|==========================================|
# | 10250       | Kubelet API                              |
# | 10255       | Read-only Kubelet API (Heapster)         |
# | 30000-32767 | Default port range for NodePort Services |
#
# from https://kubernetes.io/docs/setup/independent/install-kubeadm/

output "address" {
  value = "${digitalocean_droplet.elm-leader.ipv4_address}"
}
