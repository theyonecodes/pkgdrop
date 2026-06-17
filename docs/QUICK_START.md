# Quick Start for Beginners

## Installation

### Method 1: Install Script (Recommended)
```bash
git clone https://github.com/theyonecodes/pkgdrop.git
cd pkgdrop
./install.sh
```
A polkit dialog will appear asking for your password.

### Method 2: AUR
```bash
yay -S pkgdrop
```

### Method 3: Manual
```bash
sudo cp src/pkgdrop /usr/bin/pkgdrop
```

## Your First Install

### Example 1: Install a .tar.xz App
```bash
pkgdrop ~/Downloads/zen.linux-x86_64.tar.xz
```
**Result:**
- App installed to `~/.local/opt/zen/`
- Binary symlinked to `~/.local/bin/zen`
- Desktop entry created (appears in launcher)
- Icon installed to hicolor theme

### Example 2: Install an AppImage
```bash
pkgdrop ~/Downloads/Handy_0.8.1_amd64.AppImage
```
**Result:** Installed to `~/.local/bin/Handy`

### Example 3: Install a pacman package
```bash
pkgdrop ~/Downloads/firefox.pkg.tar.zst
```
**Result:** Installed via `sudo pacman -U`

## Run the Installed App

### Option A: Type the name
```bash
zen
```

### Option B: Find it in applications menu
Look for "Zen" in your desktop environment's application launcher.

## Useful Commands

| Command | Description |
|---------|-------------|
| `pkgdrop --list` | List installed packages |
| `pkgdrop --uninstall zen` | Remove a package |
| `pkgdrop --dry-run file.tar.xz` | Preview without installing |
| `pkgdrop --verbose file.tar.xz` | Show detailed steps |
| `pkgdrop --clean` | Remove broken symlinks |
| `pkgdrop --audit` | Audit registry vs filesystem consistency |
| `pkgdrop --audit --prune` | Audit and remove orphaned files |

## Troubleshooting

### "command not found"
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### ".deb skipped - debtap not found"
```bash
yay -S debtap
pkgdrop your-app.deb
```

### Nothing happens
```bash
pkgdrop --verbose your-file.tar.xz
```

## Next Steps

1. **Customize:** Look in `~/.local/opt/` to see installed apps
2. **Manage:** Apps are user-level (no root needed after install)
3. **Update:** Run `pkgdrop` again to reinstall/update
