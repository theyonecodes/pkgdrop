#!/bin/bash
# pkgdrop installer - uses polkit for elevation
# shellcheck shell=bash disable=SC2016
set -e

echo "Installing pkgdrop..."

# Get real user (not root)
REAL_USER="${SUDO_USER:-$USER}"
if [[ "$REAL_USER" == "root" ]]; then
    REAL_HOME="/root"
else
    REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
fi

# Define the base directory where pkgdrop is installed
PKGDROP_BASE="/home/shinda/Desktop/Projects/pkgdrop"

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

# Install main script
echo "[..] Installing /usr/bin/pkgdrop"
run_as_root install -Dm755 "$PKGDROP_BASE/src/pkgdrop" /usr/bin/pkgdrop
echo "[OK] /usr/bin/pkgdrop"

# Install desktop file
echo "[..] Installing desktop entry"
run_as_root install -Dm644 "$PKGDROP_BASE/deploy/pkgdrop.desktop" /usr/share/applications/pkgdrop.desktop
echo "[OK] Desktop entry"

# Install Dolphin service menu
if [ -d "/usr/share/kservices5/ServiceMenus" ]; then
echo "[..] Installing Dolphin service menu"
run_as_root install -Dm644 "$PKGDROP_BASE/deploy/dolphin/pkgdrop-servicemenu.xml" /usr/share/kservices5/ServiceMenus/pkgdrop-servicemenu.xml
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
