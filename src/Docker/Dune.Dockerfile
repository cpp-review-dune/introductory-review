# Copyleft (c) March, 2021, Oromion.

FROM archlinux:base-devel

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="Dune Arch" \
  description="Dune in Arch" \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdune" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

RUN ln -s /usr/share/zoneinfo/America/Lima /etc/localtime && \
  pacman-key --init && \
  pacman-key --populate archlinux && \
  echo '[multilib]' >> /etc/pacman.conf && \
  echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf && \
  echo '' >> /etc/pacman.conf && \
  echo '[dune-core]' >> /etc/pacman.conf && \
  echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf && \
  echo 'Server = https://dune-archiso.gitlab.io/dune-core/$arch' >> /etc/pacman.conf && \
  echo '' >> /etc/pacman.conf && \
  # echo '[dune-archiso-repository-core]' >> /etc/pacman.conf && \
  # echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf && \
  # echo 'Server = https://dune-archiso.gitlab.io/dune-archiso-repository-core/$arch' >> /etc/pacman.conf && \
  # echo '' >> /etc/pacman.conf && \
  # echo '[dune-archiso-repository-extra]' >> /etc/pacman.conf && \
  # echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf && \
  # echo 'Server = https://dune-archiso.gitlab.io/dune-archiso-repository-extra/$arch' >> /etc/pacman.conf && \
  # echo '' >> /etc/pacman.conf && \
  pacman --noconfirm -Syyu

ENV DEP_PKGS="openblas-lapack parmetis psurface"

ENV MAIN_PKGS="\
  dune-common dune-geometry dune-grid dune-grid-howto dune-istl dune-localfunctions dune-uggrid"

RUN pacman -S --noconfirm $DEP_PKGS && \
  pacman -S --noconfirm $MAIN_PKGS && \
  pacman -Scc --noconfirm