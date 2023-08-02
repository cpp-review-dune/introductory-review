# Copyleft (c) July, 2022, Oromion.

FROM ghcr.io/cpp-review-dune/introductory-review/aur AS build

ARG AUR_PACKAGES="\
  dune-pdelab \
  "

# nbqa parmetis-git

RUN yay --repo --needed --noconfirm --noprogressbar -Syyuq && \
  yay --noconfirm --noprogressbar -S parmetis-git && \
  yay --noconfirm --noprogressbar -S ${AUR_PACKAGES} && \
  ls -lR /home/builder/.cache/yay

FROM ghcr.io/cpp-review-dune/introductory-review/dunefem

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="DUNELearnTutorials Arch" \
  description="DUNELearn in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdunelearntutorials" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

ARG PACKAGES="\
  jupyterlab \
  minted \
  pandoc \
  texlive-binextra \
  "

COPY --from=build /home/builder/.cache/yay/*/*.pkg.tar.zst /tmp/

RUN sudo pacman --needed --noconfirm --noprogressbar -Syyuq && \
  sudo pacman --needed --noconfirm -U /tmp/*.pkg.tar.zst && \
  sudo pacman --needed --noconfirm --noprogressbar -S ${PACKAGES} && \
  rm /tmp/*.pkg.tar.zst && \
  sudo pacman -Scc <<< Y <<< Y && \
  sudo rm -r /var/lib/pacman/sync/* && \
  echo "alias startJupyter=\"jupyter-lab --port=8888 --no-browser --ip=0.0.0.0 --ServerApp.allow_origin='\$(gp url 8888)' --ServerApp.token='' --ServerApp.password=''\"" >> ~/.bashrc

EXPOSE 8888
