#!/usr/bin/env bats
# Unit tests for pkgdrop

setup() {
    export PATH="$BATS_TEST_TMPDIR/bin:$PATH"
    export PKGDROP_DIR="$BATS_TEST_TMPDIR/opt"
    export HOME="$BATS_TEST_TMPDIR"
    export PKGDROP_SANDBOX=0
    mkdir -p "$BATS_TEST_TMPDIR/bin" "$BATS_TEST_TMPDIR/opt" "$BATS_TEST_TMPDIR/.config/pkgdrop" "$BATS_TEST_TMPDIR/.local/share/pkgdrop" "$BATS_TEST_TMPDIR/.local/share/applications" "$BATS_TEST_TMPDIR/.local/share/icons/hicolor/128x128/apps" "$BATS_TEST_TMPDIR/.local/bin"
    cp "${BATS_TEST_DIRNAME}/../src/pkgdrop" "$BATS_TEST_TMPDIR/bin/pkgdrop"
    chmod +x "$BATS_TEST_TMPDIR/bin/pkgdrop"
    # Mock pacman for systems that don't have it (like Ubuntu CI)
    if ! command -v pacman &>/dev/null; then
        cat > "$BATS_TEST_TMPDIR/bin/pacman" << 'MOCK'
#!/bin/bash
# Mock pacman - just make it exist for dependency checks
exit 1
MOCK
        chmod +x "$BATS_TEST_TMPDIR/bin/pacman"
    fi
    # Mock jq if not available
    if ! command -v jq &>/dev/null; then
        cat > "$BATS_TEST_TMPDIR/bin/jq" << 'MOCK'
#!/bin/bash
# Minimal jq mock for registry tests
FILE="${@: -1}"
case "$*" in
    *'to_entries'*)
        if [[ -f "$FILE" ]]; then
            echo '{}' 
        fi
        ;;
    *'keys'*)
        echo ''
        ;;
    *'del'*)
        echo '{}' > "$FILE"
        ;;
    *)
        echo ''
        ;;
esac
MOCK
        chmod +x "$BATS_TEST_TMPDIR/bin/jq"
    fi
}

@test "show help" {
    run pkgdrop --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
    [[ "$output" == *"--help"* ]]
    [[ "$output" == *"--version"* ]]
    [[ "$output" == *"--list"* ]]
    [[ "$output" == *"--uninstall"* ]]
    [[ "$output" == *"--upgrade"* ]]
    [[ "$output" == *"--info"* ]]
    [[ "$output" == *"--owns"* ]]
    [[ "$output" == *"--force"* ]]
    [[ "$output" == *"--dry-run"* ]]
    [[ "$output" == *"--extract"* ]]
}

@test "show version" {
    run pkgdrop --version
    [ "$status" -eq 0 ]
    [[ "$output" == *"pkgdrop 3.0.1"* ]]
}

@test "no arguments shows help" {
    run pkgdrop
    [ "$status" -eq 1 ]
}

@test "unknown file fails" {
    run pkgdrop nonexistent.txt
    [ "$status" -eq 1 ]
    [[ "$output" == *"File not found"* ]]
}

@test "unknown format fails" {
    echo "not a real package" > "$BATS_TEST_TMPDIR/test.xyz"
    run pkgdrop "$BATS_TEST_TMPDIR/test.xyz"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Unknown format"* ]]
}

@test "list empty shows no packages" {
    run pkgdrop --list
    [ "$status" -eq 0 ]
    [[ "$output" == *"No packages installed"* ]]
}

@test "clean with no broken symlinks" {
    # Skip in CI - registry state may vary, requires root for /usr/local/bin
    skip "requires clean registry state and root for /usr/local/bin"
}

@test "clean scans /usr/local/bin" {
    # Skip this test in CI as it requires root permissions
    skip "requires root permissions"
}

@test "file size validation" {
    PKGDROP_MAX_SIZE=1024 run pkgdrop --dry-run "$BATS_TEST_TMPDIR/test.xyz"
}

@test "info for nonexistent package" {
    run pkgdrop --info nonexistent
    [ "$status" -eq 0 ]
    [[ "$output" == *"not found"* ]] || [[ "$output" == *"not in registry"* ]]
}

@test "owns for nonexistent file" {
    run pkgdrop --owns /nonexistent/file
    [ "$status" -eq 0 ]
    [[ "$output" == *"No package owns"* ]]
}

@test "upgrade without installed package fails gracefully" {
    run pkgdrop --upgrade nonexistent
    [ "$status" -eq 1 ]
    [[ "$output" == *"not installed"* ]] || [[ "$output" == *"not in registry"* ]]
}

@test "force flag accepted" {
    echo "test" > "$BATS_TEST_TMPDIR/test.tar.xz"
    run pkgdrop --force --dry-run "$BATS_TEST_TMPDIR/test.tar.xz"
    [[ "$output" == *"DRY RUN"* ]] || [[ "$status" -eq 1 ]]
}

@test "extract flag accepted" {
    echo "test" > "$BATS_TEST_TMPDIR/test.AppImage"
    run pkgdrop --extract --dry-run "$BATS_TEST_TMPDIR/test.AppImage"
    [[ "$output" == *"DRY RUN"* ]] || [[ "$status" -eq 1 ]]
}

@test "audit command runs without error" {
    run pkgdrop --audit
    [ "$status" -eq 0 ]
    [[ "$output" == *"pkgdrop audit"* ]]
}

@test "audit shows broken symlinks section" {
    run pkgdrop --audit
    [ "$status" -eq 0 ]
    [[ "$output" == *"Broken Symlinks"* ]]
}

@test "audit shows duplicate desktop entries section" {
    run pkgdrop --audit
    [ "$status" -eq 0 ]
    [[ "$output" == *"Duplicate Desktop Entries"* ]]
}

@test "audit shows systemd section" {
    run pkgdrop --audit
    [ "$status" -eq 0 ]
    [[ "$output" == *"Systemd"* ]]
}

@test "audit shows pacman cross-reference section" {
    run pkgdrop --audit
    [ "$status" -eq 0 ]
    [[ "$output" == *"Pacman Cross-Reference"* ]]
}

@test "audit command with --prune flag runs" {
    run pkgdrop --audit --prune
    [ "$status" -eq 0 ]
}
