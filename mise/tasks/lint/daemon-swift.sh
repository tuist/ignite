#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${script_dir}/../../../daemon-swift"

echo "🔍 Linting daemon-swift..."
swiftlint lint --strict
echo "✅ Linting complete"