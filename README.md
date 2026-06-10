# pkgdrop

**Universal package installer for Arch Linux** - Install `.tar.xz`, `.deb`, `.AppImage`, `.rpm`, and pacman packages with a single command.

[![CI](https://github.com/theyonecodes/pkgdrop/actions/workflows/ci.yml/badge.svg)](https://github.com/theyonecodes/pkgdrop/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- **Universal support:** `.tar.xz`, `.deb`, `.AppImage`, `.rpm`, `.pkg.tar.*`
- **Simple:** One command installs anything
- **Safe:** Dry-run mode, quarantine, symlink validation
- **Smart:** Auto-detects package type, finds binaries, manages dependencies
- **Integrated:** Konsole drag-and-drop, Desktop entry, Dolphin service menu
- **Clean:** Easy uninstall, broken symlink cleanup

## Installation

### AUR (Recommended)
```bash
yay -S pkgdrop
```

### Manual
```bash
curl -O https://raw.githubusercontent.com/theyonecodes/pkgdrop/main/src/pkgdrop
chmod +x pkgdrop
sudo mv pkgdrop /usr/local/bin/
```

## Quick Start

```bash
# Install a package
pkgdrop app.tar.xz

# Preview what would happen
pkgdrop --dry-run app.tar.xz

# List installed packages
pkgdrop --list

# Uninstall a package
pkgdrop --uninstall app

# Remove broken symlinks
pkgdrop --clean
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

## Supported Formats

| Format | Handler | Requires |
|--------|---------|----------|
| `*.pkg.tar.*` | pacman | sudo |
| `*.tar.xz` | extraction + symlink | - |
| `*.deb` | debtap | `debtap` (optional) |
| `*.AppImage` | copy to bin | - |
| `*.rpm` | alien | `alien` (optional) |

## GUI Integration

### Konsole (Terminal)
1. Settings → Configure Konsole → Quick Commands
2. Add: Name = `Install Package`, Command = `pkgdrop %f`
3. Drag files onto Konsole to install

### Desktop
Right-click any supported file → Open With → "Install Package"

### Dolphin
Right-click → "Install with pkgdrop"

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DEBUG` | `0` | Enable debug output |
| `VERBOSE` | `0` | Enable verbose output |
| `ASK_DEPENDENCIES` | `1` | Prompt for missing dependencies |
| `PKGDROP_DIR` | `~/.local/opt` | Installation directory |
| `PKGDROP_MAX_SIZE` | `1073741824` | Max file size in bytes |
| `PKGDROP_LOG` | `~/.local/share/pkgdrop/install.log` | Log file path |

### Config File

Create `~/.config/pkgdrop/config`:
```bash
PKGDROP_DIR="$HOME/.local/opt"
ASK_DEPENDENCIES=1
PKGDROP_MAX_SIZE=1073741824
PKGDROP_LOG="$HOME/.local/share/pkgdrop/install.log"
```

## Security Features

- **File locking** prevents concurrent installs
- **Quarantine mode** for suspicious archives
- **Symlink validation** catches path traversal
- **setuid/setgid stripping** on extracted files
- **Sudo warnings** before elevation
- **File size limits** prevent disk fill attacks
- **Archive validation** checks integrity before extraction

## Testing

```bash
# Unit tests
bats tests/pkgdrop.bats

# Integration tests
bats tests/integration.bats

# Syntax check
bash -n src/pkgdrop && shellcheck src/pkgdrop

# Docker testing
docker build -t pkgdrop-test . && docker run pkgdrop-test
```

## Project Structure

```
pkgdrop/
├── src/pkgdrop              # Main script
├── install.sh               # System installer
├── uninstall.sh             # System uninstaller
├── push-aur.sh              # AUR update helper
├── tests/
│   ├── pkgdrop.bats         # Unit tests
│   ├── integration.bats     # Integration tests
│   └── fixtures/            # Test packages
├── completions/
│   ├── pkgdrop.bash         # Bash completions
│   └── _pkgdrop             # Zsh completions
├── deploy/
│   ├── PKGBUILD             # AUR package
│   ├── .SRCINFO             # AUR metadata
│   ├── pkgdrop.desktop      # Desktop entry
│   ├── pkgdrop.install      # AUR post-install
│   └── dolphin/             # Dolphin service menu
├── docs/
│   ├── pkgdrop.1            # Man page
│   ├── QUICK_START.md       # Beginner guide
│   └── index.html           # Documentation index
├── .github/workflows/
│   ├── ci.yml               # CI pipeline
│   ├── release.yml          # Release automation
│   └── sync-aur.yml         # AUR sync
├── Dockerfile               # Docker testing
├── Makefile                 # Build targets
├── CHANGELOG.md             # Version history
├── CONTRIBUTING.md          # Contribution guide
├── LICENSE                  # MIT License
└── README.md                # This file
```

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for full version history.

### Latest: v2.0.0 (2026-06-11)
- File locking, quarantine, symlink validation
- `--dry-run`, `--verbose`, `--uninstall`, `--clean`
- `.rpm` support via alien
- Man page, completions, tests
- Docker support

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE)

## Links

- **GitHub:** https://github.com/theyonecodes/pkgdrop
- **AUR:** https://aur.archlinux.org/packages/pkgdrop
- **Issues:** https://github.com/theyonecodes/pkgdrop/issues
