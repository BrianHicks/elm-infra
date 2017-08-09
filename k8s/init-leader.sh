#!/usr/bin/env bash
set -euo pipefail

# Start Kubernetes!

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
