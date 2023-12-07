# [SOGo](https://sogo.nu/) Docker images based on Arch Linux

### Usage
```sh
docker run -d --name sogo --restart always \
    --publish 127.0.0.1:20000:20000 \
    --publish 127.0.0.1:20001:20001 \
    -e 'LD_PRELOAD=/usr/lib/libytnef.so'
    -v /srv/sogo:/etc/sogo \
    frederickzh/archlinux-sogo:latest
```

Alternatively,

```sh
docker run -d --name sogo --restart always --network host \
    -v /srv/sogo:/etc/sogo \
    -e 'LD_PRELOAD=/usr/lib/libytnef.so'
    frederickzh/archlinux-sogo:latest
```
...however it may raise some security concerns.

### Credits
https://aur.archlinux.org/packages/sogo/  
https://aur.archlinux.org/packages/sope/  
