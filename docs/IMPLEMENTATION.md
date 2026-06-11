# pkgdrop - Implementation Log

**Format:** YYYY-MM-DD | What | Files Changed | Notes

## 2026-06-11

### v2.2.0 Features

| Change | Files | Impact |
|--------|-------|--------|
| Category detection | src/pkgdrop (detect_category_from_archive) | Apps appear in correct category |
| Nested archive handling | src/pkgdrop (install_tarportable) | Flattens tar.xz inside tar.xz |
| Progress indicator | src/pkgdrop (humanize_size, install_tarportable) | Shows file count for >10MB |
| Verbose mode | src/pkgdrop (verb calls) | Detailed step-by-step output |
| Polkit elevation | install.sh, uninstall.sh | GUI password dialog |
| Fix argument parsing | src/pkgdrop (main) | --yes works with --uninstall |
| Category fallback | src/pkgdrop (detect_category_from_archive) | Browsers detected from MimeType |

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
src/pkgdrop          - Main script (v2.0.0 → v2.2.0)
install.sh           - Polkit elevation, no sudo required
uninstall.sh         - Polkit elevation, no sudo required
push-aur.sh          - Auto-clone AUR if missing
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
.gitignore            - Comprehensive ignores
```

### Key Decisions
1. **Desktop integration is mandatory** - every install creates .desktop entry
2. **Icons must be installed** - extracted from archive, placed in hicolor theme
3. **Names must be clean** - strip platform suffixes, capitalize for display
4. **Summary must show paths** - user needs to know where things went
5. **Uninstall must be clean** - remove everything including desktop entries
6. **Use polkit for elevation** - GUI password dialog, no terminal sudo required
7. **Category detection from .desktop** - apps appear in correct launcher category
8. **Nested archives auto-flatten** - handle tar.xz inside tar.xz

### Lessons Learned
1. `sanitize_name` needs to handle all separators (., -, _)
2. .desktop files need `Version=1.0`, `StartupWMClass`, proper `Icon=` (name only)
3. Icons go in `hicolor/128x128/apps/` with theme name, not full path
4. CI needs `chmod +x` step for scripts
5. `actions/checkout@v6` required for Node.js 24 compatibility
6. Argument parsing must handle flags before commands (--yes before --uninstall)
7. Category fallback should check MimeType for browsers
