# Copyleft (c) December, 2023, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG PKGBUILD="https://gitlab.com/dune-archiso/pkgbuilds/dune/-/raw/main/PKGBUILDS/hdnum-git/PKGBUILD"

RUN yay --repo --needed --noconfirm --noprogressbar -Syuq && \
  curl -LO ${PKGBUILD} && \
  makepkg --noconfirm -src 2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null && \
  mkdir -p /home/builder/.cache/yay/hdnum-git && \
  mv hdnum-git-*-x86_64.pkg.tar.zst /home/builder/.cache/yay/hdnum-git

FROM ghcr.io/cpp-review-dune/introductory-review/xeus-cling

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="xeus-cling-hdnum-git Arch" \
  description="HDNum in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fhdnum" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

ARG PACKAGES="\
  cmake \
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