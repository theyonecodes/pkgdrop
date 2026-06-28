#!/bin/bash
# pkgdrop AppImage Builder
# Creates a self-contained AppImage with pkgdrop CLI and Electron GUI

set -e

VERSION="${1:-3.0.0}"
APPIMAGE_NAME="pkgdrop-${VERSION}.AppImage"
BUILD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$BUILD_DIR/.." && pwd)"
OUTPUT_DIR="$BUILD_DIR/output"
APPDIR="$BUILD_DIR/pkgdrop.AppDir"

echo "============================================"
echo "  pkgdrop AppImage Builder v${VERSION}"
echo "============================================"

# Clean previous builds
rm -rf "$APPDIR" "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR" "$APPDIR"

# Copy pkgdrop CLI
mkdir -p "$APPDIR/usr/bin"
cp "$PROJECT_DIR/src/pkgdrop" "$APPDIR/usr/bin/pkgdrop"
chmod +x "$APPDIR/usr/bin/pkgdrop"

# Copy GUI files
mkdir -p "$APPDIR/usr/share/pkgdrop/gui"
cp -r "$PROJECT_DIR/gui/"* "$APPDIR/usr/share/pkgdrop/gui/"

# Create AppRun (the main entry point)
cat > "$APPDIR/AppRun" << 'APPREXIT'
#!/bin/bash
# pkgdrop AppImage Launcher

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="$APP_DIR/usr/bin:$PATH"

# If no arguments, show help or launch GUI
if [[ $# -eq 0 ]]; then
    if command -v electron &>/dev/null; then
        cd "$APP_DIR/usr/share/pkgdrop/gui"
        electron .
    else
        exec pkgdrop --help
    fi
    exit $?
fi

# Parse arguments
case "$1" in
    --install)
        # Self-install pkgdrop to system
        echo "Installing pkgdrop to system..."
        if [[ $EUID -eq 0 ]]; then
            cp "$APP_DIR/usr/bin/pkgdrop" /usr/local/bin/pkgdrop
            echo "Installed to /usr/local/bin/pkgdrop"
        else
            mkdir -p ~/.local/bin
            cp "$APP_DIR/usr/bin/pkgdrop" ~/.local/bin/pkgdrop
            echo "Installed to ~/.local/bin/pkgdrop"
            echo "Add ~/.local/bin to your PATH if needed"
        fi
        exit 0
        ;;
    --gui)
        # Launch Electron GUI
        if command -v electron &>/dev/null; then
            cd "$APP_DIR/usr/share/pkgdrop/gui"
            electron .
        else
            echo "Error: Electron not found in AppImage"
            echo "Use --cli for command-line mode"
            exit 1
        fi
        exit 0
        ;;
    --cli)
        shift
        exec pkgdrop "$@"
        ;;
    --version|-v)
        exec pkgdrop --version
        ;;
    --help|-h)
        exec pkgdrop --help
        ;;
    *)
        # Check if it's a file (install mode) or pkgdrop command
        if [[ -f "$1" ]]; then
            exec pkgdrop "$@"
        else
            exec pkgdrop "$@"
        fi
        ;;
esac
APPREXIT
chmod +x "$APPDIR/AppRun"

# Create AppImage.desktop
cat > "$APPDIR/pkgdrop.desktop" << 'DESKTOP'
[Desktop Entry]
Name=pkgdrop
Comment=Universal Package Installer
Exec=AppRun --gui
Icon=pkgdrop
Terminal=false
Type=Application
Categories=System;PackageManager;
Keywords=install;package;appimage;tarball;deb;rpm;
DESKTOP

# Create icon placeholder (will be replaced if icon exists)
mkdir -p "$APPDIR/usr/share/icons/hicolor/256x256/apps"
if [[ -f "$PROJECT_DIR/deploy/pkgdrop.svg" ]]; then
    cp "$PROJECT_DIR/deploy/pkgdrop.svg" "$APPDIR/usr/share/icons/hicolor/256x256/apps/pkgdrop.svg"
else
    # Create a simple placeholder icon
    cat > "$APPDIR/pkgdrop.svg" << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">
  <rect width="64" height="64" rx="8" fill="#6366f1"/>
  <text x="32" y="42" font-size="32" fill="white" text-anchor="middle" font-family="sans-serif" font-weight="bold">P</text>
</svg>
SVGEOF
    cp "$APPDIR/pkgdrop.svg" "$APPDIR/usr/share/icons/hicolor/256x256/apps/pkgdrop.svg"
fi

# Copy SVG for scalable icon
mkdir -p "$APPDIR/usr/share/icons/hicolor/scalable/apps"
cp "$APPDIR/pkgdrop.svg" "$APPDIR/usr/share/icons/hicolor/scalable/apps/pkgdrop.svg"

# Create AppImage meta files
cat > "$APPDIR/.appimageversion" << 'EOF'
PKGDROP_VERSION=3.0.0
EOF

cat > "$APPDIR/apprun-hooks/pkgdrop.sh" << 'HOOK'
# Hook to ensure pkgdrop is in PATH when AppImage runs
export PATH="$APPDIR/usr/bin:$PATH"
HOOK

# Check for appimagetool
if command -v appimagetool &>/dev/null; then
    echo "Building AppImage with appimagetool..."
    cd "$BUILD_DIR"
    appimagetool "$APPDIR" "$OUTPUT_DIR/$APPIMAGE_NAME"
else
    echo "============================================"
    echo "  appimagetool not found"
    echo "============================================"
    echo ""
    echo "Install appimagetool with:"
    echo "  wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
    echo "  chmod +x appimagetool-x86_64.AppImage"
    echo "  sudo mv appimagetool-x86_64.AppImage /usr/local/bin/appimagetool"
    echo ""
    echo "Or use Docker:"
    echo "  docker build -t pkgdrop-appimage ."
    echo "  docker run --rm -v \$PWD/output:/output pkgdrop-appimage"
    echo ""
    echo "AppDir created at: $APPDIR"
    echo "To build manually after installing appimagetool:"
    echo "  appimagetool '$APPDIR' '$OUTPUT_DIR/$APPIMAGE_NAME'"
    echo ""

    # Create a shell script that can be used as a portable binary
    cat > "$OUTPUT_DIR/pkgdrop-portable.sh" << 'SCRIPT'
#!/bin/bash
# pkgdrop Portable Launcher
# Place this script alongside pkgdrop.AppDir directory

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKGDROP_DIR="$SCRIPT_DIR/pkgdrop.AppDir"

if [[ ! -d "$PKGDROP_DIR" ]]; then
    echo "Error: pkgdrop.AppDir not found in same directory"
    exit 1
fi

export PATH="$PKGDROP_DIR/usr/bin:$PATH"

case "${1:-}" in
    --install)
        cp "$PKGDROP_DIR/usr/bin/pkgdrop" ~/.local/bin/pkgdrop 2>/dev/null || sudo cp "$PKGDROP_DIR/usr/bin/pkgdrop" /usr/local/bin/pkgdrop
        ;;
    --gui)
        electron "$PKGDROP_DIR/usr/share/pkgdrop/gui" ;;
    *)
        exec pkgdrop "$@" ;;
esac
SCRIPT
    chmod +x "$OUTPUT_DIR/pkgdrop-portable.sh"

    echo "Created portable launcher: $OUTPUT_DIR/pkgdrop-portable.sh"
fi

echo ""
echo "============================================"
echo "  Build complete!"
echo "============================================"
ls -la "$OUTPUT_DIR/"