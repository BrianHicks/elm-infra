#!/usr/bin/env bash
echo "# generated by ingress.sh - do not edit!"
helm template charts/stable/nginx-ingress \
     --name=ingress \
     --namespace=ingress \
     --set rbac.create=true \
     --set controller.stats.enabled=true \
     --set controller.metrics.enabled=true
