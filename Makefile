# Makefile for pkgdrop

.PHONY: all install uninstall test clean

all: src/pkgdrop

install: src/pkgdrop
	sudo install -Dm755 src/pkgdrop /usr/bin/pkgdrop

uninstall:
	sudo rm -f /usr/bin/pkgdrop /usr/share/applications/pkgdrop.desktop /usr/share/kservices5/ServiceMenus/pkgdrop-servicemenu.xml

test:
	@echo "Running syntax check..."
	bash -n src/pkgdrop
	@echo "Running shellcheck..."
	shellcheck src/pkgdrop
	@echo "All checks passed."

clean:
	rm -f src/*.bak
