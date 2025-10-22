#!/bin/bash
set -euo pipefail

# Add Grafana Helm repository (in case it's not added)
helm repo add grafana https://grafana.github.io/helm-charts || true
helm repo update

kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# Install Grafana Alloy (unified telemetry collector)
helm upgrade --install alloy grafana/alloy       --namespace monitoring       --set alloy.metrics.prometheus.enabled=true       --set alloy.logs.loki.enabled=true       --set alloy.traces.tempo.enabled=true       --set alloy.remoteWrite.url=http://mimir-gateway.mimir.svc.cluster.local/api/v1/push       --set alloy.loki.endpoint=http://loki-gateway.loki.svc.cluster.local/loki/api/v1/push       --set alloy.tempo.endpoint=http://tempo-distributor.tempo.svc.cluster.local:4317

echo "Alloy installed/updated."
kubectl get pods -n monitoring | grep alloy || true
