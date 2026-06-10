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

## Testing

```bash
# Syntax check
bash -n src/pkgdrop

# Debug mode
DEBUG=1 ./pkgdrop test-file.tar.xz
```

## Pull Request Requirements

- [ ] Passes syntax checks
- [ ] Includes documentation updates
- [ ] Follows existing code style
- [ ] Has meaningful commit messages

## Reporting Issues

Use GitHub Issues with templates:
- Bug Report
- Feature Request
- Documentation Issue