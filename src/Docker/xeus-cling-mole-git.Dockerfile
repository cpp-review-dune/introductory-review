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
  "

ARG PKGBUILD="https://raw.githubusercontent.com/carlosal1015/mole_examples/main/PKGBUILDs/mole-git/PKGBUILD"

RUN yay --repo --needed --noconfirm --noprogressbar -Syuq 2>&1 >/dev/null && \
  yay --repo --needed --noconfirm --noprogressbar -S ${OPT_PACKAGES} 2>&1 >/dev/null && \
  yay --mflags --nocheck --needed --noconfirm --noprogressbar -S ${PACKAGES} 2>&1 >/dev/null && \
  curl -LO ${PKGBUILD} && \
  makepkg --noconfirm -src 2>&1 >/dev/null && \
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
  sudo pacman --needed --noconfirm --noprogressbar -Syuq && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  rm /tmp/*.pkg.tar.zst && \
  sudo pacman -Scc <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/*

ENV OMPI_MCA_opal_warn_on_missing_libcuda=0
ENV PETSC_DIR=/opt/petsc/linux-c-opt
ENV PYTHONPATH=${PYTHONPATH}:${PETSC_DIR}/lib