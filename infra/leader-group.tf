resource "digitalocean_tag" "elm-leader" {
  # including this to future-proof. If we ever have followers, we should add a
  # complimentary tag and use these to restrict traffic in the firewalls.
  name = "elm-leader"
}

# resource "digitalocean_firewall" "elm-leader" {
#   name = "elm-leader"
#   tags = ["${digitalocean_tag.elm-leader.name}"]

#   # these are in a wacky order because the DigitalOcean API considers these a
#   # set and returns them in whatever order it likes. Terraform, on the other
#   # hand, assumes that they're as specified by the last run. So we just need to
#   # set our source order to the same implementation order of the API so we don't
#   # get weird diffs.
#   #
#   # TODO: follow https://github.com/terraform-providers/terraform-provider-digitalocean/issues/30 and upgrade when it's fixed.
#   # TODO: the rest of https://kubernetes.io/docs/setup/independent/install-kubeadm/#check-required-ports as needed
#   inbound_rule = [
#     {
#       # SSH
#       protocol         = "tcp"
#       port_range       = "22"
#       source_addresses = ["0.0.0.0/0", "::/0"]
#     },
#     {
#       # ping
#       protocol         = "icmp"
#       port_range       = "all"
#       source_addresses = ["0.0.0.0/0", "::/0"]
#     },
#     {
#       # kubernetes API plane
#       protocol         = "tcp"
#       port_range       = "6443"
#       source_addresses = ["0.0.0.0/0", "::/0"]
#     },
#   ]

#   outbound_rule = [
#     {
#       protocol              = "icmp"
#       port_range            = "all"
#       destination_addresses = ["0.0.0.0/0", "::/0"]
#     },
#     {
#       protocol              = "tcp"
#       port_range            = "all"
#       destination_addresses = ["0.0.0.0/0", "::/0"]
#     },
#     {
#       protocol              = "udp"
#       port_range            = "all"
#       destination_addresses = ["0.0.0.0/0", "::/0"]
#     },
#   ]
# }
