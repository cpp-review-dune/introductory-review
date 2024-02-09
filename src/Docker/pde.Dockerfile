# Copyleft (c) March, 2024, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG PKGBUILD_MOLE="https://raw.githubusercontent.com/carlosal1015/mole_examples/main/PKGBUILD"

ARG AUR_PACKAGES="\
  jupyter-octave_kernel \
  python-findiff \
  python-finitediffx \
  python-jaxtyping \
  python-kernex \
  python-pystencils \
  "

ARG DIR_MOLE="/home/builder/.cache/yay/mole"

RUN curl -s https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/add_arch4edu.sh | bash && \
  yay --repo --needed --noconfirm --noprogressbar -Syuq 2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null && \
  yay --noconfirm -S ${AUR_PACKAGES} 2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null && \
  yay -G python-clawpack && \
  cd python-clawpack && \
  git checkout 72f0448040501190054a07970a85ae464b762c80 && \
  makepkg -s --noconfirm && \
  mkdir -p ~/.cache/yay/python-clawpack && \
  mv *.pkg.tar.zst ~/.cache/yay/python-clawpack && \
  mkdir -p ${DIR_MOLE} && \
  pushd ${DIR_MOLE} && \
  curl -LO ${PKGBUILD_MOLE} && \
  makepkg --noconfirm -src 2>&1 | tee -a /tmp/$(date -u +"%Y-%m-%d-%H-%M-%S" --date='5 hours ago').log >/dev/null && \
  popd

FROM ghcr.io/cpp-review-dune/introductory-review/jupyter-python-py-pde

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="pde Arch" \
  description="pde in Arch" \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fpde" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

ARG PACKAGES="\
  octave \
  "

COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

RUN sudo pacman-key --init && \
  sudo pacman-key --populate archlinux && \
  sudo pacman --needed --noconfirm --noprogressbar -Sy archlinux-keyring && \
  curl -s https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/add_arch4edu.sh | bash && \
  sudo pacman --needed --noconfirm --noprogressbar -Syuq && \
  sudo pacman --noconfirm -U /tmp/*.pkg.tar.zst && \
  rm /tmp/*.pkg.tar.zst && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  sudo pacman -Scc <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/* && \
  python -m octave_kernel install --user