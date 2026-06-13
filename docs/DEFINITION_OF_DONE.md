# pkgdrop - Definition of Done (DoD)

A task is **Done** when ALL of the following are true:

## Code Quality
- [ ] Code passes `bash -n` syntax check
- [ ] Code passes `shellcheck` with no warnings
- [ ] Code follows existing style (no comments unless complex logic)
- [ ] No hardcoded paths (use variables)
- [ ] Error messages are clear and actionable

## Testing
- [ ] Unit tests pass: `bats tests/pkgdrop.bats`
- [ ] Integration tests pass: `bats tests/integration.bats`
- [ ] Manual test: happy path works end-to-end
- [ ] Manual test: error cases handled gracefully
- [ ] Tested on clean install (no leftover state)

## Desktop Integration
- [ ] .desktop entry follows freedesktop.org spec
- [ ] Icon installed to correct hicolor location
- [ ] App appears in launcher with correct name
- [ ] App launches from launcher
- [ ] Taskbar grouping works (StartupWMClass)

## Documentation
- [ ] User stories updated if new feature
- [ ] CHANGELOG.md updated
- [ ] README.md updated if user-facing change
- [ ] Code comments only if logic is non-obvious

## Git
- [ ] Commit message is clear and descriptive
- [ ] No secrets or keys in commit
- [ ] Branch is up to date with main
- [ ] CI passes on push

## Release Checklist (v2.x.x)
- [ ] All P0 tasks complete
- [ ] Version bumped in src/pkgdrop
- [ ] Version bumped in deploy/PKGBUILD
- [ ] Version bumped in deploy/.SRCINFO
- [ ] CHANGELOG.md entry added
- [ ] Tag created: `git tag v2.x.x`
- [ ] Release workflow triggered
