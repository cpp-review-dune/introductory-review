# Copyleft (c) May, 2024, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/dunepdelab

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="DUNEPDELabTutorials Arch" \
  description="DUNEPDELab in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdunepdelabtutorials" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

ARG PACKAGES="\
  eigen \
  gnuplot \
  man-pages \
  man-pages-es \
  texlive-latexextra \
  texlive-pictures \
  texlive-science \
  texlive-bibtexextra \
  texlive-fontsextra \
  tldr \
  "

RUN sudo pacman --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} 2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null && \
  sudo pacman -Scc <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/*

ENV LANGUAGE=es:pe
