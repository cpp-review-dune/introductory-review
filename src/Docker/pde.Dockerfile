# Copyleft (c) March, 2024, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG OPT_PACKAGES="\
  blas-openblas \
  hdf5-openmpi \
  intel-oneapi-mkl \
  python-numpy-mkl \
  python-scipy-mkl \
  "

ARG AUR_PACKAGES="\
  octave-symbolic \
  octave-tablicious \
  otf-intel-one-mono \
  python-devito \
  python-findiff \
  python-finitediffx \
  python-gotranx \
  python-jaxtyping \
  python-kernex \
  python-oct2py \
  python-pystencils \
  python-py-pde \
  python-uvw \
  "

ARG EXTRA_AUR_PACKAGES="\
  nbqa \
  python-numba-mpi \
  python-pyfftw \
  python-rocket-fft \
  pyupgrade \
  "

RUN curl -s https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/add_arch4edu.sh | bash && \
  yay --repo --needed --noconfirm --noprogressbar -Syuq && \
  yay --repo --needed --noconfirm --noprogressbar -S ${OPT_PACKAGES} && \
  yay --needed --noconfirm --noprogressbar -S ${AUR_PACKAGES} && \
  yay --noconfirm --noprogressbar -S ${EXTRA_AUR_PACKAGES} && \
  yay -G python-clawpack && \
  cd python-clawpack && \
  git checkout 72f0448040501190054a07970a85ae464b762c80 && \
  makepkg -s --noconfirm && \
  mkdir -p ~/.cache/yay/python-clawpack && \
  mv *.pkg.tar.zst ~/.cache/yay/python-clawpack

FROM ghcr.io/cpp-review-dune/introductory-review/xeus-cling-mole-git

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="pde Arch" \
  description="pde in Arch" \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fpde" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

ARG PACKAGES="\
  ffmpeg \
  jupyterlab-widgets \
  python-black \
  python-isort \
  python-ipympl \
  python-pandas \
  python-threadpoolctl \
  "

# python-mpi4py \

COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

RUN sudo pacman-key --init && \
  sudo pacman-key --populate archlinux && \
  sudo pacman --needed --noconfirm --noprogressbar -Sy archlinux-keyring && \
  sudo pacman --needed --noconfirm --noprogressbar -Syuq && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  rm /tmp/*.pkg.tar.zst && \
  sudo pacman -Scc <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/* && \
  python -m octave_kernel install --user && \ 
  ipython profile create && \
  echo -e "c.IPythonWidget.font_size = 11\nc.IPythonWidget.font_family = 'Intel One Mono'\nc.IPKernelApp.matplotlib = 'inline'\nc.InlineBackend.figure_format = 'retina'\n" >> ~/.ipython/profile_default/ipython_config.py

ENV MKL_THREADING_LAYER=gnu
ENV PYDEVD_DISABLE_FILE_VALIDATION=1