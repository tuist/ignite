#!/usr/bin/env bash
set -euo pipefail

echo "🧪 Running daemon-swift tests..."
cd daemon-swift
swift test
echo "✅ Tests passed"