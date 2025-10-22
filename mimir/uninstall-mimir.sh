#!/bin/bash
set -euo pipefail
helm uninstall mimir -n mimir || true
kubectl delete ns mimir --ignore-not-found
