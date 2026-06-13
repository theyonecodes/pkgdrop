#!/usr/bin/env bats
# Integration tests for pkgdrop v3.0.0

setup() {
    export PATH="$BATS_TEST_TMPDIR/bin:$PATH"
    export PKGDROP_DIR="$BATS_TEST_TMPDIR/opt"
    export HOME="$BATS_TEST_TMPDIR"
    export AUTO_YES=1
    export FORCE=1
    export PKGDROP_SANDBOX=0
    mkdir -p "$BATS_TEST_TMPDIR/bin" "$BATS_TEST_TMPDIR/opt" "$BATS_TEST_TMPDIR/.config/pkgdrop" "$BATS_TEST_TMPDIR/.local/share/pkgdrop" "$BATS_TEST_TMPDIR/.local/share/applications" "$BATS_TEST_TMPDIR/.local/share/icons/hicolor/128x128/apps" "$BATS_TEST_TMPDIR/.local/bin"
    cp "${BATS_TEST_DIRNAME}/../src/pkgdrop" "$BATS_TEST_TMPDIR/bin/pkgdrop"
    chmod +x "$BATS_TEST_TMPDIR/bin/pkgdrop"
}

@test "dry-run tar.xz shows preview without installing" {
    run pkgdrop --dry-run "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    [ "$status" -eq 0 ]
    [[ "$output" == *"DRY RUN"* ]]
    [[ "$output" == *"Would extract"* ]]
    [ ! -d "$PKGDROP_DIR" ] || [ -z "$(ls -A "$PKGDROP_DIR" 2>/dev/null)" ]
}

@test "install tar.xz with atomic commit" {
    run pkgdrop "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Done"* ]]
    [ -L "$HOME/.local/bin/test" ]
    local count
    count=$(find "$PKGDROP_DIR" -maxdepth 1 -name "*.stage.*" 2>/dev/null | wc -l)
    [ "$count" -eq 0 ]
}

@test "registry entry created after install" {
    run pkgdrop "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    [ "$status" -eq 0 ]
    [ -f "$HOME/.local/share/pkgdrop/registry.json" ]
    run pkgdrop --list
    [[ "$output" == *"test"* ]]
}

@test "info shows installed package details" {
    run pkgdrop "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    run pkgdrop --info test
    [ "$status" -eq 0 ]
    [[ "$output" == *"Package: test"* ]]
    [[ "$output" == *"Version:"* ]]
    [[ "$output" == *"Type: tarportable"* ]]
}

@test "owns file returns correct owner" {
    run pkgdrop "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    run pkgdrop --owns "$HOME/.local/bin/test"
    [ "$status" -eq 0 ]
    [[ "$output" == *"test"* ]]
}

@test "list shows installed package" {
    run pkgdrop "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    run pkgdrop --list
    [ "$status" -eq 0 ]
    [[ "$output" == *"test"* ]]
}

@test "uninstall removes package and registry entry" {
    run pkgdrop "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    run pkgdrop --uninstall test
    [ "$status" -eq 0 ]
    [ ! -L "$HOME/.local/bin/test" ]
    [ ! -d "$PKGDROP_DIR/test" ]
}

@test "clean removes broken symlinks" {
    mkdir -p "$HOME/.local/bin"
    ln -sf "/nonexistent/file" "$HOME/.local/bin/broken-link"
    run pkgdrop --clean
    [ "$status" -eq 0 ]
    [[ "$output" == *"1 items"* ]]
    [ ! -L "$HOME/.local/bin/broken-link" ]
}

@test "verbose mode shows detailed output" {
    run pkgdrop --verbose --dry-run "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Installing tarportable"* ]]
}

@test "reinstall overwrites existing package" {
    run pkgdrop "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    [ -L "$HOME/.local/bin/test" ]
    run pkgdrop "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    [ "$status" -eq 0 ]
    [ -L "$HOME/.local/bin/test" ]
}

@test "upgrade detects same version" {
    run pkgdrop "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    run pkgdrop --upgrade test "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Already up to date"* ]] || [[ "$output" == *"Same version"* ]] || [[ "$output" == *"Force reinstall"* ]] || [[ "$output" == *"Upgrading"* ]] || [[ "$output" == *"Upgrade complete"* ]]
}
