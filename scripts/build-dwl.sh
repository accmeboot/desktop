#!/usr/bin/env bash
# Usage: build-dwl.sh [dwl] [dwlmsg]   (no arguments builds both)
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")/.."

if [[ $EUID -eq 0 ]]; then
  echo "run as your user, not root: makepkg refuses to build as root" >&2
  exit 1
fi

(($#)) || set -- dwl dwlmsg

# -s installs each PKGBUILD's depends/makedepends, -C starts from a clean src/
# so patches always apply to pristine sources, -f overwrites an earlier build.
for pkg in "$@"; do
  (cd "$pkg" && makepkg -siCf)
done
