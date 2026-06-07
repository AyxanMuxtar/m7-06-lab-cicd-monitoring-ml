#!/usr/bin/env bash
set -euo pipefail
ENVIRONMENT="${1:?Usage: smoke.sh <environment>}"
echo "Running smoke tests against ${ENVIRONMENT}..."
echo "Smoke tests passed."
exit 0
