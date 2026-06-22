#!/bin/bash
# pkgdrop uninstaller - uses polkit for elevation
set -e

echo "Uninstalling pkgdrop..."

# Get real user (not root)
REAL_USER="${SUDO_USER:-$USER}"

# Function to run command with elevation
run_as_root() {
    # Try pkexec first (polkit)
    if command -v pkexec &>/dev/null; then
        pkexec "$@"
        return $?
    fi
    
    # Fall back to sudo if pkexec is not available
    if command -v sudo &>/dev/null; then
        sudo "$@"
        return $?
    fi
    
    # If neither is available, show error
    echo "Error: Need root privileges. Install pkexec or sudo to continue."
    exit 1
}

# Remove files
echo "[..] Removing /usr/bin/pkgdrop"
run_as_root rm -f /usr/bin/pkgdrop
echo "[OK] Removed /usr/bin/pkgdrop"

echo "[..] Removing desktop entry"
run_as_root rm -f /usr/share/applications/pkgdrop.desktop
echo "[OK] Removed desktop entry"

# Remove PATH export from user's .bashrc if it was added by installer
echo "[..] Cleaning PATH from ~/.bashrc"
sudo -u "$REAL_USER" bash -c 'sed -i "/export PATH=\"\$HOME/.local/bin:\$PATH\"/d" "$HOME/.bashrc" 2>/dev/null || true'
echo "[OK] Cleaned PATH from ~/.bashrc"

echo "[..] Removing Dolphin service menu"
run_as_root rm -f /usr/share/kservices5/ServiceMenus/pkgdrop-servicemenu.xml
echo "[OK] Removed Dolphin service menu"

echo ""
echo "Uninstalled. User installs in ~/.local/opt/ and ~/.local/bin/ were kept."
