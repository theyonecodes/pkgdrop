# pkgdrop Features

## Overview

**pkgdrop** is a universal package installer for Arch Linux that installs and manages `.tar.xz`, `.deb`, `.AppImage`, `.rpm`, and pacman packages with a single unified interface.

Version: **3.0.0**

---

## Installation Features

### Supported Package Formats

| Format | Handler | Notes |
|--------|---------|-------|
| `*.AppImage` | Copy to `~/.local/bin` | Simple copy or extract mode for sandboxing |
| `*.tar.xz`, `*.tar.gz`, `*.tar.zst`, `*.tar.bz2` | Extract to `~/.local/opt` + symlink | Auto-binary detection |
| `*.deb` | Convert via `debtap` + install | Optional dependency |
| `*.rpm` | Convert via `alien` + pacman | Optional dependency, requires sudo |
| `*.pkg.tar.zst`, `*.pkg.tar.xz` | Install via pacman | Requires sudo |

### Smart Detection
- Auto-detects package type by extension
- Finds executable binaries within extracted archives
- Desktop entry and icon integration
- MIME type association

### Installation Options

| Flag | Description |
|------|-------------|
| `-n, --dry-run` | Preview installation without changes |
| `-f, --force` | Force install (skip all confirmations) |
| `-S, --system` | Install system-wide (requires root) |
| `-x, --extract` | Extract AppImage properly (for sandbox setup) |
| `-y, --yes` | Skip all confirmation prompts |
| `-V, --verbose` | Show detailed output |

---

## Package Management

### List Packages
```bash
pkgdrop -l
# Shows: name, version, type (registry + filesystem views)
```

### Package Info
```bash
pkgdrop -i <name>
# Shows: version, installed date, type, all installed files
```

### Uninstall
```bash
pkgdrop -u <name>
# Removes: binary symlink, install directory, desktop entry, icons
```

### Upgrade
```bash
pkgdrop -U <name> <file>
# Compares versions, reinstalls if newer
```

### Ownership Tracking
```bash
pkgdrop -o <file>
# Shows which package owns a specific file
```

---

## Security Features

### Signature Verification
- GPG signatures (`.sig`, `.asc` files)
- SHA-256/SHA-512/MD5 checksums
- Auto-verification before install

### Sandbox Extraction
- **bubblewrap** support (preferred)
- **firejail** fallback
- Configurable via `PKGDROP_SANDBOX=0` to disable

### File Safety
- Atomic installs (staging + commit with rollback)
- File locking (prevents concurrent installs)
- Symlink validation (prevents path traversal)
- setuid/setgid stripping on extraction
- File size limits
- Quarantine mode for suspicious files

---

## Registry System

### JSON Database
Location: `~/.local/share/pkgdrop/registry.json`

Tracks:
- Package name and version
- Installation type (appimage, tarportable, etc.)
- All installed files per package
- Installation timestamp
- File ownership

### Conflict Detection
- Prevents overwriting files owned by other packages
- Takes ownership from old packages on reinstall
- Sanitized-name matching for differently-formatted names

---

## System Maintenance

### Audit System
```bash
pkgdrop -a
# Checks:
# - Ghost registry entries (registered but missing files)
# - Orphan directories (exist but not in registry)
# - Orphan binaries (in ~/.local/bin but not registered)
# - Broken symlinks
# - Duplicate desktop entries
# - Orphan desktop entries
# - Systemd services/timers
# - Pacman cross-references
```

### Prune (Auto-clean)
```bash
pkgdrop -a --prune
# Removes: ghosts, orphans, broken symlinks, duplicates
```

### Clean Broken
```bash
pkgdrop -c
# Removes broken symlinks from ~/.local/bin and /usr/local/bin
```

---

## Desktop Integration

### Desktop Entries
- Auto-creates `.desktop` files in `~/.local/share/applications`
- Proper `StartupWMClass` for app icon association
- Categories from embedded desktop files

### Icon Installation
- Copies icons to `~/.local/share/icons/hicolor/*/apps/`
- Backup in `~/.local/share/pkgdrop/icons/`
- Resolves icons from AppImage/tarball metadata

### Desktop Refresh
- Updates: `update-desktop-database`
- Icon cache: `gtk-update-icon-cache`
- KDE: `kbuildsycoca5/6`

---

## Hook System

Scripts in `~/.config/pkgdrop/hooks/`:

| Hook | Trigger |
|------|---------|
| `pre-install` | Before installation |
| `post-install` | After successful installation |
| `pre-remove` | Before uninstallation |
| `post-remove` | After uninstallation |

