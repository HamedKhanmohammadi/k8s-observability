#!/bin/bash
set -euo pipefail

# Add Grafana Helm repository
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Ensure namespace exists
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# Deploy Grafana with custom configuration
helm upgrade --install grafana grafana/grafana       --namespace monitoring       --values ./grafana.yaml

echo "Grafana install/upgrade triggered. Checking service..."
kubectl get svc -n monitoring grafana -o wide || true
