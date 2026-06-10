# Dockerfile for testing pkgdrop
FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm bash git shellcheck

# Install test dependencies
RUN pacman -S --noconfirm which

WORKDIR /pkgdrop
COPY . .

RUN chmod +x src/pkgdrop

# Run tests
CMD ["bash", "-c", "bash -n src/pkgdrop && shellcheck src/pkgdrop && echo 'All checks passed'"]
