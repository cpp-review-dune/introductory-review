# Copyleft (c) March, 2024, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG AUR_PACKAGES="\
  nbqa \
  parmetis-git \
  python-meshio \
  python-fenics-dolfinx \
  python-pyvista \
  python-trame \
  python-trame-vtk \
  python-trame-vuetify \
  "

# https://docs.pyvista.org/version/stable/user-guide/jupyter
RUN yay --repo --needed --noconfirm --noprogressbar -Syuq && \
  yay --mflags --nocheck --noconfirm -S ${AUR_PACKAGES}

#2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null

FROM ghcr.io/cpp-review-dune/introductory-review/python-fenics-dolfinx

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="Jupyter dolfinx Arch" \
  description="Jupyter dolfinx in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdolfinx" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

ARG VTK_PACKAGES="\
  adios2 \
  cgns \
  ffmpeg \
  fmt \
  gl2ps \
  glew \
  hdf5-openmpi \
  jsoncpp \
  libxcursor \
  openvr \
  openxr \
  ospray \
  netcdf \
  mariadb-libs \
  liblas \
  libharu \
  pdal \
  postgresql-libs \
  qt5-base \
  verdict \
  "

ARG PACKAGES="\
  git \
  jupyter-collaboration \
  jupyterlab-widgets \
  python-black \
  python-matplotlib \
  xorg-server-xvfb \
  "

COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

RUN sudo pacman-key --init && \
  sudo pacman-key --populate archlinux && \
  sudo pacman --needed --noconfirm --noprogressbar -Sy archlinux-keyring && \
  sudo pacman --needed --noconfirm --noprogressbar -Syuq && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${VTK_PACKAGES} && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  rm /tmp/*.pkg.tar.zst && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  sudo pacman -Scc <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/* && \
  echo "alias startJupyter=\"jupyter-lab --port=8888 --no-browser --ip=0.0.0.0 --ServerApp.allow_origin='\$(gp url 8888)' --IdentityProvider.token='' --ServerApp.password=''\"" >> ~/.bashrc

ENV OMPI_MCA_opal_warn_on_missing_libcuda=0
ENV PETSC_DIR=/opt/petsc/linux-c-opt
ENV PYTHONPATH=${PYTHONPATH}:${PETSC_DIR}/lib
ENV TRAME_DISABLE_V3_WARNING="1"
ENV DISPLAY=":99.0"
ENV PYVISTA_OFF_SCREEN="true"
ENV PYVISTA_USE_IPYVTK="true"
ENV PYVISTA_TRAME_SERVER_PROXY_PREFIX="/proxy/"
ENV PYVISTA_TRAME_SERVER_PROXY_ENABLED="True"
ENV PYVISTA_JUPYTER_BACKEND="trame"
ENV PYDEVD_DISABLE_FILE_VALIDATION=1

EXPOSE 8888

WORKDIR /workspace/notebook/