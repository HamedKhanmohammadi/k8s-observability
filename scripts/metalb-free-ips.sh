#!/usr/bin/env bash
# Usage: ./metalb-free-ips.sh 192.168.55 50 70
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <prefix> <start> <end>"
  echo "Example: $0 192.168.55 50 70"
  exit 1
fi

prefix="$1"
start="$2"
end="$3"

used=$(kubectl get svc -A -o jsonpath='{range .items[*]}{.status.loadBalancer.ingress[0].ip}{"\n"}{end}' | sort | uniq || true)

for i in $(seq "$start" "$end"); do
  ip="$prefix.$i"
  if echo "$used" | grep -qx "$ip"; then
    echo "❌ Used: $ip"
  else
    echo "✅ Free: $ip"
  fi
done
