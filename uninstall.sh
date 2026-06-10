#!/bin/bash
# pkgdrop uninstaller
set -e

echo "Uninstalling pkgdrop..."

if [ "$EUID" -ne 0 ]; then
  echo "Error: Run with sudo: sudo ./uninstall.sh"
  exit 1
fi

rm -f /usr/bin/pkgdrop
echo "[OK] Removed /usr/bin/pkgdrop"

rm -f /usr/share/applications/pkgdrop.desktop
echo "[OK] Removed desktop entry"

rm -f /usr/share/kservices5/ServiceMenus/pkgdrop-servicemenu.xml
echo "[OK] Removed Dolphin service menu"

echo ""
echo "Uninstalled. User installs in ~/.local/opt/ and ~/.local/bin/ were kept."
