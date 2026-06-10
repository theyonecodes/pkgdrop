#!/usr/bin/env bats
# Integration tests for pkgdrop

setup() {
    export PATH="$BATS_TEST_TMPDIR/bin:$PATH"
    export PKGDROP_DIR="$BATS_TEST_TMPDIR/opt"
    export HOME="$BATS_TEST_TMPDIR"
    export AUTO_YES=1
    mkdir -p "$BATS_TEST_TMPDIR/bin" "$BATS_TEST_TMPDIR/opt" "$BATS_TEST_TMPDIR/.config/pkgdrop"
    cp "${BATS_TEST_DIRNAME}/../src/pkgdrop" "$BATS_TEST_TMPDIR/bin/pkgdrop"
    chmod +x "$BATS_TEST_TMPDIR/bin/pkgdrop"
}

@test "dry-run tar.xz shows preview without installing" {
    run pkgdrop --dry-run "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    [ "$status" -eq 0 ]
    [[ "$output" == *"DRY RUN"* ]]
    [[ "$output" == *"Would extract"* ]]
    # Verify nothing was installed
    [ ! -d "$PKGDROP_DIR" ] || [ -z "$(ls -A "$PKGDROP_DIR" 2>/dev/null)" ]
}

@test "install tar.xz with binary" {
    run pkgdrop "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Done"* ]]
    [ -L "$HOME/.local/bin/test-app" ]
}

@test "list shows installed package" {
    run pkgdrop "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    run pkgdrop --list
    [ "$status" -eq 0 ]
    [[ "$output" == *"test-app"* ]]
}

@test "uninstall removes package" {
    run pkgdrop "${BATS_TEST_DIRNAME}/fixtures/test.tar.xz"
    run pkgdrop --uninstall test-app
    [ "$status" -eq 0 ]
    [ ! -L "$HOME/.local/bin/test-app" ]
    [ ! -d "$PKGDROP_DIR/test-app" ]
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
