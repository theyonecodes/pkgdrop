#!/bin/bash
# push-aur.sh - Push pkgdrop updates to AUR
set -e

VERSION=$(grep '^VERSION=' src/pkgdrop | cut -d'"' -f2)
echo "Pushing pkgdrop $VERSION to AUR..."

cd /tmp/pkgdrop

# Update PKGBUILD version
sed -i "s/pkgver=.*/pkgver=$VERSION/" PKGBUILD
sed -i "s/pkgrel=.*/pkgrel=1/" PKGBUILD

# Update .SRCINFO version
sed -i "s/pkgver = .*/pkgver = $VERSION/" .SRCINFO
sed -i "s/pkgrel = .*/pkgrel = 1/" .SRCINFO

# Update checksum
newsum=$(sha256sum src/pkgdrop | awk '{print $1}')
sed -i "s/sha256sums=.*/sha256sums=('$newsum')/" PKGBUILD
sed -i "s/sha256sum = .*/sha256sum = $newsum/" .SRCINFO

# Copy updated script
cp src/pkgdrop pkgdrop

# Commit and push
git add -A
git commit -m "pkgdrop $VERSION" || { echo "No changes to commit"; exit 0; }
git push

echo "Done! pkgdrop $VERSION pushed to AUR."
