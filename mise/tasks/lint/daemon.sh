#\!/usr/bin/env bash
#MISE description="Lint the daemon with Quokka"
set -eo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${script_dir}/../../daemon"

# Check if Quokka is installed
if \! mix archive 2>&1 | grep -q "quokka"; then
  echo "Installing Quokka..."
  mix archive.install hex quokka --force
fi

# Run format check
mix quokka.format --check-formatted
EOF < /dev/null