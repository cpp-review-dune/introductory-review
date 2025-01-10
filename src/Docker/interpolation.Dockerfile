# Copyleft (c) May, 2024, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG PKGBUILD_COVID19H="https://gitlab.com/dune-archiso/pkgbuilds/dune/-/raw/main/PKGBUILDS/python-covid19dh/PKGBUILD"
ARG PKGBUILD_HDNUM="https://gitlab.com/dune-archiso/pkgbuilds/dune/-/raw/main/PKGBUILDS/hdnum-git/PKGBUILD"
ARG PKGBUILD_TUTORMAGIC="https://gitlab.com/dune-archiso/pkgbuilds/dune/-/raw/main/PKGBUILDS/jupyter-nbextension-tutormagic/PKGBUILD"

ARG INTERPOLATION_PACKAGES="\
  nbqa \
  identinum \
  jupyter-nbgrader \
  jupyter-octave_kernel \
  jupyterlab-pytutor \
  jupyterlab-rise \
  python-bezier \
  python-cmocean \
  python-gustaf \
  python-jupyterlab-variableinspector \
  python-optimistix \
  python-optax \
  python-perfplot \
  python-splines \
  python-splinepy \
  pyupgrade \
  "

ARG DIR_COVID19H="/home/builder/.cache/yay/python-covid19h"
ARG DIR_HDNUM="/home/builder/.cache/yay/hdnum-git"
ARG DIR_TUTORMAGIC="/home/builder/.cache/yay/jupyter-nbextension-tutormagic"

RUN curl -s https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/add_arch4edu.sh | bash && \
  yay --repo --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  yay --noconfirm --mflags --nocheck -S ${INTERPOLATION_PACKAGES} && \
  mkdir -p ${DIR_COVID19H} && \
  pushd ${DIR_COVID19H} && \
  curl -LO ${PKGBUILD_COVID19H} && \
  makepkg --noconfirm -src && \
  popd && \
  mkdir -p ${DIR_HDNUM} && \
  pushd ${DIR_HDNUM} && \
  curl -LO ${PKGBUILD_HDNUM} && \
  makepkg --noconfirm -src && \
  popd && \
  mkdir -p ${DIR_TUTORMAGIC} && \
  pushd ${DIR_TUTORMAGIC} && \
  curl -LO ${PKGBUILD_TUTORMAGIC} && \
  makepkg --noconfirm -src
  
#2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="Interpolation Arch" \
  description="Interpolation in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Finterpolation" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

FROM archlinux:base-devel

RUN ln -s /usr/share/zoneinfo/America/Lima /etc/localtime && \
  sed -i 's/^#Color/Color/' /etc/pacman.conf && \
  sed -i 's/^#DisableSandbox/DisableSandbox/' /etc/pacman.conf && \
  sed -i 's/^#DownloadUser/DownloadUser/' /etc/pacman.conf && \
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

ARG OPT_PACKAGES="\
  octave \
  "

ARG PACKAGES="\
  cmake \
  ffmpeg \
  git \
  jupyter-collaboration \
  jupyterlab \
  python-black \
  python-distro \
  python-ipympl \
  python-isort \
  python-jupyter-server-terminals \
  python-seaborn \
  python-sympy \
  python-tabulate \
  python-xarray \
  texlive-fontsrecommended \
  texlive-latexextra \
  "

COPY --from=build /tmp/*.log /tmp/
COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

RUN sudo pacman-key --init && \
  sudo pacman-key --populate archlinux && \
  sudo pacman --needed --noconfirm --noprogressbar -Sy archlinux-keyring && \
  curl -s https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/add_arch4edu.sh | bash && \ 
  sudo pacman --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${OPT_PACKAGES} && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  rm /tmp/*.pkg.tar.zst && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  find /tmp/ ! -name '*.log' -type f -exec rm -f {} + && \
  sudo pacman -Scc <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/* && \
  echo "alias startJupyter=\"jupyter-lab --port=8888 --no-browser --ip=0.0.0.0 --ServerApp.allow_origin='\$(gp url 8888)' --IdentityProvider.token='' --ServerApp.password=''\"" >> ~/.bashrc && \
  python -m octave_kernel install --user

# echo "setenv(\"GNUTERM\",\"fltk\");" >> ~/.octaverc && \

ENV PYDEVD_DISABLE_FILE_VALIDATION=1

EXPOSE 8888
