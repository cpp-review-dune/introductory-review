# Copyleft (c) March, 2022, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG AUR_PACKAGES="\
  dune-functions \
  precice \
  precice-config-visualizer-git \
  dune-foamgrid \
  ansiweather \
  "

RUN yay --noconfirm --noprogressbar -Syyuq ${AUR_PACKAGES}

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="DUNE-preCICE Arch" \
  description="DUNE-preCICE in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fduneprecice" \
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

ARG PACKAGES="\
  vim \
  emacs-nox \
  dune-precice-git \
  "

COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

ARG BANNER=https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/banner.sh

RUN sudo pacman --needed --noconfirm -Syyuq && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  echo -e '\n[precice-arch]\nSigLevel = Optional TrustAll\nServer = https://dune-archiso.gitlab.io/testing/precice-arch/$arch\n' | sudo tee -a /etc/pacman.conf && \
  sudo pacman --needed --noconfirm -Sy ${PACKAGES} && \
  curl -s ${BANNER} | sudo bash -e -x && \
  echo 'cat /etc/motd' >> ~/.bashrc

ENV OMPI_MCA_opal_warn_on_missing_libcuda=0

CMD ["/bin/bash"]