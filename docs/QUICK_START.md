# 🎯 Quick Start for Beginners

## Installation

### Method 1: One-Line Install
```bash
curl -O https://raw.githubusercontent.com/theyonecodes/pkgdrop/main/src/pkgdrop && chmod +x pkgdrop && sudo mv pkgdrop /usr/local/bin/
```

### Method 2: AUR (Recommended)
```bash
yay -S pkgdrop
```

## Your First Install

### Example 1: Install a .tar.xz App
```bash
pkgdrop ~/Downloads/zen.linux-x86_64.tar.xz
```
**Result:** Zen browser installed to `~/.local/opt/zen/`

### Example 2: Install an AppImage
```bash
pkgdrop Handy_0.8.1_amd64.AppImage
```
**Result:** Installed to `~/.local/bin/Handy_0.8.1_amd64`

### Example 3: Install a pacman package
```bash
pkgdrop firefox.pkg.tar.zst
```
**Result:** Installed via `sudo pacman`

## Run the Installed App

### Option A: Type the name
```bash
zen.linux-x86_64     # Run Zen
Handy_0.8.1_amd64    # Run Handy
```

### Option B: Find it in applications menu
Look for the app in your desktop environment's application launcher.

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
DEBUG=1 pkgdrop your-file.tar.xz
```

## Next Steps

1. **Customize:** Look in `~/.local/opt/` to see installed apps
2. **Manage:** Apps are user-level (no root needed)
3. **Update:** `pkgdrop` auto-updates via your package manager