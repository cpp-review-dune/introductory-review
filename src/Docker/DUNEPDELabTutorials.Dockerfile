# Copyleft (c) July, 2022, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/dunepdelab

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="DUNEPDELabTutorials Arch" \
  description="DUNEPDELab in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdunepdelabtutorials" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

ARG PACKAGES="\
  man-db \
  tldr \
  eigen \
  gnuplot \
  texlive-latexextra \
  texlive-pictures \
  texlive-science \
  texlive-bibtexextra \
  texlive-fontsextra \
  "

RUN sudo pacman --needed --noconfirm --noprogressbar -Syuq && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  sudo pacman -Scc <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/*

ENV LANGUAGE=es:pe
