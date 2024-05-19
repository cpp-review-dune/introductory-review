# Copyleft (c) May, 2024, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG OPT_PACKAGES="\
  hdf5-openmpi \
  hypre \
  mumps \
  netcdf-openmpi \
  parmetis-git \
  "

ARG AUR_PACKAGES="\
  python-adios4dolfinx \
  "

ARG POST_PACKAGES="\
  slepc \
  "

RUN yay --repo --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  yay --noconfirm -S ${OPT_PACKAGES} && \
  yay --mflags --nocheck --noconfirm -S ${AUR_PACKAGES} && \
  yay --mflags --nocheck --noconfirm -S ${POST_PACKAGES}

# 2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="python-fenics-dolfinx with Python Arch" \
  description="python-fenics-dolfinx in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdeal-ii" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

FROM archlinux:base-devel

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
  useradd -l -u 33333 -md /home/gitpod -s /bin/bash gitpod && \
  passwd -d gitpod && \
  echo 'gitpod ALL=(ALL) ALL' > /etc/sudoers.d/gitpod && \
  sed -i "s/PS1='\[\\\u\@\\\h \\\W\]\\\\\\$ '//g" /home/gitpod/.bashrc && \
  { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> /home/gitpod/.bashrc

USER gitpod

COPY --from=build /tmp/*.log /tmp/
COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

RUN sudo pacman-key --init && \
  sudo pacman-key --populate archlinux && \
  sudo pacman --needed --noconfirm --noprogressbar -Sy archlinux-keyring && \
  sudo pacman --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  rm /tmp/*.pkg.tar.zst && \
  find /tmp/ ! -name '*.log' -type f -exec rm -f {} + && \
  sudo pacman -Scc <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/*

ENV PETSC_DIR=/opt/petsc/linux-c-opt
ENV SLEPC_DIR=/opt/slepc/linux-c-opt
ENV PYTHONPATH=${PYTHONPATH}:${PETSC_DIR}/lib:${SLEPC_DIR}/lib