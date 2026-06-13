# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 3.0.x   | :white_check_mark: |
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

- **Atomic installs** — Staging directory + commit prevents partial/corrupt installations
- **Package registry** — JSON database tracks file ownership, prevents conflicts
- **Signature verification** — GPG signature validation (`.sig`, `.asc` files)
- **Checksum verification** — SHA-256, SHA-512, MD5 integrity checks
- **Sandbox extraction** — bubblewrap/firejail isolation for untrusted archives
- **File locking** — Prevents concurrent installs
- **Quarantine mode** — Suspicious archives isolated for review
- **Symlink validation** — Catches path traversal attacks
- **setuid/setgid stripping** — Removes privilege escalation bits
- **File size limits** — Prevents disk fill attacks
- **Archive validation** — Checks integrity before extraction
- **Sudo warnings** — Explicit confirmation before elevation
- **Hook system** — Custom security policies via pre/post install hooks

## Best Practices

When using pkgdrop:

1. Always review packages before installing
2. Use `--dry-run` to preview changes
3. Enable sandbox extraction (default)
4. Install jq for full registry and version tracking
5. Keep pkgdrop updated
6. Report suspicious packages immediately
