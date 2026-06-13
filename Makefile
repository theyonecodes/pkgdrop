# Makefile for pkgdrop

.PHONY: all install uninstall test test-unit test-integration clean

all: src/pkgdrop

install: src/pkgdrop
	sudo install -Dm755 src/pkgdrop /usr/bin/pkgdrop

uninstall:
	sudo rm -f /usr/bin/pkgdrop /usr/share/applications/pkgdrop.desktop /usr/share/kservices5/ServiceMenus/pkgdrop-servicemenu.xml

test: test-unit test-integration

test-unit:
	@echo "Running unit tests..."
	bats tests/pkgdrop.bats

test-integration:
	@echo "Running integration tests..."
	bats tests/integration.bats

check:
	@echo "Running syntax check..."
	bash -n src/pkgdrop
	@echo "Running shellcheck..."
	shellcheck src/pkgdrop
	@echo "All checks passed."

clean:
	rm -f src/*.bak
