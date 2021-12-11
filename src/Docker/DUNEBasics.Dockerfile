# Copyleft (c) November, 2021, Oromion.

FROM registry.gitlab.com/dune-archiso/images/dune-archiso-yay

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="DUNEBasics Arch" \
  description="DUNEBasics in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdunebasics" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

RUN useradd -l -u 33333 -md /home/gitpod -s /bin/bash gitpod && \
  passwd -d gitpod && \
  echo 'gitpod ALL=(ALL) ALL' > /etc/sudoers.d/gitpod && \
  sed -i "s/PS1='\[\\\u\@\\\h \\\W\]\\\\\\$ '//g" /home/gitpod/.bashrc && \
  { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> /home/gitpod/.bashrc

USER aur

RUN yay --noconfirm -Syyu ansiweather vim emacs-nox python-dune-common texlive-latexextra texlive-pictures texlive-science texlive-fontsextra texlive-bibtexextra biber inkscape doxygen python-sphinx ttf-fira-code tldr man-pages man-pages-es && \
  yay -Qtdq | xargs -r yay --noconfirm -Rcns && \
  rm -rf /home/aur/.cache && \
  yay -Scc <<< Y <<< Y <<< Y

ENV PATH="/usr/bin/vendor_perl:${PATH}"

USER gitpod

RUN curl -s https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/banner.sh | bash -e -x && \
  echo 'cat /etc/motd' >> /home/gitpod/.bashrc

WORKDIR /home/gitpod