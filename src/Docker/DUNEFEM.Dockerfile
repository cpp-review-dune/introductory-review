# Copyleft (c) November, 2021, Oromion.

FROM registry.gitlab.com/dune-archiso/images/dune-archiso-yay

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="DUNEFEM Arch" \
  description="DUNEFEM in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdunefem" \
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
  echo '[dune-core]' >> /etc/pacman.conf && \
  echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf && \
  echo 'Server = https://dune-archiso.gitlab.io/repository/dune-core/$arch' >> /etc/pacman.conf && \
  echo '' >> /etc/pacman.conf && \
  echo '[dune-staging]' >> /etc/pacman.conf && \
  echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf && \
  echo 'Server = https://dune-archiso.gitlab.io/repository/dune-staging/$arch' >> /etc/pacman.conf && \
  echo '' >> /etc/pacman.conf && \
  echo '[dune-extensions]' >> /etc/pacman.conf && \
  echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf && \
  echo 'Server = https://dune-archiso.gitlab.io/repository/dune-extensions/$arch' >> /etc/pacman.conf && \
  echo '' >> /etc/pacman.conf && \
  echo '[dune-fem]' >> /etc/pacman.conf && \
  echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf && \
  echo 'Server = https://dune-archiso.gitlab.io/repository/dune-fem/$arch' >> /etc/pacman.conf && \
  echo '' >> /etc/pacman.conf

USER aur

RUN yay --noconfirm -Syyu ansiweather vim emacs-nox dune-fem && \
  yay -Qtdq | xargs -r yay --noconfirm -Rcns && \
  rm -rf /home/aur/.cache && \
  yay -Scc <<< Y <<< Y <<< Y

USER gitpod

RUN curl -s https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/banner.sh | bash -e -x && \
  echo 'cat /etc/motd' >> /home/gitpod/.bashrc && \
  echo "alias cmake='cmake -Wno-dev'" >> /home/gitpod/.bashrc && \
  echo "alias mpirun='mpirun --mca opal_warn_on_missing_libcuda 0'" >> /home/gitpod/.bashrc

WORKDIR /home/gitpod