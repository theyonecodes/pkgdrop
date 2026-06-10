# Makefile for pkgdrop

.PHONY: all install test clean

all: src/pkgdrop

install: src/pkgdrop
	install -Dm755 src/pkgdrop /usr/local/bin/pkgdrop

test:
	@echo "Running basic syntax check..."
	bash -n src/pkgdrop
	@echo "All checks passed."

clean:
	rm -f src/*.bak

release:
	@echo "Creating release package..."
	git archive --format=tar.gz --output=../pkgdrop-$(shell grep '^pkgver=' deploy/PKGBUILD | cut -d= -f2).tar.gz HEAD