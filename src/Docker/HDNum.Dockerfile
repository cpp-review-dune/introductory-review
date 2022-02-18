# Copyleft (c) February, 2022, Oromion.

FROM archlinux:base-devel

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="HDNum Arch" \
  description="HDNum in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fhdnum" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

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
  ghostscript \
  clang \
  gnuplot \
  "

RUN sudo pacman --noconfirm -Syyuq ${PACKAGES}

# RUN git clone -q --depth=1 --filter=blob:none --no-checkout https://github.com/cpp-review-dune/hdnum && \
#   echo -e "CC = clang++\nCCFLAGS = -I\$(HDNUMPATH) -std=c++11 -O3\nGMPCCFLAGS = -DHDNUM_HAS_GMP=1 -I/usr/include\nLFLAGS = -lm\nGMPLFLAGS = -L/usr/lib -lgmpxx -lgmp" > make.def
CMD ["/bin/bash"]