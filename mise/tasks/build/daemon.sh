#!/usr/bin/env bash
#MISE description="Build the daemon"
set -eo pipefail

(cd daemon && mix compile --warnings-as-errors)
