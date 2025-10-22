#!/bin/bash
set -euo pipefail
helm repo add grafana https://grafana.github.io/helm-charts || true
helm repo update
kubectl create namespace tempo --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install tempo grafana/tempo-distributed       --namespace tempo       --values ./values-tempo.yaml

# Create a compatibility Service named tempo-query-frontend:3200 to match Grafana datasource URL
kubectl apply -f ../manifests/tempo-query-frontend-compat-svc.yaml
kubectl get svc -n tempo | grep tempo-query-frontend || true
