# Copyleft (c) December, 2021, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG AUR_PACKAGES="\
  ansiweather \
  python-dune-spgrid \
  python-dune-fem \
  petsc \
  "

RUN yay -Syyuq --noconfirm ${AUR_PACKAGES}

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="python-dune-fem Arch" \
  description="python-dune-fem in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fpython-dune-fem" \
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
  jupyter-notebook \
  python-matplotlib \
  python-scipy \
  "

COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

RUN sudo pacman --noconfirm -Syyuq ${PACKAGES} && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  curl -s https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/banner.sh | sudo bash -e -x && \
  echo 'cat /etc/motd' >> ~/.bashrc && \
  echo 'source /etc/profile.d/petsc.sh' >> ~/.bashrc && \
  echo "alias startJupyter=\"jupyter-notebook --port=8888 --no-browser --ip=0.0.0.0 --NotebookApp.allow_origin='\$(gp url 8888)' --NotebookApp.token='' --NotebookApp.password=''\"" >> ~/.bashrc

ENV OMPI_MCA_opal_warn_on_missing_libcuda=0

EXPOSE 8888

WORKDIR /workspace/notebook/