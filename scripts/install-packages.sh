#!/usr/bin/env bash
set -euo pipefail

packages=(
  base-devel
  git
  less

  ghostty
  wireplumber
  playerctl
  brightnessctl

  grim
  slurp
  wl-clipboard
  libnotify

  wlr-randr
  ly
  hypridle
  wlopm
  xdg-desktop-portal
  xdg-desktop-portal-wlr
  xdg-desktop-portal-gtk
  xdg-utils

  adw-gtk-theme
  qt5ct
  qt6ct

  mpv
  fzf
  pinta
  discord
  thunderbird
  qbittorrent
)

sudo pacman -Syu --needed "${packages[@]}"
