#!/bin/bash
# mise description="Serve the Cloudflare Worker locally for development"

set -euo pipefail

cd "${MISE_PROJECT_ROOT}/worker"

echo "Starting Cloudflare Worker development server..."
echo "Marketing page: http://localhost:8787"
echo "Install script: curl http://localhost:8787"
echo ""

wrangler dev --port 8787