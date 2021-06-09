# Copyleft (c) May, 2021, Oromion.

FROM registry.gitlab.com/dune-archiso/images/dune-archiso-docker

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="dune-python Arch" \
  description="dune-python in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdune-python" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

ENV EDITOR_PKGS="vim emacs-nox jupyter-notebook"

ENV DUNE_PKGS="\
  dune-python"

RUN echo '' >> /etc/pacman.conf && \
  echo '[dune-archiso-repository-core]' >> /etc/pacman.conf && \
  echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf && \
  echo 'Server = https://dune-archiso.gitlab.io/repository/dune-archiso-repository-core/$arch' >> /etc/pacman.conf && \
  echo '' >> /etc/pacman.conf && \
  echo '[dune-core]' >> /etc/pacman.conf && \
  echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf && \
  echo 'Server = https://dune-archiso.gitlab.io/repository/dune-core/$arch' >> /etc/pacman.conf && \
  echo '' >> /etc/pacman.conf && \
  echo '[dune-staging]' >> /etc/pacman.conf && \
  echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf && \
  echo 'Server = https://dune-archiso.gitlab.io/repository/dune-staging/$arch' >> /etc/pacman.conf && \
  echo '' >> /etc/pacman.conf && \
  pacman-key --init && \
  pacman-key --populate archlinux && \
  pacman --noconfirm -Syyu && \
  pacman -S --noconfirm $DUNE_PKGS && \
  pacman -S --noconfirm $EDITOR_PKGS && \
  pacman -Qtdq | xargs -r pacman --noconfirm -Rcns && \
  pacman -Scc <<< Y <<< Y && \
  useradd -l -u 33333 -md /home/gitpod -s /bin/bash gitpod && \
  passwd -d gitpod && \
  echo 'gitpod ALL=(ALL) ALL' > /etc/sudoers.d/gitpod && \
  sed -i "s/PS1='\[\\\u\@\\\h \\\W\]\\\\\\$ '//g" /home/gitpod/.bashrc && \
  { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> /home/gitpod/.bashrc && \
  echo "alias cmake='cmake -Wno-dev'" >> /home/gitpod/.bashrc && \
  echo "alias mpirun='mpirun --mca opal_warn_on_missing_libcuda 0'" >> /home/gitpod/.bashrc

USER gitpod

WORKDIR /home/gitpod

EXPOSE 8888