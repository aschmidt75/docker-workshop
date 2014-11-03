# 3) Working with images


## docker images

```
# Available images on the host
$ docker images
REPOSITORY                            TAG                   IMAGE ID            CREATED             VIRTUAL SIZE
127.0.0.1:5000/dockerfile/nginx       latest                52cea49d86cf        5 days ago          435.2 MB
nginx                                 latest                52cea49d86cf        5 days ago          435.2 MB
registry                              latest                8e9a29f977a7        6 days ago          427.9 MB
127.0.0.1:5000/ubuntu                 14.04                 5506de2b643b        6 days ago          197.8 MB
```


## docker tag

```
# Tag an image
$ docker tag 127.0.0.1:5000/ubuntu myubuntu
```


## docker rmi

```
# Delete an image
$ docker rmi nginx
```


## docker pull

```
# Pull an image from an repository
$ docker pull 127.0.0.1:5000/ubuntu
Pulling repository 127.0.0.1:5000/ubuntu
5506de2b643b: Download complete
511136ea3c5a: Download complete
d497ad3926c8: Download complete
ccb62158e970: Download complete
e791be0477f2: Download complete
3680052c0f5c: Download complete
22093c35d77b: Download complete
Status: Image is up to date for 127.0.0.1:5000/ubuntu:latest
```


## docker history

```
# Show the history of an image
$ docker history 127.0.0.1:5000/ubuntu
IMAGE               CREATED             CREATED BY                                      SIZE
5506de2b643b        6 days ago          /bin/sh -c #(nop) CMD [/bin/bash]               0 B
22093c35d77b        6 days ago          /bin/sh -c apt-get update && apt-get dist-upg   5.067 MB
3680052c0f5c        6 days ago          /bin/sh -c sed -i s/^#\s*\(deb.*universe\)$/   1.895 kB
e791be0477f2        6 days ago          /bin/sh -c rm -rf /var/lib/apt/lists/*          0 B
ccb62158e970        6 days ago          /bin/sh -c echo '#!/bin/sh' > /usr/sbin/polic   194.5 kB
d497ad3926c8        9 days ago          /bin/sh -c #(nop) ADD file:3996e886f2aa934dda   192.5 MB
511136ea3c5a        16 months ago
```


## docker diff
```
#  Inspect changes on a container's filesystem
$ docker diff 371e7819491f
A /data
C /tmp
A /tmp/docker-registry.db
```


## docker commit

```
#  Create a new image from a container's changes
$ docker commit 371e7819491f myimage
e412662cb4d8376b3d78a202f78ff3b42980041fc067b6c1c12d67163b1e5435
```


## Excercise 3
## Running containers
1. Start the nginx container with a bash
2. Check by browsing to localhost:8000
2. Add an index.html to `/usr/share/nginx/html`
3. Run the container and publish container port 80 to 8000


## Excercise 3b
## Save containers changes

1. Submit the changes to a new image and start it


## Excercise 3c
## Pull new images
1. remove java images<br>
`$ docker rmi 127.0.0.1:5000/dockerfile/java:oracle-java8`<br>
`$ docker rmi 127.0.0.1:5000/dockerfile/java`

2. pull docker image<br>
`$ docker pull 127.0.0.1:5000/dockerfile/java:oracle-java8`

<!--
Solution

$ docker create --name mynginx -p 8000:80 nginx
$ docker start -i mynginx
# browse to localhost:8000
# keep running open new terminal
$ docker exec -it mynginx /bin/bash
$ echo hello wjax > /usr/share/nginx/html/index.html
# browse to localhost:8080

$ docker diff mynginx
# make image
$ docker commit mynginx wjaxnginx
$ docker images
$ docker run -p 8080:80 wjaxnginx
$ docker ps -a
$ docker diff 39005338b8d1

-->