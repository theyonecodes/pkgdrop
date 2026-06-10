# pkgdrop - Implementation Log

**Format:** YYYY-MM-DD | What | Files Changed | Notes

## 2026-06-11

### v2.0.0 Release

| Change | Files | Impact |
|--------|-------|--------|
| Complete 76-item audit | src/pkgdrop, install.sh, all workflows | Security, stability, features |
| Desktop integration | src/pkgdrop (find_icon, create_desktop_entry) | Apps appear in launcher |
| .desktop auto-creation | src/pkgdrop, pkgdrop.desktop | Proper format with StartupWMClass |
| Icon extraction | src/pkgdrop (find_icon, hicolor install) | Icons from archives |
| Name sanitization fix | src/pkgdrop (sed handles dots) | zen not zen.linux-x86_64 |
| Summary output | src/pkgdrop (show_summary) | Shows install paths |
| GitHub features | .github/ (dependabot, templates, CODEOWNERS) | Full GitHub integration |
| CI fixes | .github/workflows/ci.yml | Actions v6, bats from git |
| Documentation | docs/ (ROADMAP, ARCHITECTURE, TODO) | Technical docs |

### Files Modified
```
src/pkgdrop          - Main script (v2.0.0 → v2.1.0)
install.sh           - Fixed eval, added sudo warning
push-aur.sh          - Now updates PKGBUILD/SRCINFO
deploy/PKGBUILD      - v2.0.0, .install hook, completions
deploy/.SRCINFO      - v2.0.0
deploy/pkgdrop.desktop - Added StartupNotify
CHANGELOG.md         - Full history
README.md            - Badges, CLI reference, project structure
.github/workflows/ci.yml - Actions v6, bats tests
.github/workflows/release.yml - Actions v6, checksums
.github/workflows/sync-aur.yml - Actions v6, ssh-agent v0.10.0
.github/dependabot.yml - Auto-update GitHub Actions
.github/ISSUE_TEMPLATE/ - Bug report, feature request
.github/CODEOWNERS    - Review assignments
.github/FUNDING.yml   - Sponsorship
.github/pull_request_template.md - PR checklist
SECURITY.md           - Vulnerability reporting
Dockerfile            - Testing environment
docs/pkgdrop.1        - Man page
completions/          - Bash + zsh completions
tests/                - Unit + integration tests (bats)
docs/TECH_ROADMAP.md  - Technical roadmap
docs/ARCHITECTURE.md  - System architecture
docs/TODO.md          - Active tasks
docs/IMPLEMENTATION.md - This file
```

### Key Decisions
1. **Desktop integration is mandatory** - every install creates .desktop entry
2. **Icons must be installed** - extracted from archive, placed in hicolor theme
3. **Names must be clean** - strip platform suffixes, capitalize for display
4. **Summary must show paths** - user needs to know where things went
5. **Uninstall must be clean** - remove everything including desktop entries

### Lessons Learned
1. `sanitize_name` needs to handle all separators (., -, _)
2. .desktop files need `Version=1.0`, `StartupWMClass`, proper `Icon=` (name only)
3. Icons go in `hicolor/128x128/apps/` with theme name, not full path
4. CI needs `chmod +x` step for scripts
5. `actions/checkout@v6` required for Node.js 24 compatibility
