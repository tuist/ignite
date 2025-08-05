#!/usr/bin/env bash
set -euo pipefail

echo "🔨 Building daemon-swift..."
cd daemon-swift
swift build --configuration release
echo "✅ Build complete"