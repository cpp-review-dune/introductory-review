# Copyleft (c) May, 2024, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG OPT_PACKAGES="\
  blas-openblas \
  intel-oneapi-basekit \
  "

ARG AUR_PACKAGES="\
  octave-tablicious \
  otf-intel-one-mono \
  python-devito \
  python-findiff \
  python-finitediffx \
  python-gotranx \
  python-jaxtyping \
  python-kernex \
  python-numpy-stl \
  python-pystencils \
  python-py-pde \
  python-uvw \
  "

ARG EXTRA_AUR_PACKAGES="\
  nbqa \
  jupyter-nbgrader \
  jupyterlab-pytutor \
  jupyterlab-rise \
  python-clawpack \
  python-numba-mpi \
  python-pyfftw \
  python-rocket-fft \
  pyupgrade \
  "

# python-jupyterlab-variableinspector

RUN curl -s https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/add_arch4edu.sh | bash && \
  yay --repo --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  yay --repo --needed --noconfirm --noprogressbar -S ${OPT_PACKAGES} >/dev/null 2>&1 && \
  yay --mflags --nocheck --needed --noconfirm --noprogressbar -S ${AUR_PACKAGES} >/dev/null 2>&1 && \
  yay --mflags --nocheck --needed --noconfirm --noprogressbar -S ${EXTRA_AUR_PACKAGES}
# 2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null

FROM ghcr.io/cpp-review-dune/introductory-review/xeus-cling-mole

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
  python-jupyter-server-terminals \
  python-pandas \
  python-threadpoolctl \
  "

COPY --from=build /tmp/*.log /tmp/
COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

RUN sudo pacman-key --init && \
  sudo pacman-key --populate archlinux && \
  sudo pacman --needed --noconfirm --noprogressbar -Sy archlinux-keyring && \
  sudo pacman --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  rm /tmp/*.pkg.tar.zst && \
  find /tmp/ ! -name '*.log' -type f -exec rm -f {} + && \
  sudo pacman -Scc <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/* && \
  ipython profile create && \
  echo -e "c.IPythonWidget.font_size = 11\nc.IPythonWidget.font_family = 'Intel One Mono'\nc.IPKernelApp.matplotlib = 'inline'\nc.InlineBackend.figure_format = 'retina'\n" >> ~/.ipython/profile_default/ipython_config.py

ENV PYDEVD_DISABLE_FILE_VALIDATION=1
