# Copyleft (c) May, 2022, Oromion.

FROM archlinux:base-devel

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="test Arch" \
  description="test in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Ftest" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

ARG PACKAGES="\
  catch2 \
  cmake \
  fmt \
  "

# gnuplot python-numpy python-matplotlib

RUN ln -s /usr/share/zoneinfo/America/Lima /etc/localtime && \
  sed -i 's/^#Color/Color/' /etc/pacman.conf && \
  sed -i '/#CheckSpace/a ILoveCandy' /etc/pacman.conf && \
  sed -i 's/^ParallelDownloads = 5/ParallelDownloads = 30/' /etc/pacman.conf && \
  sed -i 's/^VerbosePkgLists/#VerbosePkgLists/' /etc/pacman.conf && \
  sed -i 's/ usr\/share\/doc\/\*//g' /etc/pacman.conf && \
  sed -i 's/usr\/share\/man\/\* //g' /etc/pacman.conf && \
  sed -i 's/^#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/' /etc/makepkg.conf && \
  sed -i 's/^#BUILDDIR/BUILDDIR/' /etc/makepkg.conf && \
  echo -e '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist' | tee -a /etc/pacman.conf && \
  pacman --needed --noconfirm --noprogressbar -Syyuq && \
  pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  pacman -Scc <<< Y <<< Y && \
  rm -r /var/lib/pacman/sync/*