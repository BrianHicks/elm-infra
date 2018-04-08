# elm-infra

New infrastructure for elm-lang.org

## So, What's This All About?

Goals for the new infrastructure:

1. to be able to deploy a new version of a deployed thing really easily once running
2. the system should survive if one of the VMs goes away (e.g. due to Spectre mitigation)
3. set up for future expansion (e.g. package pre-publish service)

That lead me to these technology choices:

- **Terraform and Ansible** for bringing up VMs.

  *Why?* No more SSHing into VMs to make changes or restart services by hand (goals 1 and 2.)

  *Another Benefit:* All information about servers and their configuration are backed up and can be restored easily.

- **Docker** for packaging and dependency isolation.

  *Why?* Deploys are simpler and more reliable because Docker isolates runtime dependencies (goal 1.)
  Rollbacks become about as easy as deploys.

  *Another Benefit:* It's slightly more secure than we would be otherwise.

  *Long-term Benefit:* upgrading now gives us much more flexibility in the future.
  Almost all new DevOps/infrastructure tools use Docker and/or can run Docker containers.

- **Nomad, Consul, and Traefik** for scheduling, running, and routing traffic to containers.

  *Why?* If a VM goes away, the things it was running will automatically move somewhere else to minimize downtime (goals 1, 2, and 3.)

  *Another Benefit:* All information about running services is backed up and can be restored easily.
  We can also see what changes the system will make in advance.

  *Long-term Benefit:* New services can be added without making any changes to the underlying infrastructure.
  Existing services can be scaled up trivially to respond to an increase in traffic.

### Disambiguating "server"?

The word "server" is really overloaded in this style of infrastructure.
There are three levels:

- **Virtual Machines (VMs)** at the cloud/host level.
  These are the things you pay DigitalOcean for.

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

- [pipenv](https://docs.pipenv.org) (for Ansible and its dependencies)
- [Docker](https://www.docker.com/community-edition) (for building containers)
- [nomad](https://www.nomadproject.io/) (for deploying services)

To get started, `pipenv install && pipenv shell`.
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
