# Copyleft (c) July, 2022, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG AUR_PACKAGES="\
  dune-functions \
  dune-typetree \
  dune-alugrid \
  openssh \
  ansiweather \
  "

RUN yay --noconfirm --noprogressbar -Syyuq ${AUR_PACKAGES}

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="AMDiS Arch" \
  description="AMDiS in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Famdis" \
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
  amdis \
  "

COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

ARG BANNER=https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/banner.sh

ARG GPG_KEY="8C43C00BA8F06ECA"

RUN sudo pacman-key --init && \
  sudo pacman-key --populate archlinux && \
  sudo pacman-key --recv-keys ${GPG_KEY} && \
  sudo pacman-key --finger ${GPG_KEY} && \
  sudo pacman-key --lsign-key ${GPG_KEY} && \
  sudo pacman --needed --noconfirm --noprogressbar -Syyuq && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  rm /tmp/*.pkg.tar.zst && \
  echo -e '\n[amdis]\nSigLevel = Required DatabaseOptional\nServer = https://dune-archiso.gitlab.io/repository/amdis/$arch\n' | sudo tee -a /etc/pacman.conf && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  sudo pacman -Scc <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/* && \
  curl -s ${BANNER} | sudo bash -e -x && \
  echo 'cat /etc/motd' >> ~/.bashrc

ENV OMPI_MCA_opal_warn_on_missing_libcuda=0

CMD ["/bin/bash"]
