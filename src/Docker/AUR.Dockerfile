# Copyleft (c) February, 2022, Oromion.

FROM archlinux:base-devel

LABEL maintainer="C++ Review Dune" \
  name="Builder packages from AUR in Gitpod" \
  description="Builder packages from AUR." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2FAUR" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="C++ Review Dune" \
  version="1.0"

WORKDIR /tmp/

ARG USER="builder"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG YAY_URL="https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz"

RUN sed -i 's/^#Color/Color/' /etc/pacman.conf && \
  sed -i '/#CheckSpace/a ILoveCandy' /etc/pacman.conf && \
  sed -i '/ILoveCandy/a ParallelDownloads = 30' /etc/pacman.conf && \
  sed -i 's/^#BUILDDIR/BUILDDIR/' /etc/makepkg.conf && \
  echo -e '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist' | tee -a /etc/pacman.conf && \
  useradd -l -u 33333 -md /home/${USER} -s /bin/bash ${USER} && \
  passwd -d ${USER} && \
  printf "${USER} ALL=(ALL) ALL" > /etc/sudoers.d/${USER} && \
  pacman-key --init && \
  pacman-key --populate archlinux && \
  pacman --needed --noconfirm --noprogressbar -Syyuq && \
  curl -LO ${YAY_URL} && \
  tar -xvf yay.tar.gz && \
  chown -R ${USER}:${USER} /tmp/yay && \
  cd yay && \
  sudo -u ${USER} makepkg -srci --cleanbuild --noconfirm && \
  rm -rf /tmp/* /home/${USER}/.cache/

USER ${USER}