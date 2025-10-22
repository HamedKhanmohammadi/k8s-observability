#!/bin/bash
set -euo pipefail
helm uninstall alloy -n monitoring || true
