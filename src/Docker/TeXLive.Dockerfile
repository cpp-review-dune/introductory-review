# Copyleft (c) October, 2024, Oromion.
# https://dev.to/cloudx/testing-our-package-build-in-the-docker-world-34p0
# https://github.com/alersrt/texlive-archlinux-docker/blob/master/Dockerfile

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG MTPRO2_LITE_SOURCE="https://raw.githubusercontent.com/carlosal1015/mathtime-installer/carlosal1015/mtp2lite.zip.tpm"

ARG FONT_PACKAGES="\
  otf-intel-one-mono \
  yay \
  "

RUN yay --repo --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  yay --noconfirm -S ${FONT_PACKAGES} 2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null && \
  yay -G tex-math-time-pro2-lite && \
  cd tex-math-time-pro2-lite && \
  curl -O ${MTPRO2_LITE_SOURCE} && \
  makepkg -s --noconfirm --skipchecksums 2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null && \
  mkdir -p ~/.cache/yay/tex-math-time-pro2-lite && \
  mv *.pkg.tar.zst ~/.cache/yay/tex-math-time-pro2-lite

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
  sed -i 's/^#DisableSandbox/DisableSandbox/' /etc/pacman.conf && \
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
  cmake \
  git \
  jdk17-openjdk \
  biber \
  doxygen \
  perl-file-homedir \
  perl-yaml-tiny \
  plantuml \
  python-pygments \
  texlive-binextra \
  texlive-bibtexextra \
  texlive-fontsextra \
  texlive-fontutils \
  texlive-langgerman \
  texlive-langspanish \
  texlive-latexextra \
  texlive-luatex \
  texlive-plaingeneric \
  texlive-mathscience \
  texlive-xetex \
  ttf-fira-code \
  ttf-ibm-plex \
  ttf-jetbrains-mono \
  "

COPY --from=build /tmp/*.log /tmp/
COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

ARG UNI_TEMPLATE="https://raw.githubusercontent.com/carlosal1015/Plantilla-Tesis-UNI-LaTeX/science/TesisUNI.cls"
ARG LU_TEMPLATE="https://gitlab.maths.lu.se/robertk/thesislatextemplate/-/raw/main/lu-thesis.sty"
ARG LU_PATCH="https://raw.githubusercontent.com/cpp-review-dune/introductory-review/src/Docker/lu-thesis.patch"

ARG LOCAL_CLASS="/home/gitpod/texmf/tex/latex/local"

RUN sudo pacman-key --init && \
  sudo pacman-key --populate archlinux && \
  sudo pacman --needed --noconfirm --noprogressbar -Sy archlinux-keyring && \
  sudo pacman --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  rm /tmp/*.pkg.tar.zst && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  yay --noconfirm  -S ttf-ms-fonts ttf-vista-fonts consolas-font && \
  yay -Qtdq | xargs -r yay --noconfirm -Rcns && \
  rm -rf ~/.cache && \
  find /tmp/ ! -name '*.log' -type f -exec rm -f {} + && \
  yay -Scc <<< Y <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/* && \
  mkdir -p $LOCAL_CLASS && \
  curl --create-dirs -O --output-dir $LOCAL_CLASS $UNI_TEMPLATE && \
  curl -O --output-dir $LOCAL_CLASS $LU_TEMPLATE && \
  curl -O --output-dir $LOCAL_CLASS $LU_PATCH && \
  cd $LOCAL_CLASS && \
  patch lu-thesis.sty lu-thesis.patch && \
  rm lu-thesis.patch
# texlive-{core,bin} ruby perl-tk psutils dialog ed poppler-data

ENV PATH="/usr/bin/vendor_perl:${PATH}"
ENV PLANTUML_JAR="/usr/share/java/plantuml/plantuml.jar"

CMD ["/bin/bash"]
