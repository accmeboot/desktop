#!/usr/bin/env bash
set -euo pipefail

config=/etc/ly/config.ini

set_key() {
  sudo sed -i "s|^$1 = .*|$1 = $2|" "$config"
  if ! sudo grep -qxF "$1 = $2" "$config"; then
    echo "could not set $1 in $config" >&2
    exit 1
  fi
}

set_key sleep_cmd "systemctl suspend"
set_key shell false
set_key xinitrc null
set_key default_input password

sudo systemctl enable ly@tty2.service
