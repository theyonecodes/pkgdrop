# Setup Guide

## Method 1: Direct Installation

```bash
curl -O https://raw.githubusercontent.com/theyonecodes/pkgdrop/main/pkgdrop
chmod +x pkgdrop
sudo mv pkgdrop /usr/local/bin/
```

## Method 2: AUR Installation

```bash
yay -S pkgdrop
# or
paru -S pkgdrop
```

## Konsole Integration

Add Quick Command in:
**Settings → Configure Konsole → Quick Commands**
- Name: Install Package
- Command: `pkgdrop %f`
- Shortcut: `Ctrl+Shift+I`

## Desktop Integration

Drag files directly onto `pkgdrop.desktop` icon.