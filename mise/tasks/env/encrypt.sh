#!/usr/bin/env bash
# mise description="Encrypts the .env file"

set -eo pipefail

sops encrypt -i --age "age1t8gtgsesgd7mj9a3lya42ey2c96s6jxhkpxsv5gulxt93v6hm5tqfygqpu" .env.json
