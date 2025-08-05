#!/usr/bin/env bash
set -eo pipefail

(cd web && mix deps.get)
(cd daemon && mix deps.get)
if [[ "$OSTYPE" == "darwin"* ]]; then
  (cd app && tuist install)
fi
pnpm install
