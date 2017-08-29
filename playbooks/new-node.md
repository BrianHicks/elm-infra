# Creating a New Node

## With an Existing Swarm Cluster

You're going to want to join the new node to the Swarm cluster.

1. On an existing node, run `docker swarm join-token manager` (we don't do workers yet) to get the invocation to join the cluster.
   Add `--advertise-addr` and `--listen-addr` to these options (see why below.)
2. Add and customize a new manager block to `infra/digitalocean.tf`
3. Run `terraform get infra` from the root of the project to initialize the module for the new manager.
4. Run `terraform plan infra` to make sure you're only going to make the changes you intend to.
5. Run `terraform apply infra` to create the new node.
6. Once it's up, run the command you got in step 1 to join the new manager to the swarm.

If you're retiring an old node, follow that playbook too.

## With no Swarm Cluster

1. On the new cluster, run `docker swarm init --autolock --advertise-addr {private ip} --listen-addr {private ip}`
   Specifying these options because:

   - `--autolock` locks manager nodes in a way that we can just shut down manager nodes which may be compromised
   - `--advertise-addr` keeps traffic flowing over the private link, which does not incur additional bandwidth cost
   - `--listen-addr` only listens on the private link, instead of exposing the Swarm socket to the public (it's secured, but still! Why risk it?)
2. Take note of the swarm token, but do not commit it anywhere public.
   It's a secret!
   You can get any of the tokens again with `docker swarm join-token`.
