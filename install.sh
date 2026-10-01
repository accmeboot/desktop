#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

./scripts/install-packages.sh
./scripts/install-quickshell.sh
./scripts/install-aur.sh
./scripts/link-scripts.sh
./scripts/install-session.sh
./scripts/install-theme.sh

build=()
for pkg in dwl dwlmsg; do
  if pacman -Qq "$pkg-accme" &>/dev/null; then
    read -rp "Rebuild $pkg? [y/N] " answer || answer=
    [[ $answer == [yY]* ]] || continue
  fi
  build+=("$pkg")
done

if ((${#build[@]})); then
  ./scripts/build-dwl.sh "${build[@]}"
fi
