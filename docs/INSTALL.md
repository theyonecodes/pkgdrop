# Installing pkgdrop

## Quick Install (AUR)

```bash
# Using yay
yay -S pkgdrop

# Using paru
paru -S pkgdrop
```

## Manual Installation (Any Linux)

### Option 1: AppImage (Recommended)

```bash
# Download latest AppImage
curl -LO https://github.com/theyonecodes/pkgdrop/releases/latest/download/pkgdrop.AppImage
chmod +x pkgdrop.AppImage

# Run without installing
./pkgdrop.AppImage

# Install to system
sudo mv pkgdrop.AppImage /usr/local/bin/pkgdrop
# or
./pkgdrop.AppImage --install
```

### Option 2: CLI Only

```bash
# Download
curl -LO https://raw.githubusercontent.com/theyonecodes/pkgdrop/main/src/pkgdrop
chmod +x pkgdrop

# Install
sudo mv pkgdrop /usr/local/bin/

# Add bash completion
sudo cp pkgdrop /usr/share/bash-completion/completions/pkgdrop
```

### Option 3: Git Clone

```bash
git clone https://github.com/theyonecodes/pkgdrop.git
cd pkgdrop

# CLI only
sudo cp src/pkgdrop /usr/local/bin/

# GUI (Electron)
cd gui && npm install && cd ..
./gui/run-gui.sh --electron
```

## GUI Installation

### Electron GUI (Full-featured)

```bash
# Install via AUR or AppImage (includes GUI)
yay -S pkgdrop

# Launch
pkgdrop-gui
# or
cd /usr/share/pkgdrop/gui && electron .
```

### Python GTK GUI (Lightweight fallback)

```bash
pkgdrop-gui --gtk
# or
python3 /usr/share/pkgdrop/gui/gtk_gui.py
```

### Python tkinter GUI (Minimal)

```bash
pkgdrop-gui --tkinter
# or
python3 /usr/share/pkgdrop/gui/drag_drop_uninstall.py
```

## Features

See [FEATURES.md](./FEATURES.md) for full feature list.

### Supported Formats
- `.AppImage` - Copy to bin or extract for sandbox
- `.tar.xz`, `.tar.gz`, `.tar.zst`, `.tar.bz2` - Extract + symlink
- `.deb` - Convert via debtap
- `.rpm` - Convert via alien
- `.pkg.tar.zst`, `.pkg.tar.xz` - Pacman packages

### Key Commands
| Command | Description |
|---------|-------------|
| `pkgdrop <file>` | Install package |
| `pkgdrop -l` | List packages |
| `pkgdrop -i <name>` | Show info |
| `pkgdrop -u <name>` | Uninstall |
| `pkgdrop -U <name> <file>` | Upgrade |
| `pkgdrop -a` | Audit system |
| `pkgdrop -a --prune` | Clean orphans |
| `pkgdrop -x <file>` | Extract AppImage with sandbox |
| `pkgdrop -c` | Clean broken symlinks |

## Requirements

### CLI
- Bash 4.0+
- tar
- jq

### Optional
- `bubblewrap` or `firejail` - Sandbox extraction
- `debtap` - .deb support
- `alien` - .rpm support
- `pacman` - .pkg.tar.* support
- `gpg` - Signature verification

### GUI
- Node.js + Electron (Electron GUI)
- Python3 + GTK3 (GTK GUI)
- Python3 + tkinter (tkinter GUI)

## Configuration

Config file: `~/.config/pkgdrop/config`

```bash
PKGDROP_DIR="$HOME/.local/opt"
ASK_DEPENDENCIES=1
PKGDROP_SANDBOX=1
```

Environment variables:
- `DEBUG=1` - Debug output
- `VERBOSE=1` - Verbose output
- `PKGDROP_DIR` - Install directory
- `PKGDROP_SANDBOX=0` - Disable sandbox

## Uninstall

```bash
# Via AUR
yay -R pkgdrop

# Manual
sudo rm /usr/local/bin/pkgdrop
sudo rm /usr/share/applications/pkgdrop.desktop
rm -rf ~/.config/pkgdrop
rm -rf ~/.local/share/pkgdrop
```

## Support

- GitHub Issues: https://github.com/theyonecodes/pkgdrop/issues
- AUR Comments: https://aur.archlinux.org/packages/pkgdrop