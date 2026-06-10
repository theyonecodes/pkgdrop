# Technical Specification

## Architecture Overview

```
User Input
    ↓
[Type Detection] → Extension/Magic Bytes
    ↓
[Handler Selection] → pacman/deb/tar/AppImage
    ↓
[Installation] → /opt or ~/.local/opt/
    ↓
[Symlink] → ~/.local/bin/
    ↓
[Success/Failure] → User notification
```

## Component Design

### 1. Type Detector (`detect_type()`)
- Extension matching
- Magic byte verification
- Fallback to extension

### 2. Handler Router (`route_handler()`)
- pacman for .pkg.tar.*
- Custom for tar.xz
- debtap for .deb
- Direct for AppImage

### 3. Installer (`install_<type>()`)
- Extract/move files
- Set permissions
- Create symlinks

## Dependencies

- `bash` (≥ 5.0)
- `coreutils` (base)
- `pacman` (for pkg handling)
- `debtap` (optional, for .deb)