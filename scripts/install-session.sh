#!/usr/bin/env bash
# env and autostart are copied once and then belong to the machine, so local
# edits never touch the repo. The portal config is the same everywhere and
# is symlinked.
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")/../session"

config="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$config/dwl" "$config/xdg-desktop-portal"

for file in env autostart; do
  target="$config/dwl/$file"
  if [[ -e $target ]]; then
    echo "keeping existing $target"
    continue
  fi
  cp -p "$file" "$target"
done

# XDG_CURRENT_DESKTOP=dwl; xdg-desktop-portal-wlr doesn't list dwl itself.
target="$config/xdg-desktop-portal/dwl-portals.conf"
if [[ -e $target && ! -L $target ]]; then
  echo "skipping $target: exists and is not a symlink" >&2
else
  ln -sfn "$PWD/dwl-portals.conf" "$target"
fi
