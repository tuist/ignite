#\!/usr/bin/env bash
#MISE description="Run tests for the daemon"
set -eo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${script_dir}/../../daemon"
mix test
EOF < /dev/null