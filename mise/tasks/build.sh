#!/usr/bin/env bash
set -eo pipefail

# Build all components
echo "Building all components..."

echo "→ Building web..."
mise run build:web

echo "→ Building daemon..."
mise run build:daemon

echo "→ Building app..."
mise run build:app

echo "→ Building daemon-swift..."
mise run build:daemon-swift

echo "→ Building worker..."
mise run build:worker

echo "✅ All components built successfully!"