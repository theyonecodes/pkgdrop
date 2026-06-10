#!/bin/bash
# pkgdrop installer
# shellcheck shell=bash disable=SC2016
set -e

echo "Installing pkgdrop..."

# Check root
if [ "$EUID" -ne 0 ]; then
  echo "Error: Run with sudo: sudo ./install.sh"
  exit 1
fi

REAL_USER="${SUDO_USER:-$USER}"
if [[ "$REAL_USER" == "root" ]]; then
  REAL_HOME="/root"
else
  REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
fi

# Install main script
install -Dm755 src/pkgdrop /usr/bin/pkgdrop
echo "[OK] /usr/bin/pkgdrop"

# Install desktop file
install -Dm644 deploy/pkgdrop.desktop /usr/share/applications/pkgdrop.desktop
echo "[OK] Desktop entry"

# Install Dolphin service menu
if [ -d "/usr/share/kservices5/ServiceMenus" ]; then
  install -Dm644 deploy/dolphin/pkgdrop-servicemenu.xml /usr/share/kservices5/ServiceMenus/pkgdrop-servicemenu.xml
  echo "[OK] Dolphin service menu"
fi

# Create user directories
sudo -u "$REAL_USER" mkdir -p "$REAL_HOME/.local/bin" "$REAL_HOME/.local/opt"

# Add to PATH if not already there
if ! grep -q '.local/bin' "$REAL_HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$REAL_HOME/.bashrc"
  echo "[OK] Added ~/.local/bin to PATH"
fi

echo ""
echo "Done! Run: pkgdrop <file>"
