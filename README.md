# elm-infra

Infrastructure for elm-lang.org

## Getting started

Install [pipenv](https://docs.pipenv.org) and then run `pipenv install` and `pipenv shell`.
Now you have ansible and everything else you need installed.
Hooray!

Next time you start the project, run `pipenv shell` in the directory, and that's it.

## Doing Stuff

### Bringing up new hosts

We need Python to run most of Ansible's stuff.
New hosts don't start out with Python installed, so you'll want to do that first.
Once you have the servers up (`cd iac; terraform apply`) you'll need to create your inventory (instructions TODO) and run the bootstrap-python.yaml playbook:

```
ansible-playbook -i inventory.yaml playbooks/bootstrap-python.yaml
```

## Glossary

- `iac`: Infrastructure as Code. Terraform, mostly. This may inclue Packer someday too.

## License

Licensed under the please don't use this yet it's not ready license.
Probably BSD-3 eventually.
