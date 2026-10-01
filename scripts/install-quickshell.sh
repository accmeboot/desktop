#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "run as your user, not root: mesa-shell is cloned into your ~/.config" >&2
  exit 1
fi

packages=(
  quickshell

  upower
  pipewire
  networkmanager
  bluez
  pam

  bluez-utils
  psmisc
  socat
)

sudo pacman -Syu --needed "${packages[@]}"

sudo systemctl enable --now NetworkManager.service bluetooth.service

config="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/mesa-shell"
if [[ ! -d $config ]]; then
  git clone https://github.com/accmeboot/mesa-shell.git "$config"
fi
if [[ ! -e $config/config.json ]]; then
  cp "$config/config.example.json" "$config/config.json"
fi
