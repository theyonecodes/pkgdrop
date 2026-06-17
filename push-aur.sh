#!/bin/bash
# push-aur.sh - Push pkgdrop updates to AUR
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_SCRIPT="$SCRIPT_DIR/src/pkgdrop"

VERSION=$(grep '^VERSION=' "$SRC_SCRIPT" | cut -d'"' -f2)
echo "Pushing pkgdrop $VERSION to AUR..."

# Check if AUR clone exists
if [[ ! -d "/tmp/pkgdrop" ]]; then
  echo "Cloning AUR repo..."
  git clone ssh://aur@aur.archlinux.org/pkgdrop.git /tmp/pkgdrop
fi

cd /tmp/pkgdrop

# Update PKGBUILD version
sed -i "s/pkgver=.*/pkgver=$VERSION/" PKGBUILD
sed -i "s/pkgrel=.*/pkgrel=1/" PKGBUILD

# Update .SRCINFO version
sed -i "s/pkgver = .*/pkgver = $VERSION/" .SRCINFO
sed -i "s/pkgrel = .*/pkgrel = 1/" .SRCINFO

# Update checksum
newsum=$(sha256sum "$SRC_SCRIPT" | awk '{print $1}')
sed -i "s/sha256sums=.*/sha256sums=('$newsum')/" PKGBUILD
sed -i "s/sha256sum = .*/sha256sum = $newsum/" .SRCINFO

# Copy updated script
cp "$SRC_SCRIPT" pkgdrop

# Commit and push to AUR
git add -A
git commit -m "pkgdrop $VERSION" || { echo "No changes to commit"; exit 0; }
git push origin HEAD

echo "Done! pkgdrop $VERSION pushed to AUR."
