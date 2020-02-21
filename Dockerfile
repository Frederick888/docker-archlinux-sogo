FROM archlinux:latest

RUN pacman --noconfirm -Syu && pacman --noconfirm -S base-devel git supervisor && rm -rf /var/cache/pacman/pkg
RUN sed 's/^# \(%wheel.*NOPASSWD.*\)/\1/' -i /etc/sudoers
RUN useradd -r build -G wheel

RUN mkdir /build

WORKDIR /build
RUN git clone --depth 1 https://aur.archlinux.org/libwbxml.git
RUN chown -R build ./libwbxml
WORKDIR /build/libwbxml
RUN sudo -u build makepkg -is --noconfirm && rm -rf /var/cache/pacman/pkg /build/libwbxml

WORKDIR /build
RUN git clone --depth 1 https://aur.archlinux.org/sope.git
RUN chown -R build ./sope
WORKDIR /build/sope
RUN sudo -u build makepkg -is --noconfirm && rm -rf /var/cache/pacman/pkg /build/sope

WORKDIR /build
RUN git clone --depth 1 https://aur.archlinux.org/sogo.git
RUN chown -R build ./sogo
WORKDIR /build/sogo
RUN sudo -u build makepkg -is --noconfirm && rm -rf /var/cache/pacman/pkg /build/sogo

RUN mkdir /var/run/sogo && chown sogo:sogo /var/run/sogo
ADD sogod.ini /etc/supervisor.d/sogod.ini

WORKDIR /
CMD ["/usr/sbin/supervisord", "--nodaemon"]
EXPOSE 20000
