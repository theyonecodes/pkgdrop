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

## 🚀 How to Use pkgdrop (For Beginners)

### Step 1: Install pkgdrop

**Option A: From AUR (Easiest)**
```bash
yay -S pkgdrop
```

**Option B: Manual Install**
```bash
curl -O https://raw.githubusercontent.com/theyonecodes/pkgdrop/main/src/pkgdrop
chmod +x pkgdrop
sudo mv pkgdrop /usr/local/bin/
```

### Step 2: Use It!

Just type `pkgdrop` followed by your file:

```bash
pkgdrop your-app.tar.xz
pkgdrop your-app.deb
pkgdrop your-app.AppImage
pkgdrop your-app.pkg.tar.zst
```

### Step 3: Add to PATH (If Needed)

If you get "command not found", add this to your shell config:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 🖱️ GUI Methods (No Terminal Needed)

**Konsole (Terminal):**
1. Open Konsole
2. Go to Settings → Configure Konsole → Quick Commands
3. Click "Add"
4. Name: `Install Package`, Command: `pkgdrop %f`
5. Now drag files onto the Konsole window!

**Desktop:**
- Right-click any file → Open With → "Install Package"

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