#!/bin/bash
set -euo pipefail
helm repo add grafana https://grafana.github.io/helm-charts || true
helm repo update
kubectl create namespace mimir --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install mimir grafana/mimir-distributed       --namespace mimir       --values ./values-mimir.yaml
kubectl get svc -n mimir | grep mimir || true
