#!/bin/bash
set -euo pipefail
helm uninstall grafana -n monitoring || true
echo "Waiting for resources to terminate..."
sleep 5
kubectl delete pvc -n monitoring -l app.kubernetes.io/name=grafana --ignore-not-found
