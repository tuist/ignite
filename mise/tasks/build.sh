#!/usr/bin/env bash
set -eo pipefail

# Build all components
echo "Building all components..."

echo "→ Building web..."
mise run build:web

echo "→ Building sidekick..."
mise run build:sidekick

echo "→ Building app..."
mise run build:app

echo "→ Building sidekick-swift..."
mise run build:sidekick-swift

echo "→ Building worker..."
mise run build:worker

echo "✅ All components built successfully!"