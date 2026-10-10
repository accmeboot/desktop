#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")/../zen"

zen="$HOME/.config/zen"

if [[ ! -f $zen/installs.ini ]]; then
  echo "no $zen/installs.ini: launch zen once to create a profile" >&2
  exit 1
fi

name=$(grep -m1 '^Default=' "$zen/installs.ini" | cut -d= -f2-)
profile="$zen/$name"

if [[ -z $name || ! -d $profile ]]; then
  echo "default profile not found in $zen/installs.ini" >&2
  exit 1
fi

target="$profile/chrome/userChrome.css"
mkdir -p "$profile/chrome"

if [[ -e $target && ! -L $target ]]; then
  echo "skipping $target: exists and is not a symlink" >&2
  exit 1
fi

ln -sfn "$PWD/userChrome.css" "$target"
echo "linked $target"
