#!/usr/bin/env bash
# bootstrap script for Codex environment
set -euo pipefail

if [[ $(id -u) -ne 0 ]]; then
  echo "ERROR: must run as root" >&2
  exit 1
fi

apt_pin_install() {
  local pkg=$1 ver
  ver=$(apt-cache show "$pkg" 2>/dev/null | awk '/^Version:/{print $2;exit}' || true)
  if [[ -n $ver ]]; then
    apt-get -y install "${pkg}=${ver}" || true
  else
    apt-get -y install "$pkg" || true
  fi
}

apt-get -o Acquire::Retries=3 update -y

pkgs=(build-essential curl git python3 python3-pip)
for pkg in "${pkgs[@]}"; do
  apt_pin_install "$pkg"
done

pip3 install --no-cache-dir pre-commit

LATEST_GHC=$(curl -fsSL https://downloads.haskell.org/~ghc/ | \
  grep -Eo 'href="[0-9]+\.[0-9]+\.[0-9]+/' | \
  cut -d\" -f2 | sort -V | tail -n1)
echo "Latest GHC directory: $LATEST_GHC" > ghc-latest.txt

apt-get clean
rm -rf /var/lib/apt/lists/*

echo "== setup complete =="
