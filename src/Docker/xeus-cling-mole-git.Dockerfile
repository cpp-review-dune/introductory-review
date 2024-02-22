# Copyleft (c) March, 2024, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG OPT_PACKAGES="\
  blas-openblas \
  fftw-openmpi \
  intel-oneapi-mkl \
  "

ARG PACKAGES="\
  armadillo \
  petsc \
  python-oct2py \
  "

ARG PKGBUILD="https://raw.githubusercontent.com/carlosal1015/mole_examples/main/PKGBUILDs/mole-git/PKGBUILD"

RUN yay --repo --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  yay --repo --needed --noconfirm --noprogressbar -S ${OPT_PACKAGES} >/dev/null 2>&1 && \
  yay --mflags --nocheck --needed --noconfirm --noprogressbar -S ${PACKAGES} >/dev/null 2>&1 && \
  curl -LO ${PKGBUILD} && \
  makepkg --noconfirm -src >/dev/null 2>&1 && \
  mkdir -p /home/builder/.cache/yay/mole-git && \
  mv mole-git-*-x86_64.pkg.tar.zst /home/builder/.cache/yay/mole-git

FROM ghcr.io/cpp-review-dune/introductory-review/xeus-cling

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="xeus-cling-mole-git Arch" \
  description="MOLE in Arch" \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fmole" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

ARG PACKAGES="\
  cmake \
  blas-openblas \
  fftw-openmpi \
  intel-oneapi-mkl \
  python-numpy-mkl \
  python-scipy-mkl \
  "

COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

RUN curl -s https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/add_arch4edu.sh | bash && \
  sudo pacman-key --init && \
  sudo pacman-key --populate archlinux && \
  sudo pacman --needed --noconfirm --noprogressbar -Sy archlinux-keyring && \
  sudo pacman --needed --noconfirm --noprogressbar -Syuq >/dev/null 2>&1 && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} >/dev/null 2>&1 && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  rm /tmp/*.pkg.tar.zst && \
  sudo pacman -Scc <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/* && \
  python -m octave_kernel install --user

ENV OMPI_MCA_opal_warn_on_missing_libcuda=0
ENV PETSC_DIR=/opt/petsc/linux-c-opt
ENV PYTHONPATH=${PYTHONPATH}:${PETSC_DIR}/lib