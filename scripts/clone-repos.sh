#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "run as your user, not root: the repos are cloned into your home" >&2
  exit 1
fi

# next to this repo
cd "$(dirname "$(readlink -f "$0")")/../.."

repos=(
  terminal
  mesa-shell
)

for repo in "${repos[@]}"; do
  if [[ ! -d $repo ]]; then
    git clone "https://github.com/accmeboot/$repo.git" "$repo"
  fi
done
