#!/bin/bash
# mise description="Deploy the Cloudflare Worker to production"

set -euo pipefail

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}▶ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

cd "${MISE_PROJECT_ROOT}/worker"

print_status "Deploying Cloudflare Worker..."

# Deploy the worker to production environment
if wrangler deploy --env production; then
    print_status "Worker deployed successfully!"
    echo ""
    echo "Your worker is now available at:"
    echo "  https://ignite.tuist.dev"
    echo ""
    echo "Test the install script with:"
    echo "  curl -fsSL https://ignite.tuist.dev | sh"
else
    print_error "Deployment failed!"
    exit 1
fi