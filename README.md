# pkgdrop

**Universal package installer for Arch Linux** - Install `.tar.xz`, `.deb`, `.AppImage`, `.rpm`, and pacman packages with a single command.

[![CI](https://github.com/theyonecodes/pkgdrop/actions/workflows/ci.yml/badge.svg)](https://github.com/theyonecodes/pkgdrop/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features
- **Audit & Cleanup:** Audit registry vs filesystem consistency, remove orphans with `--audit` and `--audit --prune`

- **Universal support:** `.tar.xz`, `.deb`, `.AppImage`, `.rpm`, `.pkg.tar.*`
- **Atomic installs:** Staging directory + atomic commit, auto-rollback on failure
- **Package registry:** JSON database tracks installed packages, versions, and files
- **Version awareness:** Compares installed vs candidate versions, upgrade support
- **Conflict detection:** File ownership tracking prevents overwrites
- **Signature verification:** GPG signature and checksum validation
- **Sandbox extraction:** bubblewrap/firejail sandboxing for untrusted archives
- **Hook system:** Pre/post install hooks for custom automation
- **Smart:** Auto-detects package type, finds binaries, manages dependencies
- **Integrated:** Desktop entry, icon installation, MIME types
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

# Upgrade a package
pkgdrop -U app.tar.xz

# Preview what would happen
pkgdrop --dry-run app.tar.xz

# List installed packages (with version info)
pkgdrop --list

# Show package info
pkgdrop --info app

# Uninstall a package
pkgdrop --uninstall app

# Remove broken symlinks
pkgdrop --clean
```

## CLI Reference

```
pkgdrop [OPTIONS] <file>

Options:
  -h, --help          Show help message
  -v, --version       Show version
  -l, --list          List installed packages (with versions)
  -u, --uninstall     Uninstall a package by name
  -U, --upgrade       Upgrade a package (reinstall if newer)
  -i, --info          Show package info (version, files, type)
  -o, --owns <file>   Show which package owns a file
  -c, --clean         Remove broken symlinks
  -f, --force         Force install (skip confirmations)
  -S, --system        Install system-wide (requires root)
  -n, --dry-run       Preview installation without changes
  -V, --verbose       Show detailed output
  -y, --yes           Skip confirmation prompts
```

## Supported Formats

| Format | Handler | Requires |
|--------|---------|----------|
| `*.pkg.tar.*` | pacman | sudo |
| `*.tar.xz` | extraction + symlink | - |
| `*.deb` | debtap | `debtap` (optional) |
| `*.AppImage` | copy to bin | - |
| `*.rpm` | alien + pacman | `alien` (optional) |

## Package Registry

pkgdrop maintains a JSON registry at `~/.local/share/pkgdrop/registry.json` that tracks:

- Package name, version, and install type
- All installed files per package
- Installation timestamp
- File ownership (prevents conflicts)

```bash
# List all registered packages
pkgdrop --list

# Show detailed info about a package
pkgdrop --info app

# Find which package owns a file
pkgdrop --owns /path/to/file
```

## Atomic Installs

All installations use atomic operations:

1. Files are staged in a temporary directory
2. Checksums and signatures are verified
3. Staged files are atomically moved to the final location
4. If anything fails, the original installation is restored

## Signature Verification

pkgdrop automatically verifies:

- GPG signatures (`.sig` or `.asc` files alongside the package)
- SHA-256/SHA-512/MD5 checksums (`.sha256`, `.sha512`, `.md5` files)

```bash
# Install with verification
pkgdrop signed-package.tar.xz

# Force install without verification
pkgdrop --force unsigned-package.tar.xz
```

## Hook System

Create scripts in `~/.config/pkgdrop/hooks/` (or `/usr/share/pkgdrop/hooks/`):

```bash
# ~/.config/pkgdrop/hooks/pre-install-mynotification
#!/bin/bash
notify-send "Installing $PKGDROP_PKG_NAME v$PKGDROP_PKG_VERSION"
```

Available hooks: `pre-install`, `post-install`, `pre-remove`, `post-remove`

Environment variables passed to hooks:
- `PKGDROP_PKG_NAME` - Package name
- `PKGDROP_PKG_VERSION` - Package version
- `PKGDROP_PKG_TYPE` - Package type (tarportable, appimage, etc.)
- `PKGDROP_INSTALL_DIR` - Installation directory

## GUI Integration

pkgdrop offers multiple GUI options:

### Electron GUI (Recommended)
Full-featured desktop application with modern dark theme.

```bash
cd gui
npm install    # First time only
./run-gui.sh   # Or: cd gui && electron .
```

Features:
- Dashboard with package statistics
- Package list with search/filter
- Drag-and-drop installation
- System audit with prune
- Real-time status indicator

### Python GTK GUI
Lightweight GTK3-based GUI (no npm/electron needed).

```bash
./gui/run-gui.sh --gtk
# or: python3 gui/gtk_gui.py
```

### Python tkinter GUI
Simple uninstall tool with drag-and-drop support.

```bash
./gui/run-gui.sh --tkinter
# or: python3 gui/drag_drop_uninstall.py
```

### Konsole (Terminal)
1. Settings → Configure Konsole → Quick Commands
2. Add: Name = `Install Package`, Command = `pkgdrop %f`
3. Drag files onto Konsole to install

### Desktop
Right-click any supported file → Open With → "Install Package"

### Dolphin
Right-click → "Install with pkgdrop"

### GUI Quick Reference

| GUI | Command | Dependencies |
|-----|---------|--------------|
| Electron | `./run-gui.sh --electron` | Node.js, electron |
| GTK | `./run-gui.sh --gtk` | Python3, GTK3 |
| tkinter | `./run-gui.sh --tkinter` | Python3 |
| CLI | `pkgdrop -l` | None |

Run `./run-gui.sh --help` for all options.

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
| `PKGDROP_SANDBOX` | `1` | Enable sandbox extraction |

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
- **Atomic installs** with automatic rollback on failure
- **Package registry** tracks file ownership and prevents conflicts
- **Signature verification** for GPG and checksums
- **Sandbox extraction** via bubblewrap/firejail
- **Quarantine mode** for suspicious archives
- **Symlink validation** catches path traversal
- **setuid/setgid stripping** on extracted files
- **Sudo warnings** before elevation
- **File size limits** prevent disk fill attacks
- **Archive validation** checks integrity before extraction
- **Hook system** for custom security policies

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
├── src/pkgdrop              # Main CLI script (v3.0.0)
├── gui/                     # GUI applications
│   ├── run-gui.sh           # Unified GUI launcher
│   ├── index.html           # Electron HTML
│   ├── main.js              # Electron main process
│   ├── preload.js           # Electron preload (IPC bridge)
│   ├── app.js               # Electron renderer JS
│   ├── styles.css           # Electron CSS (dark theme)
│   ├── package.json         # Electron dependencies
│   ├── gtk_gui.py           # Python GTK3 GUI (fallback)
│   ├── drag_drop_uninstall.py  # Python tkinter GUI (fallback)
│   └── uninstall_gui.sh     # tkinter GUI launcher
├── install.sh               # System installer
├── uninstall.sh             # System uninstaller
├── push-aur.sh              # AUR update helper
├── tests/
│   └── pkgdrop.bats         # Unit tests
├── completions/
│   ├── pkgdrop.bash         # Bash completions
│   └── _pkgdrop             # Zsh completions
├── deploy/
│   ├── pkgdrop.desktop      # Desktop entry
│   └── dolphin/             # Dolphin service menu
├── docs/
│   └── pkgdrop.1            # Man page
├── Dockerfile               # Docker testing
├── Makefile                 # Build targets
├── CHANGELOG.md             # Version history
└── README.md                # This file
```

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for full version history.

### v3.0.0 (2026-06-13)
- Atomic installs with staging directory + commit
- Package registry (JSON database)
- Version comparison and upgrade support (`-U`)
- Conflict detection with file ownership tracking
- Package info (`-i`) and owns (`-o`) commands
- GPG signature and checksum verification
- Sandbox extraction (bubblewrap/firejail)
- Hook system (pre/post install/remove)
- Force flag (`-f`) to skip confirmations
- Progress bar for large archives

### v2.0.0 (2026-06-11)
- File locking, quarantine, symlink validation
- `--dry-run`, `--verbose`, `--uninstall`, `--clean`
- `.rpm` support via alien
- Man page, completions, tests
- Docker support

### v1.0.0 (2026-06-01)
- Initial release
- `.tar.xz`, `.deb`, `.AppImage`, `.pkg.tar.*` support
- Desktop integration, auto-binary detection

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE)

## Links

- **GitHub:** https://github.com/theyonecodes/pkgdrop
- **AUR:** https://aur.archlinux.org/packages/pkgdrop
- **Issues:** https://github.com/theyonecodes/pkgdrop/issues
