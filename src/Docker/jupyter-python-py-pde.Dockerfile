# Copyleft (c) December, 2023, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG OPT_PACKAGES="\
  nbqa \
  python-numba-mpi \
  python-pyfftw \
  python-rocket-fft \
  "

ARG AUR_PACKAGES="\
  jupyter-octave_kernel \
  python-findiff \
  python-py-pde \
  python-pystencils \
  "

RUN yay --repo --needed --noconfirm --noprogressbar -Syuq && \
  yay --noconfirm -S ${OPT_PACKAGES} && \
  yay --noconfirm --noprogressbar -Syuq ${AUR_PACKAGES} 2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null

# yay --noconfirm --noprogressbar -S napari --mflags --skipinteg

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="Jupyter python-py-pde Arch" \
  description="python-py-pde in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fpython-py-pde" \
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
  git \
  ffmpeg \
  jupyter-collaboration \
  jupyterlab \
  jupyterlab-widgets \
  python-black \
  python-h5py-openmpi \
  python-mpi4py \
  python-pandas \
  "

COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

RUN sudo pacman --needed --noconfirm --noprogressbar -Syuq && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  rm /tmp/*.pkg.tar.zst && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  sudo pacman -Scc <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/* && \
  echo "alias startJupyter=\"jupyter-lab --port=8888 --no-browser --ip=0.0.0.0 --NotebookApp.allow_origin='\$(gp url 8888)' --NotebookApp.token='' --NotebookApp.password=''\"" >> ~/.bashrc

ENV PYDEVD_DISABLE_FILE_VALIDATION=1

EXPOSE 8888

WORKDIR /workspace/notebook/
