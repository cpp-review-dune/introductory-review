# Copyleft (c) April, 2021, Oromion.

FROM archlinux:base-devel

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
    name="Hdnum Arch" \
    description="Hdnum in Arch." \
    url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fhdnum" \
    vcs-url="https://github.com/cpp-review-dune/introductory-review" \
    vendor="Oromion Aznarán" \
    version="1.0"

RUN ln -s /usr/share/zoneinfo/America/Lima /etc/localtime && \
  sed -i 's/^#Color/Color/' /etc/pacman.conf && \
  sed -i 's/^#CheckSpace/CheckSpace/' /etc/pacman.conf && \
  sed -i '/CheckSpace/a ILoveCandy' /etc/pacman.conf && \
  sed -i 's/ usr\/share\/doc\/\*//g' /etc/pacman.conf && \
  sed -i 's/usr\/share\/man\/\* //g' /etc/pacman.conf && \
  sed -i 's/^#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/' /etc/makepkg.conf && \
  pacman-key --init && \
  pacman-key --populate archlinux && \
  echo '[multilib]' >> /etc/pacman.conf && \
  echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf && \
  echo '' >> /etc/pacman.conf && \
  pacman --noconfirm -Syyu

ENV MAIN_PKGS="\
    ghostscript clang gnuplot"

RUN pacman -S --noconfirm $MAIN_PKGS && \
  pacman -Scc --noconfirm