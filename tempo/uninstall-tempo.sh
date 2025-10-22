#!/bin/bash
set -euo pipefail
helm uninstall tempo -n tempo || true
kubectl delete -f ../manifests/tempo-query-frontend-compat-svc.yaml --ignore-not-found
kubectl delete ns tempo --ignore-not-found
