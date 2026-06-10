# Product Backlog

## Must Have (MVP)

### Epic: Core Installation
- [ ] US-001: As a user, I want to install pacman packages (.pkg.tar.*) so that I can deploy AUR/system packages
- [ ] US-002: As a user, I want to install tar.xz portable packages so that I can run extracted binaries
- [ ] US-003: As a user, I want to install .deb packages so that I can use Debian-based software
- [ ] US-004: As a user, I want to install AppImage files so that I can run portable Linux applications

### Epic: Type Detection
- [ ] US-005: As a system, I want to detect file type by extension so that I can route to correct handler
- [ ] US-006: As a system, I want to verify file type by magic bytes so that I can prevent errors

### Epic: Installation Path
- [ ] US-007: As a user, I want installations in ~/.local/opt/ so that I don't need root privileges
- [ ] US-008: As a user, I want symlinks created in ~/.local/bin/ so that I can run installed apps

## Should Have (v1.1)

### Epic: Konsole Integration
- [ ] US-009: As a user, I want to drag files onto Konsole to install so that I don't need to type paths
- [ ] US-010: As a user, I want a Quick Command in Konsole so that installation is one click

### Epic: Desktop Integration
- [ ] US-011: As a user, I want to drop files on a desktop icon so that I can install graphically
- [ ] US-012: As a file manager user, I want right-click context menu so that I can install easily

## Could Have (v1.2)

### Epic: Advanced Features
- [ ] US-013: As a user, I want batch installation so that I can install multiple files at once
- [ ] US-014: As a user, I want to see installation progress so that I know the process is working
- [ ] US-015: As a user, I want automatic dependency resolution so that required packages are installed

## Won't Have (Out of Scope)

- [ ] GUI application window
- [ ] System-wide installation (requires root)
- [ ] Network package downloads (curl/wget integration)
- [ ] Flatpak/Snap package support