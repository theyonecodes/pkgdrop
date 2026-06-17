#!/bin/bash
# pkgdrop uninstaller - uses polkit for elevation
set -e

echo "Uninstalling pkgdrop..."

# Get real user (not root)
REAL_USER="${SUDO_USER:-$USER}"
if [[ "$REAL_USER" == "root" ]]; then
  IS_ROOT=1
else
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
    echo "Error: Need root. Run with sudo: sudo ./uninstall.sh"
    exit 1
  fi
}

# Remove files
echo "[..] Removing /usr/bin/pkgdrop"
elevate rm -f /usr/bin/pkgdrop
echo "[OK] Removed /usr/bin/pkgdrop"

echo "[..] Removing desktop entry"
elevate rm -f /usr/share/applications/pkgdrop.desktop
echo "[OK] Removed desktop entry"

# Remove PATH export from user's .bashrc if it was added by installer
echo "[..] Cleaning PATH from ~/.bashrc"
sudo -u "$REAL_USER" bash -c 'sed -i "/export PATH=\"\$HOME\/.local\/bin:\$PATH\"/d" "$HOME/.bashrc" 2>/dev/null || true'
echo "[OK] Cleaned PATH from ~/.bashrc"

echo "[..] Removing Dolphin service menu"
elevate rm -f /usr/share/kservices5/ServiceMenus/pkgdrop-servicemenu.xml
echo "[OK] Removed Dolphin service menu"

echo ""
echo "Uninstalled. User installs in ~/.local/opt/ and ~/.local/bin/ were kept."
