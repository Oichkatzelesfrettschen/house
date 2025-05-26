#!/usr/bin/env bash
# Bootstrap script for Codex environment
set -euo pipefail
# Enable verbose output for easier debugging
set -x

# Log everything to setup.log for troubleshooting
LOGFILE="$(dirname "$0")/setup.log"
exec > >(tee -a "$LOGFILE") 2>&1

# Utility to run a command and log any failure instead of exiting.
# This helps identify issues without aborting the entire setup.
run_cmd() {
  "$@" || echo "WARNING: command failed: $*" >&2
}

# Abort if not running as root
if [[ $(id -u) -ne 0 ]]; then
  echo "ERROR: must run as root" >&2
  exit 1
fi

# Helper to install packages pinned to repository index. Returns 0 if the
# package was successfully installed with apt, non-zero otherwise.
apt_pin_install() {
  local pkg=$1 ver rc
  ver=$(apt-cache show "$pkg" 2>/dev/null | awk '/^Version:/{print $2;exit}' || true)
  if [[ -n $ver ]]; then
    run_cmd apt-get -y install "${pkg}=${ver}"
  else
    run_cmd apt-get -y install "$pkg"
  fi
  rc=$?
  return $rc
}

# Install a tool using apt, pip or npm in that order. Installation failures are
# logged but do not abort the script.
install_tool() {
  local pkg=$1
  if apt_pin_install "$pkg"; then
    return 0
  fi
  echo "APT install failed for $pkg, trying pip" >&2
  if pip3 install --no-cache-dir "$pkg"; then
    return 0
  fi
  echo "pip install failed for $pkg, trying npm" >&2
  run_cmd npm -g install "$pkg"
}

# Update package lists and upgrade existing packages
run_cmd apt-get -o Acquire::Retries=3 update -y
run_cmd apt-get -y dist-upgrade

# Base development tools
base_pkgs=(
  build-essential make autoconf automake libtool
  gcc g++ curl git
  python3 python3-pip
  gdb valgrind clang clang-format clang-tidy llvm lcov
  llvm-bolt
  qemu-system-x86 qemu-utils afl++
  cabal-install hlint shellcheck
  graphviz doxygen pandoc
  coq isabelle tlaplus agda
  nodejs npm
  libcapnproto-dev
)

for pkg in "${base_pkgs[@]}"; do
  install_tool "$pkg" || true
done

# Install the latest recommended GHC and Cabal via ghcup
if ! command -v ghcup >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | bash -s -- -y
fi
if [ -f "$HOME/.ghcup/env" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.ghcup/env"
  ghcup install ghc recommended || true
  ghcup set ghc recommended || true
  ghcup install cabal recommended || true
  ghcup set cabal recommended || true
fi

# Install pre-commit via pip; ignore failure if network is unavailable
run_cmd pip3 install --no-cache-dir pre-commit

# Install git hooks if pre-commit is available
if command -v pre-commit >/dev/null 2>&1; then
  run_cmd pre-commit install
fi

# Clean APT caches
run_cmd apt-get clean
run_cmd rm -rf /var/lib/apt/lists/*

echo "== setup complete =="
