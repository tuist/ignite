#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Linting daemon-swift..."
cd daemon-swift

# Use GitHub Actions reporter format if running in CI
if [ -n "${GITHUB_ACTIONS:-}" ]; then
    swiftlint lint --strict --reporter github-actions-logging
else
    swiftlint lint --strict
fi

echo "✅ Linting complete"