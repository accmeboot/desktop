#!/usr/bin/env bash
set -euo pipefail

packages=(
  base-devel
  git
  less
  stow

  sway
  xorg-xwayland

  ghostty
  wireplumber
  playerctl
  brightnessctl

  grim
  slurp
  wl-clipboard
  libnotify

  ly
  hypridle
  xdg-desktop-portal
  xdg-desktop-portal-wlr
  xdg-desktop-portal-gtk
  xdg-utils

  mpv
  fzf
  pinta
  discord
  thunderbird
  qbittorrent
)

sudo pacman -Syu --needed "${packages[@]}"
