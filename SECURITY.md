# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 2.0.x   | :white_check_mark: |
| < 2.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly:

**Do NOT open a public issue.**

Instead, email: **theyonecodes@gmail.com**

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

## Response Timeline

- **Acknowledgment:** Within 48 hours
- **Assessment:** Within 1 week
- **Fix/patch:** Within 2 weeks for critical issues

## Security Features

pkgdrop includes these security measures:

- File locking to prevent concurrent installs
- Quarantine mode for suspicious archives
- Symlink validation after extraction
- setuid/setgid bit stripping
- File size limits
- Archive integrity validation
- Sudo warnings before elevation

## Best Practices

When using pkgdrop:

1. Always review packages before installing
2. Use `--dry-run` to preview changes
3. Keep pkgdrop updated
4. Report suspicious packages immediately
