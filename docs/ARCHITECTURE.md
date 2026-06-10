# pkgdrop - Architecture

## System Overview

```
┌─────────────────────────────────────────────────┐
│                   User Interface                 │
│  CLI (pkgdrop) │ Desktop Entry │ Dolphin Menu   │
└──────────┬──────────────────────────┬───────────┘
           │                          │
┌──────────▼──────────────────────────▼───────────┐
│               Core Engine (src/pkgdrop)          │
│  ┌──────────┐ ┌──────────┐ ┌──────────────────┐│
│  │ Detector │ │ Handlers │ │ Desktop Manager  ││
│  │ (type)   │ │ (install)│ │ (.desktop+icons) ││
│  └──────────┘ └──────────┘ └──────────────────┘│
└──────────┬──────────────────────────┬───────────┘
           │                          │
┌──────────▼──────────┐  ┌────────────▼───────────┐
│   File System       │  │   System Integration   │
│ ~/.local/opt/       │  │ ~/.local/bin/          │
│ ~/.local/bin/       │  │ ~/.local/share/apps/   │
│ ~/.config/pkgdrop/  │  │ ~/.local/share/icons/  │
└─────────────────────┘  └────────────────────────┘
```

## Data Flow

### Install Flow (tar.xz)
```
1. Validate file (size, type, integrity)
2. Detect type → tarportable
3. Check if already installed → prompt reinstall
4. Extract to ~/.local/opt/{name}/
5. Find binary in extracted files
6. Create symlink ~/.local/bin/{name} → binary
7. Find icon in extracted files
8. Install icon to hicolor theme
9. Create .desktop entry
10. Refresh desktop database
11. Show summary
```

### Install Flow (AppImage)
```
1. Validate file (size, ELF magic bytes)
2. Detect type → appimage
3. Check if already installed → prompt reinstall
4. Copy to ~/.local/bin/{name}
5. Set executable permissions
6. Try to extract icon from AppImage
7. Install icon to hicolor theme
8. Create .desktop entry
9. Refresh desktop database
10. Show summary
```

### Uninstall Flow
```
1. Check if package exists
2. Prompt for confirmation
3. Remove ~/.local/opt/{name}/
4. Remove ~/.local/bin/{name}
5. Remove .desktop entry
6. Remove icon from hicolor theme
7. Refresh desktop database
```

## Module Reference

### Type Detection (`detect_type`)
```
*.pkg.tar.*  → pacman
*.tar.xz     → tarportable
*.deb        → debtap
*.AppImage   → appimage
*.rpm        → alien
```

### Name Sanitization (`sanitize_name`)
```
Input:  zen.linux-x86_64.tar.xz
Step 1: zen.linux-x86_64 (remove .tar.xz)
Step 2: zen (remove .linux-x86_64)
Output: zen
```

### Desktop Integration
- `find_icon()` - searches extracted files for icons
- `create_desktop_entry()` - generates .desktop file
- `refresh_desktop()` - updates KDE/GNOME database
- `cleanup_desktop()` - removes entries on uninstall

## File Layout

```
~/.local/
├── opt/
│   └── {name}/           # Extracted package files
│       └── {binary}      # Actual executable
├── bin/
│   └── {name}            # Symlink to binary
├── share/
│   ├── applications/
│   │   └── pkgdrop-{name}.desktop
│   └── icons/
│       └── hicolor/
│           └── 128x128/
│               └── apps/
│                   └── pkgdrop-{name}.png
└── config/
    └── pkgdrop/
        └── config        # User configuration
```

## Security Model

1. **File locking** - prevents concurrent installs
2. **Size limits** - configurable max file size
3. **Symlink validation** - catches path traversal
4. **setuid stripping** - removes dangerous permissions
5. **Sudo warnings** - explicit before elevation
6. **Quarantine** - optional for suspicious packages

## Dependencies

### Required
- bash 5.0+
- tar
- find
- coreutils (mkdir, chmod, ln, rm)

### Optional
- debtap (for .deb)
- alien (for .rpm)
- yay/paru (for AUR helper detection)

## Configuration

```bash
# ~/.config/pkgdrop/config
PKGDROP_DIR="$HOME/.local/opt"
ASK_DEPENDENCIES=1
PKGDROP_MAX_SIZE=1073741824
PKGDROP_LOG="$HOME/.local/share/pkgdrop/install.log"
```