Environment variables passed:
- `PKGDROP_PKG_NAME`
- `PKGDROP_PKG_VERSION`
- `PKGDROP_PKG_TYPE`
- `PKGDROP_INSTALL_DIR`

---

## GUI Features

### Electron GUI
Modern dark-themed desktop application with:
- Dashboard (package stats, quick actions)
- Package list with search/filter
- Drag-and-drop installation
- System audit with prune
- Real-time pkgdrop status

Launch: `cd gui && electron .` or `./run-gui.sh --electron`

### Python GTK GUI
Lightweight GTK3 GUI.
Launch: `python3 gui/gtk_gui.py` or `./run-gui.sh --gtk`

### Python tkinter GUI
Simple uninstall tool with drag-and-drop.
Launch: `python3 gui/drag_drop_uninstall.py` or `./run-gui.sh --tkinter`

### Dolphin Integration
Service menu entry for right-click install.

### Konsole Integration
Quick commands for drag-and-drop install.

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DEBUG` | `0` | Enable debug output |
| `VERBOSE` | `0` | Enable verbose output |
| `ASK_DEPENDENCIES` | `1` | Prompt for missing dependencies |
| `PKGDROP_DIR` | `~/.local/opt` | Installation directory |
| `PKGDROP_MAX_SIZE` | `1073741824` | Max file size (1GB) |
| `PKGDROP_LOG` | `~/.local/share/pkgdrop/install.log` | Log file |
| `PKGDROP_SANDBOX` | `1` | Enable sandbox extraction |
| `PKGDROP_EXTRACT_DIR` | `/opt` | AppImage extract mode directory |

---

## Configuration

Config file: `~/.config/pkgdrop/config`

```bash
PKGDROP_DIR="$HOME/.local/opt"
ASK_DEPENDENCIES=1
PKGDROP_MAX_SIZE=1073741824
PKGDROP_LOG="$HOME/.local/share/pkgdrop/install.log"
PKGDROP_SANDBOX=1
```

---

## CLI Options Reference

```
Usage: pkgdrop [OPTIONS] <file>

Options:
  -h, --help          Show help message
  -v, --version       Show version
  -l, --list          List installed packages
  -u, --uninstall     Uninstall a package
  -U, --upgrade       Upgrade a package (reinstall if newer)
  -i, --info          Show package info
  -o, --owns <file>   Show which package owns a file
  -c, --clean         Remove broken symlinks
  -a, --audit         Audit registry vs filesystem
  -a, --audit --prune  Audit and remove orphans
  -x, --extract       Extract AppImage to /opt (sandbox mode)
  -f, --force         Force install (skip confirmations)
  -S, --system        Install system-wide (requires root)
  -n, --dry-run       Preview installation without changes
  -V, --verbose       Show detailed output
  -y, --yes           Skip confirmation prompts
```

---

## Quick Examples

```bash
# Install a package
pkgdrop app.tar.xz

# Install AppImage
pkgdrop app.AppImage

# Preview
pkgdrop -n app.tar.xz

# List packages
pkgdrop -l

# Show info
pkgdrop -i appname

# Uninstall
pkgdrop -u appname

# Upgrade
pkgdrop -U appname new-app.tar.xz

# Audit
pkgdrop -a

# Clean broken symlinks
pkgdrop -c

# Extract AppImage with sandbox
pkgdrop -x app.AppImage
```

---

## Install Methods

### AUR (Arch Linux)
```bash
yay -S pkgdrop
```

### AppImage (Universal)
```bash
curl -LO https://github.com/theyonecodes/pkgdrop/releases/latest/download/pkgdrop.AppImage
chmod +x pkgdrop.AppImage
./pkgdrop.AppImage --install  # Self-install
```

### Manual
```bash
curl -LO https://raw.githubusercontent.com/theyonecodes/pkgdrop/main/src/pkgdrop
chmod +x pkgdrop
sudo mv pkgdrop /usr/local/bin/
```

---

## Requirements

### Runtime
- Bash 4.0+
- tar, coreutils
- jq (for registry)
- sudo (for system installs)

### Optional
- `bubblewrap` or `firejail` (sandbox extraction)
- `debtap` (.deb support)
- `alien` (.rpm support)
- `pacman` (.pkg.tar.* support)
- `gpg` (signature verification)

### GUI
- Node.js + Electron (Electron GUI)
- Python3 + GTK3 (GTK GUI)
- Python3 (tkinter GUI)