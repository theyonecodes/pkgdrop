#!/bin/bash
# pkgdrop GUI Launcher
# Usage: ./run-gui.sh [options]
#
# Options:
#   --electron    Launch Electron GUI (default if available)
#   --gtk         Launch GTK Python GUI
#   --tkinter     Launch tkinter Python GUI
#   --cli         Show CLI usage

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

launch_electron() {
    if command -v electron &>/dev/null; then
        echo "Starting pkgdrop Electron GUI..."
        electron .
    elif [[ -d "node_modules/.bin" ]]; then
        echo "Starting pkgdrop Electron GUI (local)..."
        ./node_modules/.bin/electron .
    else
        echo "Electron not found. Install with: npm install"
        exit 1
    fi
}

launch_gtk() {
    if command -v python3 &>/dev/null; then
        echo "Starting pkgdrop GTK GUI..."
        python3 gtk_gui.py
    else
        echo "Python3 not found."
        exit 1
    fi
}

launch_tkinter() {
    if command -v python3 &>/dev/null; then
        echo "Starting pkgdrop tkinter GUI..."
        python3 drag_drop_uninstall.py
    else
        echo "Python3 not found."
        exit 1
    fi
}

show_help() {
    echo "pkgdrop GUI Launcher"
    echo ""
    echo "Usage: ./run-gui.sh [option]"
    echo ""
    echo "Options:"
    echo "  --electron   Launch Electron GUI (default)"
    echo "  --gtk        Launch GTK Python GUI"
    echo "  --tkinter    Launch tkinter Python GUI"
    echo "  --cli        Show CLI help"
    echo "  --help       Show this help message"
    echo ""
    echo "Also available:"
    echo "  pkgdrop -l    List packages (CLI)"
    echo "  pkgdrop -i    Package info (CLI)"
    echo "  pkgdrop -a    Audit system (CLI)"
}

case "${1:-}" in
    --electron|"")
        launch_electron
        ;;
    --gtk)
        launch_gtk
        ;;
    --tkinter)
        launch_tkinter
        ;;
    --cli)
        src/pkgdrop --help
        ;;
    --help|-h)
        show_help
        ;;
    *)
        echo "Unknown option: $1"
        show_help
        exit 1
        ;;
esac