![pkgdrop Banner](https://raw.githubusercontent.com/theyonecodes/pkgdrop/main/.github/banner.svg)

<h1 align="center">pkgdrop</h1>

<p align="center">
  <strong>Universal Package Installer for Arch Linux</strong><br>
  Install AppImage, tar.xz, deb, rpm, and pacman packages with a single command.
</p>

<p align="center">
  <a href="https://github.com/theyonecodes/pkgdrop/actions/workflows/ci.yml">
    <img src="https://github.com/theyonecodes/pkgdrop/actions/workflows/ci.yml/badge.svg" alt="CI">
  </a>
  <a href="https://github.com/theyonecodes/pkgdrop/releases/latest">
    <img src="https://img.shields.io/github/v/release/theyonecodes/pkgdrop?color=6366f1&label=version" alt="Release">
  </a>
  <a href="https://aur.archlinux.org/packages/pkgdrop">
    <img src="https://img.shields.io/aur/version/pkgdrop?color=1793d1&label=AUR" alt="AUR">
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">
  </a>
  <a href="https://github.com/theyonecodes/pkgdrop/stargazers">
    <img src="https://img.shields.io/github/stars/theyonecodes/pkgdrop" alt="Stars">
  </a>
  <a href="https://github.com/theyonecodes/pkgdrop/issues">
    <img src="https://img.shields.io/github/issues/theyonecodes/pkgdrop" alt="Issues">
  </a>
</p>

---

## 🆕 New in v3.1.0 — Toolkit Integration

| Feature | Description |
|---------|-------------|
| **🛡️ Shared BackupEngine** | Now uses `theyonecodes/toolkit` BackupEngine — automatic pre-install snapshots of config, registry, binaries with SHA-256 manifest + rollback |
| **🤖 Jev Router Triage** | AI model routing with Choice/Score/Noul primitives — confidence scoring for AUR vs official repo, dependency resolution risk |
| **🎨 DarkTheme GUI** | New tkinter DarkTheme GUI (from `theyonecodes/toolkit`) — consistent with CISO-Auditor, Windows-Super-Smooth |
| **🔄 Reusable Core** | Core backup/restore logic migrated to `theyonecodes/toolkit` for use across Windows-Super-Smooth, electron-gpu-crash-fix, CISO-Auditor, universal-browser-backup |

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🔧 **Multi-format** | `.AppImage`, `.tar.xz`, `.tar.gz`, `.tar.zst`, `.deb`, `.rpm`, `.pkg.tar.*` |
| 🛡️ **Secure** | GPG signatures, checksums, sandbox extraction (bubblewrap/firejail) |
| ⚡ **Atomic** | Staging + commit with auto-rollback on failure |
| 📦 **Registry** | JSON database tracks packages, versions, files, ownership |
| 🔄 **Upgrade** | Compare versions, reinstall if newer |
| 🔍 **Audit** | Detect ghosts, orphans, broken symlinks, duplicates |
| 🎨 **GUI** | tkinter DarkTheme (from toolkit), Electron, GTK3 |
| 🪝 **Hooks** | Pre/post install and remove scripts |
| 🧹 **Clean** | Easy uninstall, broken symlink cleanup |
| **🛡️ BackupEngine** | Pre-install system snapshots with SHA-256 manifest + auto-rollback |
| **🤖 Jev Router** | AI triage for AUR vs official repo, dependency risk assessment |

---

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

## 🛡️ Shared BackupEngine (New)

The core backup/restore engine now lives in `theyonecodes/toolkit` and provides:

| Feature | Description |
|---------|-------------|
| **Automatic backups** | Before any file/registry/BCD/EFI change |
| **SHA-256 manifest** | Every backed-up item has a hash |
| **Automatic rollback** | On failure, restores from backup |
| **Cross-platform** | Python + PowerShell implementations |
| **Reusable** | Used by Windows-Super-Smooth, electron-gpu-crash-fix, CISO-Auditor, universal-browser-backup |

```bash
# pkgdrop now automatically creates pre-install snapshots
pkgdrop app.tar.xz
# Creates: ~/.local/share/pkgdrop/backups/pre-install-20261010-143022/
# With SHA-256 manifest and automatic rollback on failure
```

```python
# Python usage (from toolkit)
from toolkit.backup_engine import invoke_with_backup

result = invoke_with_backup(
    tool_name="pkgdrop",
    description="Install app.tar.xz",
    action=lambda: install_package("app.tar.xz"),
    file_paths=["/etc/pacman.conf", "/var/lib/pacman/local"],
    backup_bcd=False
)
```

---

## 🤖 Jev Router Triage (New)

AI model routing with Choice/Score/Noul primitives for package management decisions:

| Primitive | Purpose |
|-----------|---------|
| **Choice** | Select model for task (local vs cloud, AUR vs official) |
| **Score** | Confidence 0-100% based on capability match, cost, latency |
| **Noul** | Guardrails: if confidence < 70% → human review; if sensitive → human review |

**CLI Usage:**
```bash
# AUR vs official repo decision
python vendor/toolkit/jev-router/jev_router.py --choice system_optimization --context "{\"task_type\":\"package_install\",\"sensitive\":true,\"package_type\":\"aur\",\"required_capabilities\":[\"system_admin\",\"dependency_resolution\"]}"
```

**GUI Integration:**
- **Install dialog** → "JEV TRIAGE" button → confidence scoring for AUR vs official repo
- **Upgrade dialog** → risk assessment for dependency changes

---

## 🎨 DarkTheme GUI (New)

New tkinter DarkTheme GUI (from `theyonecodes/toolkit`):

```bash
python pkgdropGUI.py
```

Features:
- **File selector** with auto-type detection
- **Options**: Dry-run, Force, Verbose, System-wide, Extract mode
- **Actions**: Install, Uninstall, Upgrade, Audit, List, Clean
- **JEV TRIAGE** button → AI confidence scoring
- **Backup history** viewer
- **Live logging** with timestamps

Built on `theyonecodes/toolkit` DarkTheme — consistent with CISO-Auditor, Windows-Super-Smooth, electron-gpu-crash-fix, universal-browser-backup.

---

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
  -x, --extract       Extract AppImage to /opt (proper install)
```

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
| `TOOLKIT_PATH` | `~/.local/share/pkgdrop/toolkit` | Toolkit location |

### Config File
Create `~/.config/pkgdrop/config`:
```bash
PKGDROP_DIR="$HOME/.local/opt"
ASK_DEPENDENCIES=1
PKGDROP_MAX_SIZE=1073741824
PKGDROP_LOG="$HOME/.local/share/pkgdrop/install.log"
TOOLKIT_PATH="$HOME/.local/share/pkgdrop/toolkit"
```

---

## Supported Formats

| Format | Handler | Requires |
|--------|---------|----------|
| `*.pkg.tar.*` | pacman | sudo |
| `*.tar.xz` | extraction + symlink | - |
| `*.deb` | debtap | `debtap` (optional) |
| `*.AppImage` | copy to bin | - |
| `*.rpm` | alien + pacman | `alien` (optional) |

---

## 🛡️ Shared BackupEngine

The core backup/restore engine now lives in `theyonecodes/toolkit` and provides:

| Feature | Description |
|---------|-------------|
| **Automatic backups** | Before any file/registry/BCD/EFI change |
| **SHA-256 manifest** | Every backed-up item has a hash |
| **Automatic rollback** | On failure, restores from backup |
| **Cross-platform** | Python + PowerShell implementations |
| **Reusable** | Used by Windows-Super-Smooth, electron-gpu-crash-fix, CISO-Auditor, universal-browser-backup |

```bash
# pkgdrop now automatically creates pre-install snapshots
pkgdrop app.tar.xz
# Creates: ~/.local/share/pkgdrop/backups/pre-install-20261010-143022/
# With SHA-256 manifest and automatic rollback on failure
```

```python
# Python usage (from toolkit)
from toolkit.backup_engine import invoke_with_backup

result = invoke_with_backup(
    tool_name="pkgdrop",
    description="Install app.tar.xz",
    action=lambda: install_package("app.tar.xz"),
    file_paths=["/etc/pacman.conf", "/var/lib/pacman/local"],
    backup_bcd=False
)
```

---

## 🤖 Jev Router Triage

AI model routing with Choice/Score/Noul primitives for package management:

| Primitive | Purpose |
|-----------|---------|
| **Choice** | Select model for task (local vs cloud, AUR vs official) |
| **Score** | Confidence 0-100% based on capability match, cost, latency |
| **Noul** | Guardrails: if confidence < 70% → human review; if sensitive → human review |

**GUI Integration:**
- **Install dialog** → "JEV TRIAGE" button → confidence scoring for AUR vs official repo
- **Upgrade dialog** → risk assessment for dependency changes

**CLI Usage:**
```bash
# AUR vs official repo decision
python vendor/toolkit/jev-router/jev_router.py --choice system_optimization --context "{\"task_type\":\"package_install\",\"sensitive\":true,\"package_type\":\"aur\",\"required_capabilities\":[\"system_admin\",\"dependency_resolution\"]}"
```

---

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

---

## Atomic Installs

All installations use atomic operations:

1. Files are staged in a temporary directory
2. Checksums and signatures are verified
3. Staged files are atomically moved to the final location
4. If anything fails, the original installation is restored

---

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

---

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

---

## GUI Options

### tkinter DarkTheme GUI (New)
```bash
python pkgdropGUI.py
```
Built on `theyonecodes/toolkit` DarkTheme — consistent with CISO-Auditor, Windows-Super-Smooth.

### Electron GUI
```bash
cd gui
npm install    # First time only
./run-gui.sh   # Or: cd gui && electron .
```

### Python GTK GUI
```bash
./run-gui.sh --gtk
# or: python3 gui/gtk_gui.py
```

### Python tkinter GUI (Legacy)
```bash
./run-gui.sh --tkinter
# or: python3 gui/drag_drop_uninstall.py
```

### Desktop Integration
- **Konsole**: Settings → Quick Commands → Add `pkgdrop %f`
- **Dolphin**: Right-click → "Install with pkgdrop"
- **Desktop**: Right-click any supported file → Open With → "Install Package"

---

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
- **🛡️ BackupEngine** — Pre-install snapshots with SHA-256 manifest + auto-rollback
- **🤖 Jev Router** — AI triage for AUR vs official repo, dependency risk

---

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

---

## Project Structure

```
pkgdrop/
├── src/pkgdrop              # Main CLI script (v3.1.0)
├── pkgdropGUI.py            # tkinter DarkTheme GUI (NEW)
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
├── vendor/
│   └── toolkit/             # Git submodule (theyonecodes/toolkit)
│       ├── backup-engine/
│       ├── gui/dark-theme/
│       ├── jev-router/
│       └── ...
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

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for full version history.

### v3.1.0 (2026-10-12)
- **Toolkit integration**: BackupEngine, DarkTheme GUI, Jev Router
- **Shared BackupEngine**: Pre-install snapshots with SHA-256 manifest + auto-rollback
- **Jev Router**: AI triage for AUR vs official repo, dependency risk assessment
- **DarkTheme GUI**: tkinter GUI using `theyonecodes/toolkit` DarkTheme
- **tkinter GUI**: New `pkgdropGUI.py` with JEV TRIAGE button

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

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE)

## Links

- **GitHub:** https://github.com/theyonecodes/pkgdrop
- **AUR:** https://aur.archlinux.org/packages/pkgdrop
- **Issues:** https://github.com/theyonecodes/pkgdrop/issues
- **Toolkit:** https://github.com/theyonecodes/toolkit