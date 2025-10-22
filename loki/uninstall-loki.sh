#!/bin/bash
set -euo pipefail
helm uninstall loki -n loki || true
kubectl delete ns loki --ignore-not-found
