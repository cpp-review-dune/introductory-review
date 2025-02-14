# Copyleft (c) May, 2024, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG AUR_PACKAGES="\
  dune-fem-dg \
  dune-spgrid \
  jupyter-nbgrader \
  jupyterlab-pytutor \
  jupyterlab-rise \
  parmetis-git \
  petsc \
  python-jupyterlab-variableinspector \
  python-pygmsh \
  "
# dune-vem python-mayavi
RUN yay --repo --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  yay --noconfirm -S ${AUR_PACKAGES} 2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null
FROM ghcr.io/cpp-review-dune/introductory-review/dunefem

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="Jupyter dune-fem Arch" \
  description="dune-fem-jupyter in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdune-fem-jupyter" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

ARG PACKAGES="\
  glew \
  libx11 \
  jupyter-collaboration \
  jupyterlab \
  python-ipympl \
  python-jupyter-server-terminals \
  python-scipy \
  python-pyvirtualdisplay \
  qt5-svg \
  qt5-tools \
  "

COPY --from=build /tmp/*.log /tmp/
COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

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
  echo "alias startJupyter=\"jupyter-lab --port=8888 --no-browser --ip=0.0.0.0 --ServerApp.allow_origin='\$(gp url 8888)' --IdentityProvider.token='' --ServerApp.password=''\"" >> ~/.bashrc

ENV PETSC_DIR=/opt/petsc/linux-c-opt
ENV PYTHONPATH=${PETSC_DIR}/lib:/usr/share/gmsh/api/python
ENV PYDEVD_DISABLE_FILE_VALIDATION=1

EXPOSE 8888

WORKDIR /workspace/notebook/
