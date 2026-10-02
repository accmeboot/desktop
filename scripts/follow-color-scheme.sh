#!/usr/bin/env bash
set -euo pipefail

config="${XDG_CONFIG_HOME:-$HOME/.config}"
state="${XDG_STATE_HOME:-$HOME/.local/state}/base16"

apply() {
  local polarity=light
  [[ $1 == *prefer-dark* ]] && polarity=dark

  gsettings set org.gnome.desktop.interface gtk-theme "base16-$polarity"
  local icons=
  { read -r icons <"$state/$polarity/icon-theme"; } 2>/dev/null || true
  [[ -n $icons ]] && gsettings set org.gnome.desktop.interface icon-theme "$icons"
  for qtct in qt5ct qt6ct; do
    mkdir -p "$config/$qtct"
    ln -sfn "$state/$polarity/qtct.conf" "$config/$qtct/$qtct.conf"
  done
}

apply "$(gsettings get org.gnome.desktop.interface color-scheme)"
gsettings monitor org.gnome.desktop.interface color-scheme | while read -r line; do
  apply "$line"
done
