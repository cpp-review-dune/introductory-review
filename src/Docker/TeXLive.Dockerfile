# Copyleft (c) March, 2021, Oromion.
# https://dev.to/cloudx/testing-our-package-build-in-the-docker-world-34p0
# https://github.com/alersrt/texlive-archlinux-docker/blob/master/Dockerfile

FROM registry.gitlab.com/dune-archiso/images/dune-archiso-docker

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
    name="TeX Live Arch" \
    description="TeX Live in Arch with Windows fonts and C++ compilers" \
    url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Ftexlive" \
    vcs-url="https://github.com/cpp-review-dune/introductory-review" \
    vendor="Oromion Aznarán" \
    version="1.0"
ENV FONT_PKGS="\
    ttf-vista-fonts consolas-font"

RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman --noconfirm -Syyu && \
    sudo -u aur yay --noconfirm -Sy $FONT_PKGS && \
    sudo -u aur yay --afterclean --removemake --save && \
    sudo -u aur yay -Qtdq | xargs -r sudo -u aur yay --noconfirm -Rcns && \
    rm -rf /home/aur/.cache

ENV MAIN_PKGS="\    
    gcc java-runtime doxygen plantuml texlive-pictures texlive-bibtexextra ghostscript texlive-core texlive-fontsextra texlive-latexextra texlive-science"

RUN pacman -Syu --noconfirm &&\
    pacman -S --noconfirm $MAIN_PKGS &&\
    # pacman -S --noconfirm texlive-{core,bin,bibtexextra,fontsextra,formatsextra,games,humanities,langchinese,langcyrillic,langextra,langgreek,langjapanese,langkorean,latexextra,music,pictures,pstricks,publishers,science} &&\
    # pacman -S --noconfirm biber ghostscript ruby perl-tk psutils dialog ed poppler-data &&\
    # pacman -S --noconfirm python python-{pandas,matplotlib,numpy,scipy,sympy} &&\
    pacman -Qtdq | xargs -r pacman --noconfirm -Rcns && \
    pacman -Scc <<< Y <<< Y

CMD ["/bin/bash"]
