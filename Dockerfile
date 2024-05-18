# hadolint global ignore=DL3007,DL3059

FROM archlinux:latest

RUN pacman --noconfirm --needed -Syu && pacman --noconfirm --needed -S base-devel git supervisor apache zip inetutils libsodium libzip libytnef && pacman -Sccq --noconfirm
# hadolint ignore=SC2016
RUN sed 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j$(nproc)"/' -i /etc/makepkg.conf
RUN sed 's/^# \(%wheel.*NOPASSWD.*\)/\1/' -i /etc/sudoers
RUN useradd -r build -G wheel

RUN mkdir /build

WORKDIR /build
RUN git clone --depth 1 https://aur.archlinux.org/libwbxml.git
RUN chown -R build ./libwbxml
WORKDIR /build/libwbxml
RUN su -g wheel -c 'makepkg -is --noconfirm' - build && rm -rf /build/libwbxml && pacman -Sccq --noconfirm

WORKDIR /build
RUN git clone --depth 1 https://aur.archlinux.org/sope.git
RUN chown -R build ./sope
WORKDIR /build/sope
RUN su -g wheel -c 'makepkg -is --noconfirm' - build && rm -rf /build/sope && pacman -Sccq --noconfirm

WORKDIR /build
RUN git clone --depth 1 https://aur.archlinux.org/sogo.git
RUN chown -R build ./sogo
WORKDIR /build/sogo
RUN su -g wheel -c 'makepkg -is --noconfirm' - build && rm -rf /build/sogo && pacman -Sccq --noconfirm

WORKDIR /
RUN rmdir /build

RUN sed 's/^Listen .*/Listen 20001/' -i /etc/httpd/conf/httpd.conf
RUN sed 's|^ErrorLog.*|ErrorLog /dev/stderr|' -i /etc/httpd/conf/httpd.conf
RUN sed 's/^#\(LoadModule .*\/mod_rewrite\.so\)/\1/' -i /etc/httpd/conf/httpd.conf
RUN sed 's/^#\(LoadModule .*\/mod_proxy\.so\)/\1/' -i /etc/httpd/conf/httpd.conf
RUN sed 's/^#\(LoadModule .*\/mod_proxy_http\.so\)/\1/' -i /etc/httpd/conf/httpd.conf
RUN sed 's/^#\(LoadModule .*\/mod_proxy_http2\.so\)/\1/' -i /etc/httpd/conf/httpd.conf
RUN sed 's/^#\(LoadModule .*\/mod_proxy_balancer\.so\)/\1/' -i /etc/httpd/conf/httpd.conf
RUN sed 's/^#\(LoadModule .*\/mod_headers\.so\)/\1/' -i /etc/httpd/conf/httpd.conf
RUN printf 'Include conf/extra/SOGo.conf\n' >>/etc/httpd/conf/httpd.conf

COPY event_listener.ini /etc/supervisor.d/event_listener.ini
COPY event_listener.sh /usr/local/bin/event_listener.sh
RUN chmod +x /usr/local/bin/event_listener.sh
RUN mkdir /var/run/sogo && chown sogo:sogo /var/run/sogo
RUN mkdir /var/spool/sogo && chown sogo:sogo /var/spool/sogo
COPY sogod.ini /etc/supervisor.d/sogod.ini
COPY apache.ini /etc/supervisor.d/apache.ini

CMD ["/usr/sbin/supervisord", "--nodaemon"]
EXPOSE 20000 20001
