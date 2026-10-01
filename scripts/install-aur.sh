#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "run as your user, not root: makepkg refuses to build as root" >&2
  exit 1
fi

packages=(
  zen-browser-bin
)

if ! command -v paru &>/dev/null; then
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT
  git clone --depth=1 https://aur.archlinux.org/paru.git "$tmp/paru"
  cat "$tmp/paru/PKGBUILD"
  read -rp "Build and install paru from the PKGBUILD above? [y/N] " answer || answer=
  if [[ $answer != [yY]* ]]; then
    echo "skipping AUR packages: paru is not installed" >&2
    exit 0
  fi
  (cd "$tmp/paru" && makepkg -si --rmdeps)
fi

paru -S --needed "${packages[@]}"
