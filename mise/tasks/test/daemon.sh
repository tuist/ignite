#\!/usr/bin/env bash
#MISE description="Run tests for the daemon"
set -eo pipefail

(cd daemon && mix test)
