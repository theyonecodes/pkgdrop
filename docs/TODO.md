# pkgdrop - Active TODO

**Sprint:** v2.1.0 Stability  
**Updated:** 2026-06-11

## Must Fix (P0)

- [ ] Verify CI passes on GitHub
- [ ] Merge/close Dependabot PRs (#1 stale, #2 release, #3 checkout, #4 ssh-agent)
- [ ] End-to-end test: zen.tar.xz installs with desktop entry + icon
- [ ] End-to-end test: AppImage installs with desktop entry
- [ ] End-to-end test: uninstall removes everything

## Should Fix (P1)

- [ ] Capitalize display names (zen → Zen Browser, not just Zen)
- [ ] Detect app category from .desktop file inside archive
- [ ] Handle tar.xz files with nested directories
- [ ] Show progress during extraction
- [ ] Verbose mode shows each step

## Nice to Have (P2)

- [ ] Bash completion for installed packages
- [ ] Man page included in AUR package
- [ ] System tray notification
- [ ] Auto-update checker

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

## Blocked

- [ ] AUR sync CI - SSH key works locally, fails in runner
