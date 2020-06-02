FROM archlinux:20200306

RUN sed -i -e '/IgnorePkg *=/s/^.*$/IgnorePkg = coreutils/' /etc/pacman.conf

RUN pacman --noconfirm --needed -Syu && pacman --noconfirm --needed -S base-devel git supervisor apache zip && yes | pacman -Sccq
RUN sed 's/^# \(%wheel.*NOPASSWD.*\)/\1/' -i /etc/sudoers
RUN useradd -r build -G wheel

RUN mkdir /build

WORKDIR /build
RUN git clone --depth 1 https://aur.archlinux.org/libwbxml.git
RUN chown -R build ./libwbxml
WORKDIR /build/libwbxml
RUN sudo -u build makepkg -is --noconfirm && rm -rf /build/libwbxml && yes | pacman -Sccq

WORKDIR /build
RUN git clone --depth 1 https://aur.archlinux.org/sope.git
RUN chown -R build ./sope
WORKDIR /build/sope
RUN sudo -u build makepkg -is --noconfirm && rm -rf /build/sope && yes | pacman -Sccq

WORKDIR /build
RUN git clone --depth 1 https://aur.archlinux.org/sogo.git
RUN chown -R build ./sogo
WORKDIR /build/sogo
RUN sudo -u build makepkg -is --noconfirm && rm -rf /build/sogo && yes | pacman -Sccq

RUN sed 's/^Listen .*/Listen 20001/' -i /etc/httpd/conf/httpd.conf
RUN sed 's|^ErrorLog.*|ErrorLog /dev/stderr|' -i /etc/httpd/conf/httpd.conf
RUN sed 's/^#\(LoadModule .*\/mod_rewrite\.so\)/\1/' -i /etc/httpd/conf/httpd.conf
RUN sed 's/^#\(LoadModule .*\/mod_proxy\.so\)/\1/' -i /etc/httpd/conf/httpd.conf
RUN sed 's/^#\(LoadModule .*\/mod_proxy_http\.so\)/\1/' -i /etc/httpd/conf/httpd.conf
RUN sed 's/^#\(LoadModule .*\/mod_proxy_http2\.so\)/\1/' -i /etc/httpd/conf/httpd.conf
RUN sed 's/^#\(LoadModule .*\/mod_proxy_balancer\.so\)/\1/' -i /etc/httpd/conf/httpd.conf
RUN sed 's/^#\(LoadModule .*\/mod_headers\.so\)/\1/' -i /etc/httpd/conf/httpd.conf
RUN printf 'Include conf/extra/SOGo.conf\n' | tee -a /etc/httpd/conf/httpd.conf

RUN mkdir /var/run/sogo && chown sogo:sogo /var/run/sogo
RUN mkdir /var/spool/sogo && chown sogo:sogo /var/spool/sogo
ADD sogod.ini /etc/supervisor.d/sogod.ini
ADD apache.ini /etc/supervisor.d/apache.ini

WORKDIR /
CMD ["/usr/sbin/supervisord", "--nodaemon"]
EXPOSE 20000 20001
