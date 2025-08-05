#!/usr/bin/env bash
#MISE description="Lint the daemon with Quokka"
#USAGE flag "--fix" help="Fix formatting issues instead of just checking"
set -eo pipefail


# Check if --fix flag is provided
if [[ "${usage_fix:-}" == "true" ]]; then
  echo "Formatting daemon code..."
  (cd daemon && mix format)
else
  # Run format check with Quokka plugin
  (cd daemon && mix format --check-formatted)
fi
