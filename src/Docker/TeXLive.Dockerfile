# Copyleft (c) March, 2021, Oromion.

FROM oblique/archlinux-yay

LABEL maintainer="Oromion <caznaranl@uni.pe>" \
    name="Dune Arch" \
    description="Dune in Arch." \
    url="https://github.com/user/cpp-review-dune/packages/container/package/introductory-review" \
    vcs-url="https://github.com/cpp-review-dune/introductory-review" \
    vendor="Oromion Aznarán" \
    version="1.0"


ENV MAIN_PKGS="\
    java-runtime texlive-core ttf-vista-fonts"

RUN sudo -u aur yay --noconfirm -Sy $MAIN_PKGS && \
    sudo -u aur yay --afterclean --removemake --save && \
    sudo -u aur yay -Qtdq | xargs -r sudo -u aur yay --noconfirm -Rcns && \
    rm -rf /home/aur/.cache