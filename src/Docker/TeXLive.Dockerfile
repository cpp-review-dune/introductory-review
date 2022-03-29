# Copyleft (c) March, 2022, Oromion.
# https://dev.to/cloudx/testing-our-package-build-in-the-docker-world-34p0
# https://github.com/alersrt/texlive-archlinux-docker/blob/master/Dockerfile

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG FONT_PACKAGES="\
  yay \
  "

RUN yay --noconfirm --noprogressbar -Syyuq ${FONT_PACKAGES}
# && \ find -maxdepth=2 /tmp -type f -not -name '*.install' -not -name '*.pkg.tar.zst' | xargs -0 -I {} rm {} && \
# ls -lR /tmp --builddir=/tmp

LABEL maintainer="C++ Review Dune" \
  name="TeX Live in Gitpod" \
  description="TeX Live in Gitpod with Windows fonts and g++ compiler." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Ftexlive" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="C++ Review Dune" \
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
  git \
  java-runtime \
  ghostscript \
  biber \
  doxygen \
  plantuml \
  texlive-pictures \
  texlive-bibtexextra \
  texlive-fontsextra \
  texlive-latexextra \
  texlive-science \
  "

COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

RUN sudo pacman --needed --noconfirm --noprogressbar -Syyuq && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  rm /tmp/*.pkg.tar.zst && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  yay --noconfirm  -S ttf-vista-fonts consolas-font && \
  yay -Qtdq | xargs -r yay --noconfirm -Rcns && \
  rm -rf ~/.cache && \
  yay -Scc <<< Y <<< Y <<< Y
  # texlive-{core,bin,bibtexextra,fontsextra,formatsextra,games,humanities,langchinese,langcyrillic,langextra,langgreek,langjapanese,langkorean,latexextra,music,pictures,pstricks,publishers,science} ruby perl-tk psutils dialog ed poppler-data

ENV PATH="/usr/bin/vendor_perl:${PATH}"

CMD ["/bin/bash"]
