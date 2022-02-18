# Copyleft (c) February, 2022, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG AUR_PACKAGES="\
  ansiweather \
  "

RUN yay --needed --noconfirm --noprogressbar -Syyuq ${AUR_PACKAGES}

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="DUNE-GitHub Arch" \
  description="DUNE-GitHub in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdune-github" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

FROM archlinux:base-devel

RUN ln -s /usr/share/zoneinfo/America/Lima /etc/localtime && \
  sed -i 's/^#Color/Color/' /etc/pacman.conf && \
  sed -i '/#CheckSpace/a ILoveCandy' /etc/pacman.conf && \
  sed -i '/ILoveCandy/a ParallelDownloads = 30' /etc/pacman.conf && \
  sed -i 's/^#BUILDDIR/BUILDDIR/' /etc/makepkg.conf && \
  printf '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf && \
  useradd -l -u 33333 -md /home/gitpod -s /bin/bash gitpod && \
  passwd -d gitpod && \
  echo 'gitpod ALL=(ALL) ALL' > /etc/sudoers.d/gitpod && \
  sed -i "s/PS1='\[\\\u\@\\\h \\\W\]\\\\\\$ '//g" /home/gitpod/.bashrc && \
  { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> /home/gitpod/.bashrc

USER gitpod

ARG PACKAGES="\
  vim \
  emacs-nox \
  dune-core-git \
  dune-staging-git \
  dune-extensions-git \
  "

COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

ARG BANNER=https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/banner.sh

RUN sudo pacman --needed --noconfirm --noprogressbar -Syyuq && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  echo -e '\n[dune-archiso-repository-core]\n' >> /etc/pacman.conf && \
  echo -e 'SigLevel = Optional TrustAll\n' >> /etc/pacman.conf && \
  echo -e 'Server = https://dune-archiso.gitlab.io/repository/dune-archiso-repository-core/$arch' >> /etc/pacman.conf && \
  echo -e '\n[dune-core-git]\n' >> /etc/pacman.conf && \
  echo -e 'SigLevel = Optional TrustAll\n' >> /etc/pacman.conf && \
  echo -e 'Server = https://dune-archiso.gitlab.io/repository/dune-core-git/$arch' >> /etc/pacman.conf && \
  echo -e '\n[dune-staging-git]\n' >> /etc/pacman.conf && \
  echo -e 'SigLevel = Optional TrustAll\n' >> /etc/pacman.conf && \
  echo 'Server = https://dune-archiso.gitlab.io/repository/dune-staging-git/$arch' >> /etc/pacman.conf && \
  echo -e '\n[dune-extensions-git]\n' >> /etc/pacman.conf && \
  echo -e 'SigLevel = Optional TrustAll\n' >> /etc/pacman.conf && \
  echo -e 'Server = https://dune-archiso.gitlab.io/repository/dune-extensions-git/$arch\n' >> /etc/pacman.conf && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  curl -s ${BANNER} | sudo bash -e -x && \
  echo 'cat /etc/motd' >> ~/.bashrc

ENV OMPI_MCA_opal_warn_on_missing_libcuda=0

CMD ["/bin/bash"]