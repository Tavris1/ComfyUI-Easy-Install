#!/bin/bash

set -e

if [ "$(uname -s)" != "Darwin" ]; then
  echo "This script is intended for macOS."
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install it first:"
  echo "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
  exit 1
fi

echo "Installing Homebrew python@3.12 (if needed)..."
brew install python@3.12 || true

BREW_PREFIX="$(brew --prefix)"
BREW_PYTHON312=""

if [ -x "$BREW_PREFIX/opt/python@3.12/bin/python3.12" ]; then
  BREW_PYTHON312="$BREW_PREFIX/opt/python@3.12/bin/python3.12"
elif [ -x "$BREW_PREFIX/opt/python@3.12/libexec/bin/python3" ]; then
  BREW_PYTHON312="$BREW_PREFIX/opt/python@3.12/libexec/bin/python3"
else
  PY312_CELLAR_PREFIX="$(brew --prefix python@3.12 2>/dev/null || true)"
  if [ -n "$PY312_CELLAR_PREFIX" ] && [ -x "$PY312_CELLAR_PREFIX/bin/python3.12" ]; then
    BREW_PYTHON312="$PY312_CELLAR_PREFIX/bin/python3.12"
  fi
fi

if [ -z "$BREW_PYTHON312" ] || [ ! -x "$BREW_PYTHON312" ]; then
  echo "python@3.12 executable not found. Tried:"
  echo "- $BREW_PREFIX/opt/python@3.12/bin/python3.12"
  echo "- $BREW_PREFIX/opt/python@3.12/libexec/bin/python3"
  echo "- $(brew --prefix python@3.12 2>/dev/null || true)/bin/python3.12"
  exit 1
fi

echo "Using: $BREW_PYTHON312"

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
INSTALLER="$SCRIPT_DIR/ComfyUI-Easy-Install.sh"

if [ ! -f "$INSTALLER" ]; then
  echo "Installer not found: $INSTALLER"
  exit 1
fi

bash "$INSTALLER"
