# Spec: Desktop Integration

**Feature:** Auto-create .desktop entries on install  
**Version:** 2.0.0  
**Status:** Implemented

## Requirements

1. Every installed package must have a .desktop entry
2. .desktop entry must follow freedesktop.org specification
3. Icons must be extracted from archive and installed to hicolor theme
4. Display names must be human-readable (capitalize, spaces)
5. Desktop database must be refreshed after install/uninstall

## Implementation

### Desktop Entry Format
```ini
[Desktop Entry]
Version=1.0
Type=Application
Name=Zen Browser
Exec=/home/user/.local/bin/zen %u
Icon=pkgdrop-zen
Terminal=false
StartupWMClass=zen
Categories=Utility;
MimeType=text/html;text/plain;application/xhtml+xml;
StartupNotify=true
```

### Icon Installation
```
Source: ~/.local/opt/zen/icons/app.png
Dest:   ~/.local/share/icons/hicolor/128x128/apps/pkgdrop-zen.png
Name:   pkgdrop-{packagename}.{ext}
```

### Name Processing
```
Input:  zen.linux-x86_64
Output: Zen (via humanize_name)
```

## Testing

- [x] Desktop entry created for tar.xz
- [x] Icon extracted and installed
- [x] Name capitalized properly
- [x] StartupWMClass set correctly
- [x] Desktop database refreshed
- [x] Uninstall removes entry + icon
