# Copyleft (c) December, 2021, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG MESHES_PACKAGES="\
  python-meshzoo \
  python-pygmsh \
  python-meshpy \
  "

RUN yay -Syyuq --noconfirm ${MESHES_PACKAGES}

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="Meshes Arch" \
  description="Meshes in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fmeshes" \
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
  julia \
  "

COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/
COPY --from=build /home/builder/.cache/yay/*/*.install /tmp/

RUN sudo pacman --noconfirm -Syyuq ${PACKAGES} && \
    sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst

ENV PYTHONPATH="/usr/share/gmsh/api/python:${PYTHONPATH}"

CMD ["/bin/bash"]