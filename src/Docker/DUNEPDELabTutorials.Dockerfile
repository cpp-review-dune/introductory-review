# Copyleft (c) February, 2022, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG AUR_PACKAGES="\
  petsc \
  "

RUN yay --noconfirm --noprogressbar -Syyuq ${AUR_PACKAGES}

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="DUNEPDELabTutorials Arch" \
  description="DUNEPDELab in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdunepdelabtutorials" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

FROM ghcr.io/cpp-review-dune/introductory-review/dunepdelab

ARG PACKAGES="\
  man-db \
  tldr \
  eigen \
  texlive-latexextra \
  texlive-pictures \
  texlive-science \
  texlive-bibtexextra \
  texlive-fontsextra \
  "

COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

RUN sudo pacman --needed --noconfirm --noprogressbar -Syyuq && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES}

ENV LANGUAGE=es:pe