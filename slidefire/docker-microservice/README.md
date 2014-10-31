
## run slides

```bash
$ vagrant ssh
$ cd /mnt/docker.d/slides/microserice
$ ./run.sh
```

## Make port 8000 accessable at your virtualbox host machine

```bash
VBoxManage controlvm docker-workshop_docker-workshop-vm_1412158153640_81416 natpf1 "tcp-port8000,tcp,,8000,,8000"
```

## brower the slides
open at your host machine with `open http://localhost:8000`

## build a shipable image and push

```bash
$ vagrant ssh
$ cd /mnt/docker.d/slides/microserice
$ ./build.sh
```
Peter
