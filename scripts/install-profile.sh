#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")/../session"

sudo install -Dm644 profile.sh /etc/profile.d/desktop.sh
