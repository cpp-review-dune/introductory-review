# Copyleft (c) December, 2021, Oromion.

FROM archlinux:base-devel

LABEL maintainer="C++ Review Dune" \
  name="DUNEBasics in Gitpod" \
  description="DUNEBasics in Gitpod." \
  url="https://github.com/orgs/cpp-review-dune/packages/container/package/introductory-review%2Fdunebasics" \
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
    vim nano emacs-nox python-dune-common \
    texlive-latexextra texlive-pictures texlive-fontsextra \
    texlive-science texlive-bibtexextra biber inkscape doxygen \
    python-sphinx ttf-fira-code tldr man-pages man-pages-es && \
    mkdir ~/build && \
    cd ~/build && \
    git clone --depth 1 "https://aur.archlinux.org/yay.git" && \
    cd yay && \
    makepkg --noconfirm -si && \
    rm -rf ~/.cache && \
    rm -rf ~/go && \
    rm -rf ~/build && \
    yay --noconfirm -Sy ansiweather && \
    yay --afterclean --removemake --save && \
    yay -Qtdq | xargs -r yay --noconfirm -Rcns && \
    rm -rf /home/aur/.cache && \
    yay -Scc <<< Y <<< Y <<< Y

RUN curl -s https://gitlab.com/dune-archiso/dune-archiso.gitlab.io/-/raw/main/templates/banner.sh | bash -e -x && \
  echo 'cat /etc/motd' >> /home/gitpod/.bashrc

ENV PATH="/usr/bin/vendor_perl:${PATH}"

CMD ["/bin/bash"]