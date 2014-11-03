# 6) Linking containers


## docker run --name

```
# Assign a name to the container
$ docker run -d --name mynginx 127.0.0.1:5000/dockerfile/nginx
f01e0624537deaa096d309ea8fd7e3d9abbaad72ba84aeda2292d7502ce66ed2
```

```
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS                     PORTS               NAMES
f01e0624537d        nginx:latest        "nginx -g 'daemon of   About an hour ago   Up About a minute          443/tcp, 80/tcp     mynginx
```


## docker run --link

```
# Add link to another container in the form of name:alias
$ docker run -it --link mynginx:web rossbachp/tomcat8 /bin/bash
```


## Excercise 6 

1. Start the nginx container with `--name web`
2. Start a container with `curl` installed and link it to nginx<br>
   We are using `rossbachp/tomcat8` which has curl installed.

<!--
$ docker run -d - -name mynginx 127.0.0.1:5000/dockerfile/nginx
$ docker ps

$ docker run -it - -link mynginx:web rossbachp/tomcat8 /bin/bash
$ env
curl $WEB_PORT_443_TCP_ADDR
cat /etc/hosts
$ curl web
-->

