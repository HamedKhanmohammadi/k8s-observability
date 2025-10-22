#!/bin/bash
set -euo pipefail
helm repo add grafana https://grafana.github.io/helm-charts || true
helm repo update
kubectl create namespace loki --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install loki grafana/loki       --namespace loki       --values ./values-loki.yaml
kubectl get svc -n loki | grep loki || true
