#!/usr/bin/env bash
set -euo pipefail

# Kubeadm

## install and verify key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

## install Kubernetes repo
add-apt-repository "deb http://apt.kubernetes.io/ kubernetes-$(lsb_release -cs) main"
# cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
# deb http://apt.kubernetes.io/ kubernetes-$(lsb_release -cs) main
# EOF

apt-get update

## install Kubeadm and Kubectl, but don't bootstrap a cluster!
apt-get install -y kubelet kubeadm kubectl

## TODO: how to smoke test? Is it even needed?
