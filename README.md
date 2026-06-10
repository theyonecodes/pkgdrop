# pkgdrop

**Universal package installer for Arch Linux** - Install `.tar.xz`, `.deb`, `.AppImage`, and pacman packages with a single command.

## Features

- 🚀 Single command installation: `pkgdrop <file>`
- 🖱️ Konsole drag-and-drop support
- 💻 Desktop file integration
- 📁 Dolphin service menu support
- 🔍 Auto-detection of package type
- 📦 User-level installations (~/.local/opt/)

## Installation

### Method 1: Direct
```bash
curl -O https://raw.githubusercontent.com/theyonecodes/pkgdrop/main/src/pkgdrop
chmod +x pkgdrop
sudo mv pkgdrop /usr/local/bin/
```

### Method 2: AUR
```bash
yay -S pkgdrop
```

## Quick Start

```bash
# Install any supported package
pkgdrop zen.linux-x86_64.tar.xz    # ✅ Tested - installs to ~/.local/opt/
pkgdrop package.deb                 # Requires debtap
pkgdrop app.AppImage               # Moves to ~/.local/bin/
pkgdrop package.pkg.tar.zst        # Uses sudo pacman -U
```

## Supported Formats

| Format | Handler | Command |
|--------|---------|---------|
| `*.pkg.tar.*` | pacman | `sudo pacman -U` |
| `*.tar.xz` | tarportable | Extract + symlink |
| `*.deb` | debtap | `debtap` |
| `*.AppImage` | appimage | Move to bin |

## Integration

### Konsole
Add Quick Command:
- **Name:** Install Package
- **Command:** `pkgdrop %f`
- **Shortcut:** `Ctrl+Shift+I`

### Desktop
Drag files onto `pkgdrop.desktop` to install.

### Dolphin
Right-click → "Install with pkgdrop" from context menu.

## Documentation

- [Technical Docs (HTML)](docs/TECHNICAL_DOCS.html)
- [Specification (HTML)](docs/SPEC.html)
- [Usage Guide](docs/README-USAGE.md)

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md)

## License

MIT - see [LICENSE](LICENSE) file.