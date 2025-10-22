#!/bin/bash
set -euo pipefail
echo "[PODS]"
kubectl get pods -n monitoring -l app.kubernetes.io/name=grafana -o wide
echo
echo "[PVC]"
kubectl get pvc -n monitoring
echo
echo "[SERVICE]"
kubectl get svc -n monitoring grafana -o wide
echo
echo "[LOGS] (last 50 lines)"
kubectl logs -n monitoring -l app.kubernetes.io/name=grafana --tail=50 || true
