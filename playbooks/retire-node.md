# Retire a Node

1. Create a new node, as specified in the new node playbook.
2. Put the new node in DNS (note: only after you've joined Swarm! The routing mesh doesn't work otherwise!)
3. Wait for DNS to propagate 24 hours to make sure the new node is getting traffic.
4. Drain the old node: `docker node update --availability=drain $(hostname)`.
   Make absolutely sure the new node is marked as active and available before you do this, or you'll take down everything.
5. Take the old node out of DNS and wait for propagation again.
   During this time, the routing mesh will make sure traffic to any node is routed to the correct node.
6. Once traffic has sufficiently dropped off of the old node, step down as leader with `docker node demote $(hostname)`, then `docker swarm leave`.
7. Run `docker node rm {old hostname}` from the new manager node.
8. Finally, remove the old node's configuration in Terraform and plan/apply to remove it.
9. Play taps or something, the old node is gone.

## Downtime for Stateful Services

If there are stateful services on the cluster (at the time of this writing, `package.elm-lang.org` is stateful) they will probably not deal well with being drained.
We use REX-Ray to attach/detach volumes in a consistent way, so we shouldn't lose data (or, at least, fsynced data) but we will have a small downtime while those containers migrate to the new host.

You can minimize this by pre-pulling the image on the new machine (check the compose file for precisely what it is) and doing the migration at a low-traffic time.
Check when the monitoring says we have the lowest traffic and do it then.
