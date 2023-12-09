FROM archlinux:latest
ENV LD_PRELOAD=/usr/lib/libytnef.so
RUN pacman --noconfirm --needed -Syu && pacman --noconfirm --needed -S base-devel git supervisor apache zip inetutils libsodium libzip libytnef cronie && yes | pacman -Sccq && \
  sed 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j$(nproc)"/' -i /etc/makepkg.conf && sed 's/^# \(%wheel.*NOPASSWD.*\)/\1/' -i /etc/sudoers && useradd -r build -G wheel &&  mkdir /build

WORKDIR /build
RUN git clone --depth 1 https://aur.archlinux.org/libwbxml.git && chown -R build ./libwbxml 
WORKDIR /build/libwbxml
RUN sudo -u build makepkg -is --noconfirm && rm -rf /build/libwbxml && yes | pacman -Sccq

WORKDIR /build
RUN git clone --depth 1 https://aur.archlinux.org/sope.git &&  chown -R build ./sope
WORKDIR /build/sope
RUN sudo -u build makepkg -is --noconfirm && rm -rf /build/sope && yes | pacman -Sccq

WORKDIR /build
RUN git clone --depth 1 https://aur.archlinux.org/sogo.git &&  chown -R build ./sogo
WORKDIR /build/sogo
RUN sudo -u build makepkg -is --noconfirm && rm -rf /build/sogo && yes | pacman -Sccq


COPY httpd.conf /etc/httpd/conf/httpd.conf
COPY event_listener.ini /etc/supervisor.d/event_listener.ini
COPY event_listener.sh /usr/local/bin/event_listener.sh
RUN chmod +x /usr/local/bin/event_listener.sh
RUN mkdir /var/run/sogo && chown sogo:sogo /var/run/sogo
RUN mkdir /var/spool/sogo && chown sogo:sogo /var/spool/sogo
COPY sogod.ini /etc/supervisor.d/sogod.ini
COPY apache.ini /etc/supervisor.d/apache.ini
COPY cronie.ini /etc/supervisor.d/cronie.ini
COPY memcached.ini /etc/supervisor.d/memcached.ini

# clean up
RUN pacman --noconfirm -Rcns base-devel git && yes | pacman -Sccq && rm -rf /tmp/* /var/tmp/* /var/cache/pacman/pkg/*


WORKDIR /
CMD ["/usr/sbin/supervisord", "--nodaemon"]
EXPOSE 20000 20001
