# Copyleft (c) December, 2021, Oromion.

FROM archlinux:base-devel

LABEL maintainer="C++ Review Dune" \
    name="Builder packages from AUR in Gitpod" \
    description="Builder packages from AUR." \
    url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2FAUR" \
    vcs-url="https://github.com/cpp-review-dune/introductory-review" \
    vendor="C++ Review Dune" \
    version="1.0"

WORKDIR /tmp/

ARG USER="builder"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN sed -i 's/^#Color/Color/' /etc/pacman.conf && \
    sed -i '/#CheckSpace/a ILoveCandy' /etc/pacman.conf && \
    sed -i '/ILoveCandy/a ParallelDownloads = 30' /etc/pacman.conf && \
    sed -i 's/^#BUILDDIR/BUILDDIR/' /etc/makepkg.conf && \
    printf '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf && \
    useradd -l -md /home/${USER} -s /bin/bash ${USER} && \
    passwd -d ${USER} && \
    echo 'builder ALL=(ALL) ALL' > /etc/sudoers.d/${USER} && \
    pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Syyu --noconfirm && \
    curl -LO "https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz" && \
    tar -xvf yay.tar.gz && \
    cd yay && \
    makepkg -src --cleanbuild --noconfirm && \
    rm -rf go