#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${script_dir}/../../../daemon-swift"

echo "🧪 Running daemon-swift tests..."
swift test
echo "✅ Tests passed"