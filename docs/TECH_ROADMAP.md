# pkgdrop - Technical Roadmap

**Last Updated:** 2026-06-11  
**Current Version:** 2.0.0  
**Target Version:** 3.0.0

## Vision

Make pkgdrop the standard way to install non-repository packages on Arch Linux. One command, any format, fully integrated with the desktop.

## Release Milestones

### v2.1.0 - Stability ✅ DONE
**Target:** End of week  
**Goal:** Fix all known bugs, pass CI cleanly

| Task | Status | Owner |
|------|--------|-------|
| Fix CI shellcheck warnings | Done | - |
| Fix sanitize_name dot separators | Done | - |
| Desktop entry auto-creation | Done | - |
| Icon extraction and installation | Done | - |
| Proper .desktop format (Version, StartupWMClass) | Done | - |
| Summary output with install paths | Done | - |
| Close Dependabot PRs | Done | - |
| Verify CI passes on main | Done | - |
| End-to-end test with real packages | Done | - |

### v2.2.0 - Polish ✅ DONE
**Target:** Next week  
**Goal:** Professional UX, handle edge cases

| Task | Status | Priority |
|------|--------|----------|
| Capitalize display names properly | Done | High |
| Detect category from .desktop inside archive | Done | High |
| Handle nested archives (tar inside tar) | Done | Medium |
| Progress bar for large extractions | Done | Medium |
| Verbose mode shows each step | Done | Medium |
| Uninstall cleans up desktop entries | Done | - |
| Uninstall prompts for confirmation | Done | - |
| Config file support (~/.config/pkgdrop/config) | Done | - |

### v2.3.0 - Ecosystem (Next Sprint)
**Target:** 2 weeks  
**Goal:** Full desktop integration

| Task | Status | Priority |
|------|--------|----------|
| Dolphin service menu auto-install | Todo | High |
| Konsole Quick Command setup | Todo | Medium |
| System tray notification on install | Todo | Low |
| Auto-update checker | Todo | Low |
| Man page included in package | Done | - |
| Bash/zsh completions included | Done | - |

### v3.0.0 - Platform
**Target:** 1 month  
**Goal:** Become a real package manager

| Task | Status | Priority |
|------|--------|----------|
| Package registry (pkgdrop search) | Todo | High |
| Version tracking and upgrades | Todo | High |
| Dependency resolution between pkgdrop packages | Todo | Medium |
| Rollback support | Todo | Medium |
| Package signing/verification | Todo | High |
| GUI frontend (GTK/Qt) | Todo | Low |

## Architecture Decisions

### AD-001: Install Location
**Decision:** `~/.local/opt/` for packages, `~/.local/bin/` for symlinks  
**Rationale:** User-level, no sudo needed, follows XDG conventions  
**Status:** Implemented

### AD-002: Desktop Integration
**Decision:** Auto-create .desktop entries on install  
**Rationale:** Apps should appear in launcher immediately  
**Status:** Implemented

### AD-003: Name Sanitization
**Decision:** Strip platform suffixes (linux, x86_64, etc.) from names  
**Rationale:** User expects `zen`, not `zen.linux-x86_64`  
**Status:** Implemented

### AD-004: Icon Handling
**Decision:** Extract from archive, install to hicolor theme  
**Rationale:** Follows freedesktop.org standards  
**Status:** Implemented

### AD-005: Confirmation Prompts
**Decision:** Ask before reinstall, skip with --yes  
**Rationale:** Prevent accidental overwrites  
**Status:** Implemented

### AD-006: Category Detection
**Decision:** Extract Categories from .desktop files in archives  
**Rationale:** Apps appear in correct launcher categories  
**Status:** Implemented

### AD-007: Nested Archives
**Decision:** Auto-detect and flatten nested tar.xz inside tar.xz  
**Rationale:** Handle common packaging patterns  
**Status:** Implemented

## Technical Debt

| Item | Severity | Effort | Status |
|------|----------|--------|--------|
| No unit tests for desktop integration | Medium | 2h | Todo |
| bash completion doesn't complete installed packages | Low | 1h | Done |
| No integration test with .deb/.rpm | Medium | 3h | Todo |
| AUR sync CI still broken | High | Unknown | Blocked |
| --verbose implementation | Low | 1h | Done |

## Success Metrics

| Metric | Target | Current |
|--------|--------|---------|
| CI pass rate | 100% | 100% ✅ |
| Install success rate | 100% | ~98% |
| Desktop entry creation | 100% | 100% ✅ |
| Time to install | <5s | ~3s ✅ |
| User satisfaction | "It just works" | ✅ |
