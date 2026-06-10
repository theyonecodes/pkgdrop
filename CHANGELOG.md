# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2025-01-09

### Added
- Initial release
- Basic script structure
- File type detection by extension
- Support for .pkg.tar.*, .tar.xz, .deb, .AppImage
- CLI usage: `pkgdrop <file>`
- User installations to ~/.local/opt/
- Symlink creation in ~/.local/bin/
- Documentation suite (HTML + Markdown)
- GitHub Actions CI/Release workflows

### Tested
- ✅ tar.xz portable packages (zen.linux-x86_64.tar.xz)
- ✅ pacman packages (.pkg.tar.zst) - tested, dependency errors expected
- ✅ AppImage packages (.AppImage) - working