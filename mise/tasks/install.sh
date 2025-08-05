#!/usr/bin/env bash
set -eo pipefail

(cd web && mix deps.get)
(cd daemon && mix deps.get)
(cd app && tuist install)
pnpm install
