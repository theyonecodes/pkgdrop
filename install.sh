#!/bin/bash
# pkgdrop installer - uses polkit for elevation
# shellcheck shell=bash disable=SC2016
set -e

echo "Installing pkgdrop..."

# Get real user (not root)
REAL_USER="${SUDO_USER:-$USER}"
if [[ "$REAL_USER" == "root" ]]; then
  REAL_HOME="/root"
  IS_ROOT=1
else
  REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
  IS_ROOT=0
fi

# Check if polkit is available
has_polkit() {
  command -v pkexec &>/dev/null && command -v polkit-agent-helper-1 &>/dev/null
}

# Run command with elevation
elevate() {
  if [[ "$IS_ROOT" -eq 1 ]]; then
    "$@"
  elif has_polkit; then
    pkexec "$@"
  else
    echo "Error: Need root. Run with sudo: sudo ./install.sh"
    exit 1
  fi
}

# Install main script
echo "[..] Installing /usr/bin/pkgdrop"
elevate install -Dm755 src/pkgdrop /usr/bin/pkgdrop
echo "[OK] /usr/bin/pkgdrop"

# Install desktop file
echo "[..] Installing desktop entry"
elevate install -Dm644 deploy/pkgdrop.desktop /usr/share/applications/pkgdrop.desktop
echo "[OK] Desktop entry"

# Install Dolphin service menu
if [ -d "/usr/share/kservices5/ServiceMenus" ]; then
  echo "[..] Installing Dolphin service menu"
  elevate install -Dm644 deploy/dolphin/pkgdrop-servicemenu.xml /usr/share/kservices5/ServiceMenus/pkgdrop-servicemenu.xml
  echo "[OK] Dolphin service menu"
fi

# Create user directories (no elevation needed)
sudo -u "$REAL_USER" mkdir -p "$REAL_HOME/.local/bin" "$REAL_HOME/.local/opt"
echo "[OK] User directories"

# Add to PATH if not already there
if ! grep -q '.local/bin' "$REAL_HOME/.bashrc" 2>/dev/null; then
  sudo -u "$REAL_USER" bash -c 'echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$HOME/.bashrc"'
  echo "[OK] Added ~/.local/bin to PATH"
fi

echo ""
echo "Done! Run: pkgdrop <file>"
