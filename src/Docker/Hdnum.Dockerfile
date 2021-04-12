# Copyleft (c) April, 2021, Oromion.

FROM registry.gitlab.com/dune-archiso/dune-archiso-docker

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="Hdnum Arch" \
  description="Hdnum in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fhdnum" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

RUN pacman-key --init && \
  pacman-key --populate archlinux && \
  pacman --noconfirm -Syyu

ENV MAIN_PKGS="\
  ghostscript clang gnuplot"

RUN pacman -S --noconfirm $MAIN_PKGS && \
  pacman -Scc --noconfirm

# RUN git clone -q --depth=1 --filter=blob:none --no-checkout https://github.com/cpp-review-dune/hdnum

# echo -e "CC = clang++\nCCFLAGS = -I\$(HDNUMPATH) -std=c++11 -O3\nGMPCCFLAGS = -DHDNUM_HAS_GMP=1 -I/usr/include\nLFLAGS = -lm\nGMPLFLAGS = -L/usr/lib -lgmpxx -lgmp" > make.def

RUN useradd -m -r -s /bin/bash hdnum-student && \
  passwd -d hdnum-student && \
  echo 'hdnum-student ALL=(ALL) ALL' > /etc/sudoers.d/hdnum-student && \
  sudo -u hdnum-student bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

USER hdnum-student