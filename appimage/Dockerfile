FROM archlinux:latest

RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm \
    base-devel \
    wget \
    git \
    npm \
    nodejs \
    python3 \
    python-pip

RUN wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && \
    chmod +x appimagetool-x86_64.AppImage && \
    mv appimagetool-x86_64.AppImage /usr/local/bin/appimagetool

WORKDIR /pkgdrop
COPY . /pkgdrop

RUN chmod +x appimage/build.sh && \
    ./appimage/build.sh

FROM scratch
COPY --from=0 /pkgdrop/appimage/output/*.AppImage /
COPY --from=0 /pkgdrop/appimage/output/*.sh /

CMD ["/pkgdrop-3.0.0.AppImage", "--help"]