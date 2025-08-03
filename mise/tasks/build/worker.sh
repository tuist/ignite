#!/usr/bin/env bash
set -eo pipefail

cd worker
# Worker doesn't have a build step as it's JavaScript
# But we can validate the code
if command -v node &> /dev/null; then
  node -c src/index.js
  echo "Worker JavaScript is valid"
else
  echo "Node.js not found, skipping worker validation"
fi