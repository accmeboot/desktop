#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")/.."

packages=(
  sway
  hypridle
  xdg-desktop-portal-wlr
)

config="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$config/sway" "$config/hypr" "$config/xdg-desktop-portal-wlr"

stow --dir=stow --restow --target="$HOME" "${packages[@]}"

touch "$config/sway/local"
