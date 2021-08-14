# Copyleft (c) August, 2021, Oromion.

FROM registry.gitlab.com/dune-archiso/images/dune-archiso-docker

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="HDNum Arch" \
  description="HDNum in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fhdnum" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

ENV MAIN_PKGS="\
  ghostscript clang gnuplot"

RUN pacman-key --init && \
  pacman-key --populate archlinux && \
  pacman --noconfirm -Syyu && \
  pacman -S --noconfirm $MAIN_PKGS && \
  pacman -Qtdq | xargs -r pacman --noconfirm -Rcns && \
  pacman -Scc <<< Y <<< Y && \
  useradd -l -u 33333 -md /home/gitpod -s /bin/bash gitpod && \
  passwd -d gitpod && \
  echo 'gitpod ALL=(ALL) ALL' > /etc/sudoers.d/gitpod && \
  # sudo -u gitpod bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
  sed -i "s/PS1='\[\\\u\@\\\h \\\W\]\\\\\\$ '//g" /home/gitpod/.bashrc && \
  { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> /home/gitpod/.bashrc

# RUN git clone -q --depth=1 --filter=blob:none --no-checkout https://github.com/cpp-review-dune/hdnum && \
#   echo -e "CC = clang++\nCCFLAGS = -I\$(HDNUMPATH) -std=c++11 -O3\nGMPCCFLAGS = -DHDNUM_HAS_GMP=1 -I/usr/include\nLFLAGS = -lm\nGMPLFLAGS = -L/usr/lib -lgmpxx -lgmp" > make.def

USER gitpod

WORKDIR /home/gitpod
