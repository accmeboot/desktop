#!/usr/bin/env bash
# Symlinks the runtime scripts into ~/.local/bin, which dwl-session's
# ~/.config/dwl/env puts on PATH.
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

scripts=(
  screenshot-full.sh
  screenshot-area.sh
)

bin="$HOME/.local/bin"
mkdir -p "$bin"

for script in "${scripts[@]}"; do
  target="$bin/$script"
  if [[ -e $target && ! -L $target ]]; then
    echo "skipping $target: exists and is not a symlink" >&2
    continue
  fi
  ln -sfn "$PWD/$script" "$target"
done
