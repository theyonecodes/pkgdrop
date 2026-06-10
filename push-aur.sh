#!/bin/bash
# push-aur.sh - Push pkgdrop updates to AUR
set -e

VERSION=$(grep '^VERSION=' src/pkgdrop | cut -d'"' -f2)
echo "Pushing pkgdrop $VERSION to AUR..."

# Copy updated script
cp src/pkgdrop /tmp/pkgdrop/pkgdrop

# Update AUR repo
cd /tmp/pkgdrop
git add pkgdrop
git commit -m "pkgdrop $VERSION"
git push

echo "Done! pkgdrop $VERSION pushed to AUR."
