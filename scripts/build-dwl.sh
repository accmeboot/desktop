#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")/.."

if [[ $EUID -eq 0 ]]; then
  echo "run as your user, not root: makepkg refuses to build as root" >&2
  exit 1
fi

(($#)) || set -- dwl dwlmsg

for pkg in "$@"; do
  (cd "$pkg" && makepkg -siCf)
done
