# Copyleft (c) October, 2021, Oromion.

FROM registry.gitlab.com/dune-archiso/images/dune-archiso-docker

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="DUNE-GitHub Arch" \
  description="DUNE-GitHub in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdune-github" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

RUN useradd -l -u 33333 -md /home/gitpod -s /bin/bash gitpod && \
  passwd -d gitpod && \
  echo 'gitpod ALL=(ALL) ALL' > /etc/sudoers.d/gitpod && \
  sed -i "s/PS1='\[\\\u\@\\\h \\\W\]\\\\\\$ '//g" /home/gitpod/.bashrc && \
  { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> /home/gitpod/.bashrc && \
  echo '' >> /etc/pacman.conf && \
  echo '[dune-archiso-repository-core]' >> /etc/pacman.conf && \
  echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf && \
  echo 'Server = https://dune-archiso.gitlab.io/repository/dune-archiso-repository-core/$arch' >> /etc/pacman.conf && \
  echo '' >> /etc/pacman.conf && \
  echo '[dune-core-git]' >> /etc/pacman.conf && \
  echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf && \
  echo 'Server = https://dune-archiso.gitlab.io/repository/dune-core-git/$arch' >> /etc/pacman.conf && \
  echo '' >> /etc/pacman.conf && \
  echo '[dune-staging-git]' >> /etc/pacman.conf && \
  echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf && \
  echo 'Server = https://dune-archiso.gitlab.io/repository/dune-staging-git/$arch' >> /etc/pacman.conf && \
  echo '' >> /etc/pacman.conf && \
  echo '[dune-extensions-git]' >> /etc/pacman.conf && \
  echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf && \
  echo 'Server = https://dune-archiso.gitlab.io/repository/dune-extensions-git/$arch' >> /etc/pacman.conf && \
  echo '' >> /etc/pacman.conf

USER aur
# dune-extensions-git
RUN yay --noconfirm -Syyu vim emacs-nox dune-core-git dune-staging-git && \
  pacman -Qtdq | xargs -r pacman --noconfirm -Rcns && \
  pacman -Scc <<< Y <<< Y && \
  yay -Qtdq | xargs -r yay --noconfirm -Rcns && \
  rm -rf /home/aur/.cache && \
  yay -Scc <<< Y <<< Y <<< Y

USER gitpod

RUN curl -s https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/banner.sh | bash -e -x && \
  echo 'cat /etc/motd' >> /home/gitpod/.bashrc && \
  echo "alias cmake='cmake -Wno-dev'" >> /home/gitpod/.bashrc && \
  echo "alias mpirun='mpirun --mca opal_warn_on_missing_libcuda 0'" >> /home/gitpod/.bashrc

WORKDIR /home/gitpod