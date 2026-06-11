# pkgdrop - Active TODO

**Sprint:** v2.1.0 Stability  
**Updated:** 2026-06-11

## Must Fix (P0)

- [x] Verify CI passes on GitHub
- [x] Merge/close Dependabot PRs (#1 stale, #2 release, #3 checkout, #4 ssh-agent)
- [x] End-to-end test: zen.tar.xz installs with desktop entry + icon
- [x] End-to-end test: AppImage installs with desktop entry
- [x] End-to-end test: uninstall removes everything

## Should Fix (P1)

- [x] Capitalize display names (zen → Zen, not just zen)
- [x] Detect app category from .desktop file inside archive
- [x] Handle tar.xz files with nested directories
- [x] Show progress during extraction
- [x] Verbose mode shows each step

## Nice to Have (P2)

- [x] Bash completion for installed packages
- [x] Man page included in AUR package
- [ ] System tray notification
- [ ] Auto-update checker
- [ ] Flatpak/Nix package support
- [ ] GUI installer (yad/zenity)

## Done This Sprint

- [x] Fix CI shellcheck warnings
- [x] Fix sanitize_name dot separators
- [x] Desktop entry auto-creation
- [x] Icon extraction and installation
- [x] Proper .desktop format (Version, StartupWMClass)
- [x] Summary output with install paths
- [x] Uninstall cleans up desktop entries
- [x] Config file support
- [x] Man page
- [x] Bash/zsh completions
- [x] GitHub features (Dependabot, templates, CODEOWNERS)
- [x] Fix argument parsing for --yes flag
- [x] humanize_name() wired into create_desktop_entry()
- [x] Category detection from .desktop files
- [x] Nested archive handling
- [x] Progress indicator for large archives
- [x] Verbose mode with detailed steps

## Blocked

- [ ] AUR sync CI - SSH key works locally, fails in runner

## Next Sprint Ideas

### Features
- [ ] `pkgdrop update` - update all installed packages
- [ ] `pkgdrop info <package>` - show package details
- [ ] `pkgdrop search <query>` - search AUR for packages
- [ ] `pkgdrop --gui` - zenity/yad GUI installer
- [ ] System tray notifications for install/uninstall
- [ ] Auto-update checker (check for new pkgdrop versions)
- [ ] Flatpak/Nix package support
- [ ] `pkgdrop --reinstall` - reinstall/refresh package
- [ ] `pkgdrop --deps` - show/install dependencies

### Improvements
- [ ] Better error messages with suggestions
- [ ] colored output for different message types
- [ ] JSON output mode for scripting
- [ ] `--force` flag to skip confirmations
- [ ] Rollback support (keep backup before install)
- [ ] Log file rotation

### Testing
- [ ] Integration test suite with real packages
- [ ] CI test on actual Arch Linux runner
- [ ] Test with more package formats
- [ ] Performance benchmarks
