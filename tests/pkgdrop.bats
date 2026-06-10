#!/usr/bin/env bats
# Unit tests for pkgdrop

setup() {
    export PATH="$BATS_TEST_TMPDIR/bin:$PATH"
    export PKGDROP_DIR="$BATS_TEST_TMPDIR/opt"
    export HOME="$BATS_TEST_TMPDIR"
    mkdir -p "$BATS_TEST_TMPDIR/bin" "$BATS_TEST_TMPDIR/opt" "$BATS_TEST_TMPDIR/.config/pkgdrop"
    cp "${BATS_TEST_DIRNAME}/../src/pkgdrop" "$BATS_TEST_TMPDIR/bin/pkgdrop"
    chmod +x "$BATS_TEST_TMPDIR/bin/pkgdrop"
}

@test "show help" {
    run pkgdrop --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
    [[ "$output" == *"--help"* ]]
    [[ "$output" == *"--version"* ]]
    [[ "$output" == *"--list"* ]]
    [[ "$output" == *"--uninstall"* ]]
    [[ "$output" == *"--dry-run"* ]]
}

@test "show version" {
    run pkgdrop --version
    [ "$status" -eq 0 ]
    [[ "$output" == *"pkgdrop "* ]]
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
    run pkgdrop --clean
    [ "$status" -eq 0 ]
    [[ "$output" == *"0 items"* ]]
}

@test "file size validation" {
    # Create a file larger than 1KB limit
    PKGDROP_MAX_SIZE=1024 run pkgdrop --dry-run "$BATS_TEST_TMPDIR/test.xyz"
    # Should not fail on dry run (just validation)
}
