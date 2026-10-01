#!/usr/bin/env bash
# Quickshell with mesa-shell and everything mesa-shell uses (see its README).
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "run as your user, not root: mesa-shell is cloned into your ~/.config" >&2
  exit 1
fi

packages=(
  quickshell

  # backends of the Quickshell services mesa-shell uses
  upower
  pipewire
  networkmanager
  bluez
  pam

  # commands mesa-shell runs
  bluez-utils # bluetoothctl
  psmisc      # fuser
  socat       # mesa-dmenu
)

# -Syu, not -S: installing against a stale package database is a partial upgrade.
sudo pacman -Syu --needed "${packages[@]}"

# upower is D-Bus activated; these two have to be enabled.
sudo systemctl enable --now NetworkManager.service bluetooth.service

config="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/mesa-shell"
if [[ ! -d $config ]]; then
  git clone https://github.com/accmeboot/mesa-shell.git "$config"
fi
if [[ ! -e $config/config.json ]]; then
  cp "$config/config.example.json" "$config/config.json"
fi
