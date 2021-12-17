# Copyleft (c) December, 2021, Oromion.
# https://dev.to/cloudx/testing-our-package-build-in-the-docker-world-34p0
# https://github.com/alersrt/texlive-archlinux-docker/blob/master/Dockerfile

FROM archlinux:base-devel

LABEL maintainer="C++ Review Dune" \
    name="TeX Live in Gitpod" \
    description="TeX Live in Gitpod with Windows fonts and g++ compiler." \
    url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Ftexlive" \
    vcs-url="https://github.com/cpp-review-dune/introductory-review" \
    vendor="C++ Review Dune" \
    version="1.0"

RUN ln -s /usr/share/zoneinfo/America/Lima /etc/localtime && \
    sed -i 's/^#Color/Color/' /etc/pacman.conf && \
    sed -i '/#CheckSpace/a ILoveCandy' /etc/pacman.conf && \
    sed -i '/ILoveCandy/a ParallelDownloads = 30' /etc/pacman.conf && \
    sed -i 's/^#BUILDDIR/BUILDDIR/' /etc/makepkg.conf && \
    echo '' >> /etc/pacman.conf && \
    echo '[multilib]' >> /etc/pacman.conf && \
    echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf && \
    echo '' >> /etc/pacman.conf && \
    useradd -l -u 33333 -md /home/gitpod -s /bin/bash gitpod && \
    passwd -d gitpod && \
    echo 'gitpod ALL=(ALL) ALL' > /etc/sudoers.d/gitpod && \
    sed -i "s/PS1='\[\\\u\@\\\h \\\W\]\\\\\\$ '//g" /home/gitpod/.bashrc && \
    { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> /home/gitpod/.bashrc

USER gitpod

RUN sudo pacman --noconfirm -Syyu \
    git gcc java-runtime doxygen plantuml \
    texlive-pictures texlive-bibtexextra ghostscript \
    texlive-core texlive-fontsextra texlive-latexextra \
    texlive-science biber && \
    mkdir ~/build && \
    cd ~/build && \
    git clone --depth 1 "https://aur.archlinux.org/yay.git" && \
    cd yay && \
    makepkg --noconfirm -si && \
    rm -rf ~/.cache && \
    rm -rf ~/go && \
    rm -rf ~/build && \
    yay --noconfirm -Sy ttf-vista-fonts consolas-font && \
    yay --afterclean --removemake --save && \
    yay -Qtdq | xargs -r yay --noconfirm -Rcns && \
    rm -rf /home/aur/.cache && \
    yay -Scc <<< Y <<< Y <<< Y

# pacman -S --noconfirm texlive-{core,bin,bibtexextra,fontsextra,formatsextra,games,humanities,langchinese,langcyrillic,langextra,langgreek,langjapanese,langkorean,latexextra,music,pictures,pstricks,publishers,science} ghostscript ruby perl-tk psutils dialog ed poppler-data python python-{pandas,matplotlib,numpy,scipy,sympy}

ENV PATH="/usr/bin/vendor_perl:${PATH}"

CMD ["/bin/bash"]
