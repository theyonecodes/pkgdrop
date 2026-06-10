# Developer Guide

## Project Structure

```
pkgdrop/
├── pkgdrop              # Main script (bash)
├── docs/                # Documentation
├── deploy/              # Packaging
│   ├── PKGBUILD
│   └── pkgdrop.desktop
└── .github/             # CI/CD
```

## Testing

```bash
# Test script syntax
bash -n pkgdrop

# Test with debug mode
DEBUG=1 ./pkgdrop test.tar.xz
```

## Contribution

1. Fork repository
2. Create feature branch
3. Submit PR with description