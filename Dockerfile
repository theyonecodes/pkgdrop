# Dockerfile for testing pkgdrop
FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm bash git shellcheck jq which

# Install bats
RUN git clone --depth 1 https://github.com/bats-core/bats-core.git /tmp/bats && \
    /tmp/bats/install.sh /usr/local && \
    rm -rf /tmp/bats

WORKDIR /pkgdrop
COPY . .

RUN chmod +x src/pkgdrop

# Run all checks
CMD ["bash", "-c", "bash -n src/pkgdrop && shellcheck src/pkgdrop && bats tests/pkgdrop.bats && bats tests/integration.bats && echo 'All checks passed'"]
