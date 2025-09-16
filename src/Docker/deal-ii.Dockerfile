# Copyleft (c) September, 2025, Oromion

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG OPT_PETSC_PACKAGES="\
  hdf5-openmpi \
  mumps \
  parmetis-git \
  "

ARG OPT_PACKAGES="\
  openmpi \
  p4est-deal-ii \
  petsc \
  python \
  suitesparse \
  trilinos \
  "

ARG AUR_PACKAGES="\
  deal-ii \
  "

ARG PATCH="https://raw.githubusercontent.com/cpp-review-dune/introductory-review/main/src/Docker/0001-Enable-nocheck-for-python-bindings.patch"

# 2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null &&

RUN yay --repo --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  yay --noconfirm -S ${OPT_PETSC_PACKAGES} >/dev/null 2>&1 && \
  yay --noconfirm -S ${OPT_PACKAGES} >/dev/null 2>&1 && \
  git config --global user.email github-actions@github.com && \
  git config --global user.name github-actions && \
  yay -G ${AUR_PACKAGES} && \
  cd deal-ii && \
  curl -O ${PATCH} && \
  git am --signoff <0001-Enable-nocheck-for-python-bindings.patch && \
  makepkg -s --noconfirm && \
  mkdir -p ~/.cache/yay/deal-ii && \
  mv *.pkg.tar.zst ~/.cache/yay/deal-ii

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="deal.II Arch" \
  description="deal.II in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdeal-ii" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

FROM archlinux:base-devel

RUN ln -s /usr/share/zoneinfo/America/Lima /etc/localtime && \
  sed -i 's/^#Color/Color/' /etc/pacman.conf && \
  sed -i 's/^#DisableSandbox/DisableSandbox/' /etc/pacman.conf && \
  sed -i 's/^#DownloadUser/DownloadUser/' /etc/pacman.conf && \
  sed -i '/#CheckSpace/a ILoveCandy' /etc/pacman.conf && \
  sed -i 's/^ParallelDownloads = 5/ParallelDownloads = 30/' /etc/pacman.conf && \
  sed -i 's/^VerbosePkgLists/#VerbosePkgLists/' /etc/pacman.conf && \
  sed -i 's/ usr\/share\/doc\/\*//g' /etc/pacman.conf && \
  sed -i 's/usr\/share\/man\/\* //g' /etc/pacman.conf && \
  sed -i 's/^#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/' /etc/makepkg.conf && \
  sed -i 's/^#BUILDDIR/BUILDDIR/' /etc/makepkg.conf && \
  echo -e '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist' | tee -a /etc/pacman.conf && \
  useradd -l -u 33333 -md /home/gitpod -s /bin/bash gitpod && \
  passwd -d gitpod && \
  echo 'gitpod ALL=(ALL) ALL' >/etc/sudoers.d/gitpod && \
  sed -i "s/PS1='\[\\\u\@\\\h \\\W\]\\\\\\$ '//g" /home/gitpod/.bashrc && \
  { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '"; } >>/home/gitpod/.bashrc

USER gitpod

ARG PACKAGES="\
  clang \
  cmake \
  git \
  gtest \
  hdf5-openmpi \
  openmpi \
  python \
  suitesparse \
  "

COPY --from=build /tmp/*.log /tmp/
COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

RUN sudo pacman-key --init && \
  sudo pacman-key --populate archlinux && \
  sudo pacman --needed --noconfirm --noprogressbar -Sy archlinux-keyring && \
  sudo pacman --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  rm /tmp/*.pkg.tar.zst && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  find /tmp/ ! -name '*.log' -type f -exec rm -f {} + && \
  sudo pacman -Scc <<<Y <<<Y && \
  sudo rm -r /var/lib/pacman/sync/*