# Product Documentation

## Product Overview

**Name:** pkgdrop  
**Tagline:** Universal package installer for Arch Linux  
**Version:** 1.0.0 (MVP)

## Product Description

pkgdrop is a command-line tool that simplifies software installation on Arch Linux by supporting multiple package formats through a single interface. Users can install packages by simply passing the file path, with automatic detection and routing to the appropriate handler.

## Key Features

1. **Universal Installation** - Supports pacman, tar.xz, .deb, and AppImage formats
2. **Multiple Access Points** - Works from CLI, Konsole, desktop files, and file managers
3. **User-Level Installs** - Installs to ~/.local/opt/ by default (no root required)
4. **Auto-Detection** - Automatically identifies package type via extension/magic bytes

## User Personas

1. **System Administrator** - Needs to deploy software quickly across systems
2. **Developer** - Wants portable applications without complex installation
3. **End User** - Seeks simple software installation without terminal knowledge

## Use Cases

| Use Case | Actor | Steps |
|----------|-------|-------|
| Install pacman package | User | 1. Drag .pkg.tar.zst to Konsole<br>2. pkgdrop auto-detects and installs |
| Install portable app | User | 1. Run: pkgdrop app.tar.xz<br>2. Extracted to ~/.local/opt/app |
| Install .deb | User | 1. Run: pkgdrop app.deb<br>2. debtap converts and installs |
| Install AppImage | User | 1. Run: pkgdrop app.AppImage<br>2. Moved to ~/.local/bin/ |

## Product Vision

Become the standard universal installer for Arch-based distributions, providing a unified interface for all package formats.