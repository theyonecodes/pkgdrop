# Usage Guide

## Basic Usage

```bash
pkgdrop package.tar.xz
pkgdrop package.deb
pkgdrop package.AppImage
pkgdrop package.pkg.tar.zst
```

## Supported Formats

| Format | Handler | Status | Example |
|--------|---------|--------|---------|
| `*.pkg.tar.*` | pacman | ✅ Working | `pkgdrop firefox.pkg.tar.zst` |
| `*.tar.xz` | tarportable | ✅ Working | `pkgdrop zen.linux-x86_64.tar.xz` |
| `*.deb` | debtap | ⏳ Requires debtap | `pkgdrop app.deb` |
| `*.AppImage` | appimage | ✅ Working | `pkgdrop app.AppImage` |

## Input Methods

1. **Terminal**: `pkgdrop <file>`
2. **Konsole**: Quick Command (drag file)
3. **Desktop**: Drag file onto .desktop icon
4. **File Manager**: Right-click → "Install with pkgdrop"