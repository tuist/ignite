#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Linting daemon-swift..."
cd daemon-swift
swiftlint lint --strict
echo "✅ Linting complete"