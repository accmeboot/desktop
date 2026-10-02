#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "run as your user, not root: the repos are cloned into your home" >&2
  exit 1
fi

repos=(
  terminal
  base16
)

for repo in "${repos[@]}"; do
  if [[ ! -d $HOME/$repo ]]; then
    git clone "https://github.com/accmeboot/$repo.git" "$HOME/$repo"
  fi
done
