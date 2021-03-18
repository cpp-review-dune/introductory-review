# Copyleft (c) March, 2021, Oromion.
# https://dev.to/cloudx/testing-our-package-build-in-the-docker-world-34p0
# https://github.com/alersrt/texlive-archlinux-docker/blob/master/Dockerfile

FROM archlinux:base-devel

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
    name="TeX Live Arch" \
    description="TeX Live in Arch." \
    url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Ftexlive" \
    vcs-url="https://github.com/cpp-review-dune/introductory-review" \
    vendor="Oromion Aznarán" \
    version="1.0"

ARG AUR_PACKAGE=ttf-vista-fonts

RUN echo '[multilib]' >> /etc/pacman.conf && \
    echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf && \
    pacman --noconfirm -Syyu git && \
    useradd -m -r -s /bin/bash aur && \
    passwd -d aur && \
    echo 'aur ALL=(ALL) ALL' > /etc/sudoers.d/aur && \
    mkdir -p /home/aur/.gnupg && \
    echo 'standard-resolver' > /home/aur/.gnupg/dirmngr.conf && \
    chown -R aur:aur /home/aur && \
    mkdir /build && \
    chown -R aur:aur /build && \
    cd /build && \
    sudo -u aur git clone --depth 1 "https://aur.archlinux.org/$AUR_PACKAGE.git" && \
    cd $AUR_PACKAGE && \
    sudo -u aur makepkg --noconfirm -si && \
    pacman -Qtdq | xargs -r pacman --noconfirm -Rcns && \
    rm -rf /home/aur/.cache && \
    rm -rf /build

# ENV DEV_PKGS="\
#     binutils gcc gcc-libs icu lib32-glibc lib32-icu"

ENV MAIN_PKGS="\    
    java-runtime texlive-core"

RUN pacman -Syu --noconfirm &&\
    pacman -S --noconfirm $MAIN_PKGS &&\
    # pacman -S --noconfirm texlive-{core,bin,bibtexextra,fontsextra,formatsextra,games,humanities,langchinese,langcyrillic,langextra,langgreek,langjapanese,langkorean,latexextra,music,pictures,pstricks,publishers,science} &&\
    # pacman -S --noconfirm biber ghostscript ruby perl-tk psutils dialog ed poppler-data &&\
    # pacman -S --noconfirm python python-{pandas,matplotlib,numpy,scipy,sympy} &&\
    pacman -Scc --noconfirm

CMD ["/bin/bash"]