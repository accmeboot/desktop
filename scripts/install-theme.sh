#!/usr/bin/env bash
set -euo pipefail

config="${XDG_CONFIG_HOME:-$HOME/.config}"
state="${XDG_STATE_HOME:-$HOME/.local/state}/base16"
themes="${XDG_DATA_HOME:-$HOME/.local/share}/themes"

for polarity in dark light; do
  base=adw-gtk3
  [[ $polarity == dark ]] && base=adw-gtk3-dark
  mkdir -p "$themes/base16-$polarity/gtk-3.0"
  cat >"$themes/base16-$polarity/gtk-3.0/gtk.css" <<EOF
@import url("file:///usr/share/themes/$base/gtk-3.0/gtk.css");
@import url("file://$state/$polarity/gtk3.css");
EOF
done

write_once() {
  if [[ -e $1 ]]; then
    echo "keeping existing $1"
    return
  fi
  mkdir -p "$(dirname "$1")"
  cat >"$1"
}

write_once "$config/gtk-4.0/gtk.css" <<EOF
@import url("file://$state/dark/gtk4.css");
@import url("file://$state/light/gtk4.css");
EOF

write_once "$config/fontconfig/fonts.conf" <<EOF
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <include ignore_missing="yes">$state/dark/fonts.conf</include>
</fontconfig>
EOF
