terraform.tfstate: coreos/config.json
	terraform apply

coreos/config.json: coreos/config.yaml
	ct --platform=digitalocean < $^ > $@
