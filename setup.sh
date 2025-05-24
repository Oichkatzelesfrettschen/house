#!/usr/bin/env bash
# Bootstrap script for Codex environment
set -euo pipefail

# Abort if not running as root
if [[ $(id -u) -ne 0 ]]; then
  echo "ERROR: must run as root" >&2
  exit 1
fi

# Helper to install packages pinned to repository index. Installation
# failures are ignored so the script continues with the next package.
apt_pin_install() {
  local pkg=$1 ver
  ver=$(apt-cache show "$pkg" 2>/dev/null | awk '/^Version:/{print $2;exit}' || true)
  if [[ -n $ver ]]; then
    apt-get -y install "${pkg}=${ver}" || true
  else
    apt-get -y install "$pkg" || true
  fi
}

# Update package lists
apt-get -o Acquire::Retries=3 update -y

# Base development tools
base_pkgs=(
  build-essential make autoconf automake libtool
  gcc g++ curl git
  python3 python3-pip
  ghc cabal-install
)

for pkg in "${base_pkgs[@]}"; do
  apt_pin_install "$pkg"
done

# Install pre-commit via pip; ignore failure if network is unavailable
pip3 install --no-cache-dir pre-commit || true

# Install git hooks if pre-commit is available
if command -v pre-commit >/dev/null 2>&1; then
  pre-commit install || true
fi

# Clean APT caches
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "== setup complete =="
