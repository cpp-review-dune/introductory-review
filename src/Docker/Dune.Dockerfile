# Copyleft (c) March, 2021, Oromion.

FROM registry.gitlab.com/dune-archiso/dune-archiso-docker

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="Dune Arch" \
  description="Dune in Arch" \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdune" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

RUN echo '' >> /etc/pacman.conf && \
  echo '[dune-core]' >> /etc/pacman.conf && \
  echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf && \
  echo 'Server = https://dune-archiso.gitlab.io/dune-core/$arch' >> /etc/pacman.conf && \
  echo '' >> /etc/pacman.conf && \
  pacman-key --init && \
  pacman-key --populate archlinux && \
  pacman --noconfirm -Syyu

ENV DEP_PKGS="openblas-lapack parmetis psurface"

ENV MAIN_PKGS="\
  dune-common dune-geometry dune-grid dune-grid-howto dune-istl dune-localfunctions dune-uggrid"

ENV DUNE_PKGS="\
  dune-common dune-geometry dune-grid dune-istl dune-localfunctions"

RUN pacman -S --noconfirm $DUNE_PKGS && \
  # pacman -S --noconfirm $DEP_PKGS && \
  # pacman -S --noconfirm $MAIN_PKGS && \
  pacman -Scc --noconfirm

RUN useradd -m -r -s /bin/bash dune-student && \
  passwd -d dune-student && \
  sudo -u dune-student bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

USER dune-student