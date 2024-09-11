# [SOGo](https://sogo.nu/) Docker images based on Arch Linux

### Usage
```sh
docker run -d --name sogo --restart always \
    --publish 127.0.0.1:20000:20000 \
    --publish 127.0.0.1:20001:20001 \
    -v /srv/sogo:/etc/sogo \
    -v /srv/sogo/crontab:/etc/crontab \
    frederickzh/archlinux-sogo:latest
```

Alternatively,

```sh
docker run -d --name sogo --restart always --network host \
    -v /srv/sogo:/etc/sogo \
    -v /srv/sogo/crontab:/etc/crontab \
    frederickzh/archlinux-sogo:latest
```
...however it may raise some security concerns.

(The `crontab` is optional. See https://github.com/Alinto/sogo/blob/master/Scripts/sogo.cron.)

### Credits
https://aur.archlinux.org/packages/sogo/  
https://aur.archlinux.org/packages/sope/  
