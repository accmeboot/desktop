#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

./scripts/install-packages.sh
./scripts/clone-repos.sh
../mesa-shell/install.sh
./scripts/install-aur.sh
./scripts/install-boot.sh
./scripts/link-scripts.sh
./scripts/link.sh
./scripts/install-profile.sh
./scripts/install-ly.sh
