# Copyleft (c) December, 2023, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG OPT_PACKAGES="\
  nbqa \
  openmpi \
  parmetis-git \
  petsc \
  p4est-deal-ii \
  python \
  suitesparse \
  kokkos \
  "

ARG PATCH="https://raw.githubusercontent.com/cpp-review-dune/introductory-review/main/src/Docker/0001-Enable-python-bindings.patch"

RUN yay --repo --needed --noconfirm --noprogressbar -Syuq && \
  yay --noconfirm -S ${OPT_PACKAGES} && \
  git config --global user.email github-actions@github.com && \
  git config --global user.name github-actions && \
  yay -G deal-ii && \
  cd deal-ii && \
  curl -O ${PATCH} && \
  git am --signoff <0001-Enable-python-bindings.patch && \
  makepkg -s --noconfirm && \
  mkdir -p ~/.cache/yay/deal-ii && \
  mv *.pkg.tar.zst ~/.cache/yay/deal-ii

# 2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null

FROM ghcr.io/cpp-review-dune/introductory-review/xeus-cling

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="xeus-cling-dune Arch" \
  description="xeus-cling-dune in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fxeus-cling-dune" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

ARG PACKAGES="\
  autopep8 \
  fmt \
  "

COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

RUN sudo pacman-key --init && \
  sudo pacman-key --populate archlinux && \
  sudo pacman --needed --noconfirm --noprogressbar -Sy archlinux-keyring && \
  sudo pacman --needed --noconfirm --noprogressbar -Syuq && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  rm /tmp/*.pkg.tar.zst && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  sudo pacman -Scc <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/*