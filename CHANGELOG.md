# Changelog

## 2.0.0 (2026-06-11)

### Security
- File locking to prevent concurrent installs
- Quarantine mode for suspicious archives
- AppImage ELF magic byte validation
- Tar archive integrity validation before extraction

### New Features
- `--dry-run` / `-n` to preview changes
- `--verbose` / `-V` for detailed output
- `.rpm` support via alien conversion
- Disk size estimate before install
- Config file support (~/.config/pkgdrop/config)
- Installation logging to file
- Bash and zsh completions

### Documentation
- Man page (pkgdrop.1)
- CLI reference in README

### Testing
- Unit tests with bats framework
- Integration tests with test fixtures
- CI runs bats tests

### Packaging
- .install hook for AUR post-install messages
- StartupNotify in desktop file
- CHANGELOG included in AUR package
- Release checksums (SHA256)

### Deployment
- Dockerfile for isolated testing

## 1.3.0 (2026-06-11)

### Security
- Add trap for cleanup on interrupt (Ctrl+C)
- Add symlink validation after extraction
- Add sudo warning before elevation
- Add file size limit (configurable via PKGDROP_MAX_SIZE)
- Strip setuid/setgid bits from extracted files

### Bug Fixes
- Fix `sanitize_name()` greedy patterns (was mangling names)
- Add error handling for cp/chmod/ln in AppImage handler
- Add error message on mkdir failure
- Fix debtap output parsing with fallback error display

### New Features
- `--uninstall` / `-u` flag to remove packages
- `--clean` / `-c` flag to remove broken symlinks
- `--yes` / `-y` flag to skip confirmation prompts
- Color output for terminal (auto-detects TTY)
- Confirmation before fresh install
- Configurable install directory (PKGDROP_DIR)
- Configurable max file size (PKGDROP_MAX_SIZE)

## 1.2.0 (2026-06-11)

### Security
- Add `sanitize_name()` to strip malicious path components
- Replace `eval` in install.sh with `getent passwd`
- Add tar extraction error handling with cleanup
- Add `--` to pacman commands to prevent flag injection

### Bug Fixes
- Fix `log()` crash with `set -e`
- Fix `.SRCINFO` version mismatch (was 1.0.0)
- Fix `.gitignore` ignoring `src/` directory
- Fix `debtap` to auto-install converted package
- Fix `--list` to only show pkgdrop-installed packages
- Fix PATH message to only show when `~/.local/bin` not in PATH

### Improvements
- Desktop MimeType includes .deb format
- Makefile uses `sudo` for install/uninstall
- CI tests all scripts (install.sh, uninstall.sh, push-aur.sh)
- `push-aur.sh` updates PKGBUILD/.SRCINFO automatically

## 1.1.0 (2026-06-10)

### Added
- Automatic dependency checking and optional helper installation
- `--help`, `--version`, `--list` flags
- Reinstall prompt for existing packages
- Binary detection filters (.so*, .dylib, *-bin, updater, *test, *sender)
- GitHub Actions CI/Release/AUR-sync workflows

### Fixed
- AUR SSH user is `aur@` (not `git@`)
- install.sh `$SUDO_USER` handling for /root mkdir bug
- Removed 12 stale/contradictory documentation files

## 1.0.0 (2026-06-08)

### Added
- Initial release
- Type detection for .tar.xz, .deb, .AppImage, .pkg.tar.*
- Tarportable handler with symlink creation
- AUR package at aur.archlinux.org/packages/pkgdrop/
