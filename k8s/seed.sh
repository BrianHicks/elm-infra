#!/usr/bin/env bash
set -euo pipefail

# base dependencies
apt-get update
apt-get install --yes apt-transport-https ca-certificates curl software-properties-common

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

# install kubectl

## install and test kubectl
curl -L "https://storage.googleapis.com/kubernetes-release/release/v1.7.0/bin/linux/amd64/kubectl" > /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl
kubectl version --client > /dev/null

# kubelet and kubeadm

## install and verify key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt-key fingerprint A7317B0F | grep 'D0BC 747F D8CA F711 7500  D6FA 3746 C208 A731 7B0F' > /dev/null

## install Kubernetes repo
add-apt-repository "deb http://apt.kubernetes.io/ kubernetes-$(lsb_release -cs) main"
apt-get update

## install kubelet and kubeadm
apt-get install -y "kubelet=1.7.3-01" "kubeadm=1.7.3-01"

# Kubernetes!

## initialize kubernetes
kubeadm init --pod-network-cidr=192.168.0.0/16

## install config for the root user
mkdir -p "$HOME/.kube"
cp /etc/kubernetes/admin.conf "$HOME/.kube/config"
chown "$(id -u):$(id -g)" "$HOME/.kube/config"

## install calico (network)
kubectl apply -f http://docs.projectcalico.org/v2.4/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml

## make it so that master can schedule work on itself
kubectl taint nodes --all node-role.kubernetes.io/master-
