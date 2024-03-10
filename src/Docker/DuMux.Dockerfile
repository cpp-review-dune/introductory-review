# Copyleft (c) March, 2024, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS dumux

ARG AUR_PACKAGES="\
  dumux \
  "

RUN sudo pacman --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  yay --needed --noconfirm --noprogressbar -S ${AUR_PACKAGES} 2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG OPT_PRE_PACKAGES="\
  dune-alugrid \
  dune-spgrid \
  dune-subgrid \
  opm-grid \
  parmetis-git \
  "

ARG OPT_POST_PACKAGES="\
  dune-foamgrid \
  dune-functions \
  dune-mmesh \
  "

# ARG DUMUX_LECTURE="https://gitlab.com/dune-archiso/pkgbuilds/dune/-/raw/main/PKGBUILDS/dumux-lecture/PKGBUILD"

RUN sudo pacman --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  yay --needed --noconfirm --noprogressbar -S ${OPT_PRE_PACKAGES} && \
  yay --needed --noconfirm --noprogressbar -S ${OPT_POST_PACKAGES}

# mkdir -p dumux-lecture
# curl -LO ${DUMUX_LECTURE} && \
# makepkg --noconfirm --nocheck -src && \
# mkdir -p /home/builder/.cache/yay/dumux-lecture && \
# mv dumux-lecture-*-x86_64.pkg.tar.zst /home/builder/.cache/yay/dumux-lecture

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="DuMux Arch" \
  description="DuMux in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdumux" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

FROM archlinux:base-devel

RUN ln -s /usr/share/zoneinfo/America/Lima /etc/localtime && \
  sed -i 's/^#Color/Color/' /etc/pacman.conf && \
  sed -i '/#CheckSpace/a ILoveCandy' /etc/pacman.conf && \
  sed -i 's/^ParallelDownloads = 5/ParallelDownloads = 30/' /etc/pacman.conf && \
  sed -i 's/^VerbosePkgLists/#VerbosePkgLists/' /etc/pacman.conf && \
  sed -i 's/ usr\/share\/doc\/\*//g' /etc/pacman.conf && \
  sed -i 's/usr\/share\/man\/\* //g' /etc/pacman.conf && \
  sed -i 's/^#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/' /etc/makepkg.conf && \
  sed -i 's/^#BUILDDIR/BUILDDIR/' /etc/makepkg.conf && \
  echo -e '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist' | tee -a /etc/pacman.conf && \
  useradd -l -u 33333 -md /home/gitpod -s /bin/bash gitpod && \
  passwd -d gitpod && \
  echo 'gitpod ALL=(ALL) ALL' > /etc/sudoers.d/gitpod && \
  sed -i "s/PS1='\[\\\u\@\\\h \\\W\]\\\\\\$ '//g" /home/gitpod/.bashrc && \
  { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> /home/gitpod/.bashrc

USER gitpod

ARG PACKAGES="\
  clang \
  gnuplot \
  "

COPY --from=build /tmp/*.log /tmp/
COPY --from=dumux /home/builder/.cache/yay/dumux/dumux-*.pkg.tar.zst /tmp/
COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

ARG BANNER=https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/banner.sh

RUN sudo pacman-key --init && \
  sudo pacman-key --populate archlinux && \
  sudo pacman --needed --noconfirm --noprogressbar -Sy archlinux-keyring && \
  sudo pacman --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  rm /tmp/*.pkg.tar.zst && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  find /tmp/ ! -name '*.log' -type f -exec rm -f {} + && \
  sudo pacman -Scc <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/* && \
  curl -s ${BANNER} | sudo bash -e -x && \
  echo 'cat /etc/motd' >> ~/.bashrc

CMD ["/bin/bash"]
