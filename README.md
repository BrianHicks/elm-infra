# elm-infra

New infrastructure for elm-lang.org

## So, What's This All About?

Goals for the new infrastructure:

1. to be able to deploy a new version of a deployed thing really easily once running
2. the system should survive if one of the VMs goes away (e.g. due to Spectre mitigation)
3. set up for future expansion (e.g. package pre-publish service)

That lead me to these technology choices:

- **Terraform and Ansible** for bringing up VMs.

  The combination of these two mean that our complete infrastructure configuration is specified and checked in to git.
  This also means no more SSHing in to VMs to make changes or restart services by hand.

- **Docker** for packaging.

  Using Docker gives us runtime isolation and repeatable deploys.
  It means that when we say "I want `X` version of the package site" we always get `X` and the exact environment it was compiled in.
  It is also a bit more secure than running things on the host system.

  As a bonus, it makes upgrades and scaling much easier by separating concerns.
  We can have a cluster that just runs whatever containers we specify and routes them how we configure.

- **Nomad, Consul, and Traefik** for scheduling, running, and routing traffic to containers.

  Nomad allows you to specify a service by composing containers.
  We can check in the number of containers running, their environment variables, and all the versions of software they're running.

  Consul keeps track of where services are running, and Traefik reads that data to do inbound load balancing.

  All this is done based on the resources available.
  So if a VM becomes unresponsive or needs to be taken out for security updates, the running services will be moved to a healthy host automatically.

  As a bonus, when we need to scale beyond one container instance, we can just say that.

### What's a "server"?

The word "server" is really overloaded in this style of infrastructure.
There are three levels:

- **Virtual Machines (VMs)** at the cloud/host level.
  These are the things you pay DigitalOcean to give you.

- **Containers** inside the VMs.
  These are scheduled dynamically and contain the software that makes up the workload.

- **Services** inside the containers.
  These are things like the package site, which listen on a port and respond with data.

so for the technologies above:

- **Terraform and Ansible** deal with **Virtual Machines**

- **Docker** deals with **Containers**

- **Nomad, Consul, and Traefik** deal with **Services**

all this comes together to form a cluster.

## Using this Repo

Things you'll need (list will hopefully get shorter with time, not longer):

- [pipenv](https://docs.pipenv.org) (install then `pipenv install && pipenv shell`)
- [Docker](https://www.docker.com/community-edition) (for building containers)

Next time you start the project, run `pipenv shell` in the directory, and that's it.

## Doing Stuff

### Bringing up new hosts

Once you have the servers up (`cd iac; terraform apply`), run the `bootstrap-python.yaml` playbook:

```
ansible-playbook playbooks/main.yaml
```

And then wait for a while while they build.
Go get a coffee or something.

### Deploying services

TODO

## License

Licensed under the please don't use this yet it's not ready license.
Probably BSD-3 eventually.
