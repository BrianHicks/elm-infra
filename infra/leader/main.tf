variable "image" {}
variable "key_id" {}
variable "private_key" {}
variable "name" {}
variable "tag" {}
variable "region" {}

data "digitalocean_image" "elm-infra-base" {
  name = "${var.image}"
}

resource "digitalocean_droplet" "leader" {
  image    = "${data.digitalocean_image.elm-infra-base.image}"
  name     = "${var.name}"
  region   = "${var.region}"
  size     = "s-1vcpu-1gb"
  ssh_keys = ["${var.key_id}"]
  tags     = ["${var.tag}"]

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
      private_key = "${file(var.private_key)}"
    }

    inline = [
      "kubeadm init --apiserver-advertise-address=${digitalocean_droplet.leader.ipv4_address} --node-name=${var.name}",

      # enable admin access for the login user
      "mkdir -p $HOME/.kube",

      "cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
      "chown $(id -u):$(id -g) $HOME/.kube/config",

      # install the Weave plugin
      "kubectl apply -f \"https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')\"",
    ]
  }
}

output "ipv4_address" {
  value = "${digitalocean_droplet.leader.ipv4_address}"
}
