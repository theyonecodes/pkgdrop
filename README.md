# pkgdrop

**Universal package installer for Arch Linux** - Install `.tar.xz`, `.deb`, `.AppImage`, `.rpm`, and pacman packages with a single command.

## Features

- Single command installation: `pkgdrop <file>`
- Konsole drag-and-drop support
- Desktop file integration
- Dolphin service menu support
- Auto-detection of package type
- User-level installations (~/.local/opt/)
- Dry-run mode to preview changes
- Uninstall and cleanup commands
- Color output with verbose mode

## Installation

### Method 1: AUR (Recommended)
```bash
yay -S pkgdrop
```

### Method 2: Manual
```bash
curl -O https://raw.githubusercontent.com/theyonecodes/pkgdrop/main/src/pkgdrop
chmod +x pkgdrop
sudo mv pkgdrop /usr/local/bin/
```

## CLI Reference

```
pkgdrop [OPTIONS] <file>

Options:
  -h, --help         Show help message
  -v, --version      Show version
  -l, --list         List installed packages
  -u, --uninstall    Uninstall a package by name
  -c, --clean        Remove broken symlinks
  -n, --dry-run      Preview installation without changes
  -V, --verbose      Show detailed output
  -y, --yes          Skip confirmation prompts
```

## Usage

### Install packages
```bash
pkgdrop app.tar.xz        # Install tar.xz portable
pkgdrop app.deb           # Install debian package
pkgdrop app.AppImage      # Install AppImage
pkgdrop app.pkg.tar.zst   # Install pacman package
pkgdrop app.rpm           # Install RPM package
```

### Preview changes
```bash
pkgdrop --dry-run app.tar.xz
```

### Manage installed packages
```bash
pkgdrop --list              # List all installed packages
pkgdrop --uninstall app     # Remove package by name
pkgdrop --clean             # Remove broken symlinks
```

### Verbose mode
```bash
pkgdrop --verbose app.tar.xz
```

## Supported Formats

| Format | Handler | Command |
|--------|---------|---------|
| `*.pkg.tar.*` | pacman | `sudo pacman -U` |
| `*.tar.xz` | tarportable | Extract + symlink |
| `*.deb` | debtap | `debtap` |
| `*.AppImage` | appimage | Copy to bin |
| `*.rpm` | alien | `alien` conversion |

## Integration

### Konsole
Add Quick Command:
- **Name:** Install Package
- **Command:** `pkgdrop %f`
- **Shortcut:** `Ctrl+Shift+I`

### Desktop
Right-click any supported file → Open With → "Install Package"

### Dolphin
Right-click → "Install with pkgdrop" from context menu.

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DEBUG` | `0` | Enable debug output |
| `VERBOSE` | `0` | Enable verbose output |
| `ASK_DEPENDENCIES` | `1` | Prompt for missing dependencies |
| `PKGDROP_DIR` | `~/.local/opt` | Installation directory |
| `PKGDROP_MAX_SIZE` | `1073741824` | Max file size (bytes) |
| `PKGDROP_LOG` | `~/.local/share/pkgdrop/install.log` | Log file path |

## Testing

```bash
# Run unit tests
bats tests/pkgdrop.bats

# Run integration tests
bats tests/integration.bats

# Docker testing
docker build -t pkgdrop-test . && docker run pkgdrop-test
```

## Documentation

- [Quick Start Guide](docs/QUICK_START.md)
- [Full Documentation](docs/index.html)
- [Man Page](docs/pkgdrop.1)

## License

MIT - see [LICENSE](LICENSE) file.
