#!/usr/bin/env bash
set -euo pipefail

packages=(
  # makepkg
  base-devel
  git

  # used by config.h keybinds
  ghostty
  wireplumber
  playerctl
  brightnessctl

  # used by scripts/screenshot-*.sh
  grim
  slurp
  wl-clipboard
  libnotify
)

# -Syu, not -S: installing against a stale package database is a partial upgrade.
sudo pacman -Syu --needed "${packages[@]}"
