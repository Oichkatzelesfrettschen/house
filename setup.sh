#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

# Update package index
apt-get -o Acquire::Retries=3 update -y

# Core Haskell packages
pkgs=(ghc cabal-install hlint stylish-haskell happy alex)
for pkg in "${pkgs[@]}"; do
    if ! apt-get -y install "$pkg"; then
        echo "Warning: failed to install $pkg" >&2
    fi
done

# pre-commit via pip
if ! pip3 install --no-cache-dir pre-commit; then
    echo "Warning: failed to install pre-commit" >&2
fi

echo "Setup complete"
