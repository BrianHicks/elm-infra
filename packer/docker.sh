#!/usr/bin/env bash
set -euo pipefail

# Docker

## install and verify key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88 | grep '9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88' > /dev/null

## install Docker repo
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update

## install Docker community edition
apt-get install --yes docker-ce=17.06.0~ce-0~ubuntu

## test installation
docker run --rm hello-world
docker rmi hello-world
