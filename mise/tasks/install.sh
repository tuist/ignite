#!/usr/bin/env bash
set -eo pipefail

(cd web && mix deps.get)
(cd sidekick && mix deps.get)
(cd app && tuist install)
pnpm install
