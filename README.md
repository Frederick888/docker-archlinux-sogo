# [SOGo](https://sogo.nu/) Docker images based on Arch Linux

### Usage
```sh
docker run -d --name sogo --restart always \
    -v /srv/sogo:/etc/sogo \
    frederickzh/archlinux-sogo:latest
```

Alternatively,

```sh
docker run -d --name sogo --restart always --network host \
    -v /srv/sogo:/etc/sogo \
    frederickzh/archlinux-sogo:latest
```
...however it may raise some security concerns.

### Credits
https://aur.archlinux.org/packages/sogo/
https://aur.archlinux.org/packages/sope/
