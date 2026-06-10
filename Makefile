# Makefile for pkgdrop

.PHONY: all install uninstall test clean

all: src/pkgdrop

install: src/pkgdrop
	install -Dm755 src/pkgdrop /usr/bin/pkgdrop

uninstall:
	rm -f /usr/bin/pkgdrop

test:
	@echo "Running syntax check..."
	bash -n src/pkgdrop
	@echo "Running shellcheck..."
	shellcheck src/pkgdrop
	@echo "All checks passed."

clean:
	rm -f src/*.bak
