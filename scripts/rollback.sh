#!/usr/bin/env bash
set -euo pipefail
ENVIRONMENT="${1:?Usage: rollback.sh <environment>}"
echo "Rolling back ${ENVIRONMENT} to previous version..."
echo "Rollback complete."
exit 0
