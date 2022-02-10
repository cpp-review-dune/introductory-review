# Copyleft (c) January, 2022, Oromion.

FROM archlinux:base-devel

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
  name="Docker Arch" \
  description="Docker in Arch." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdocker" \
  vcs-url="https://github.com/cpp-review-dune/introductory-review" \
  vendor="Oromion Aznarán" \
  version="1.0"

USER gitpod

ARG PACKAGES="\
  docker \
  "

RUN sudo pacman --noconfirm -Syyuq ${PACKAGES} && \
  sudo systemctl enable docker && \
  sudo pacman -Scc <<< Y <<< Y

CMD ["/bin/zsh"]