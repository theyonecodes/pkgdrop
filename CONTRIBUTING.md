# Contributing to pkgdrop

Thank you for your interest in contributing!

## Development Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Code Standards

- **Shellcheck** compliance for bash scripts
- **Bash 5.0+** syntax only
- Clear function and variable naming
- Comment complex logic
- Use `return 0` at end of functions that use `[[ ]]` as last command (prevents `set -e` failures)

## Testing

```bash
# Install bats (if not installed)
git clone --depth 1 https://github.com/bats-core/bats-core.git /tmp/bats
/tmp/bats/install.sh ~/.local

# Syntax check
bash -n src/pkgdrop

# Unit tests
bats tests/pkgdrop.bats

# Integration tests
bats tests/integration.bats

# Debug mode
DEBUG=1 ./pkgdrop test-file.tar.xz
```

## Pull Request Requirements

- [ ] Passes syntax checks (`bash -n`, `shellcheck`)
- [ ] All tests pass (`bats tests/`)
- [ ] Includes documentation updates
- [ ] Follows existing code style
- [ ] Has meaningful commit messages

## Project Structure

- `src/pkgdrop` — Main script (all logic)
- `tests/` — Bats test suite
- `deploy/` — AUR packaging (PKGBUILD, .SRCINFO)
- `docs/` — Documentation and PM tool
- `completions/` — Bash/zsh completions

## Reporting Issues

Use GitHub Issues with templates:
- Bug Report
- Feature Request
- Documentation Issue
