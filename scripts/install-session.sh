#!/usr/bin/env bash
# env and autostart are copied once and then belong to the machine, so local
# edits never touch the repo. Configs that are the same everywhere are
# symlinked.
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")/../session"

config="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$config/dwl" "$config/xdg-desktop-portal" "$config/xdg-desktop-portal-wlr" "$config/hypr"

for file in env autostart; do
  target="$config/dwl/$file"
  if [[ -e $target ]]; then
    echo "keeping existing $target"
    continue
  fi
  cp -p "$file" "$target"
done

link() {
  if [[ -e $2 && ! -L $2 ]]; then
    echo "skipping $2: exists and is not a symlink" >&2
    return
  fi
  ln -sfn "$PWD/$1" "$2"
}

# XDG_CURRENT_DESKTOP=dwl; xdg-desktop-portal-wlr doesn't list dwl itself.
link dwl-portals.conf "$config/xdg-desktop-portal/dwl-portals.conf"
link xdg-desktop-portal-wlr.conf "$config/xdg-desktop-portal-wlr/config"
link hypridle.conf "$config/hypr/hypridle.conf"
