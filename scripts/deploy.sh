#!/usr/bin/env bash
set -euo pipefail
ENVIRONMENT="${1:?Usage: deploy.sh <environment> <image>}"
IMAGE="${2:?Usage: deploy.sh <environment> <image>}"
echo "Deploying ${IMAGE} to ${ENVIRONMENT} ${*:3}..."
echo "Deployment complete."
exit 0
