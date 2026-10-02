#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")/../boot"

if [[ $EUID -eq 0 ]]; then
  echo "run as your user, not root: makepkg refuses to build as root" >&2
  exit 1
fi

if ! command -v paru &>/dev/null; then
  echo "paru is missing: run scripts/install-aur.sh first" >&2
  exit 1
fi

packages=(
  limine
  btrfs-progs
  snapper
  snap-pac
  xxhash
  plymouth
)

sudo pacman -Syu --needed "${packages[@]}"

if ! sudo snapper -c root get-config &>/dev/null; then
  sudo snapper -c root create-config /
fi

sudo install -Dm644 limine /etc/default/limine
sudo rm -f /etc/pacman.d/hooks/99-limine.hook

if ! sudo test -e /boot/limine.conf; then
  if sudo test -e /boot/EFI/BOOT/limine.conf; then
    sudo mv /boot/EFI/BOOT/limine.conf /boot/limine.conf
  else
    echo "timeout: 5" | sudo tee /boot/limine.conf >/dev/null
  fi
fi

paru -S --needed limine-mkinitcpio-hook limine-snapper-sync

sudo install -Dm644 mkinitcpio.conf /etc/mkinitcpio.conf.d/limine.conf
sudo limine-update

# archinstall boots a UKI built by the stock mkinitcpio preset, from an entry
# above the generated ones; limine-mkinitcpio-hook replaces that preset, so the
# UKI is never rebuilt and stops booting after the next kernel update
conf=$(mktemp)
sudo cat /boot/limine.conf | awk '
  function flush() {
    if (block !~ /boot\(\):\/EFI\/Linux\/arch-linux(-fallback)?\.efi/) printf "%s", block
    block = ""
  }
  /^\// { flush() }
  { block = block $0 "\n" }
  END { flush() }
' >"$conf"
if ! sudo cmp -s "$conf" /boot/limine.conf; then
  sudo install -m600 "$conf" /boot/limine.conf
fi
rm -f "$conf"
sudo rm -f /boot/EFI/Linux/arch-linux.efi /boot/EFI/Linux/arch-linux-fallback.efi

sudo systemctl enable --now limine-snapper-sync.service
sudo limine-snapper-sync
