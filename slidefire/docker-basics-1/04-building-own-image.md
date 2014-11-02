# 4) Building images


## docker build

```
# Build a new image from the source path
$ docker build .
Sending build context to Docker daemon 686.1 kB
Sending build context to Docker daemon
Step 0 : FROM nginx
 ---> f1c42afeb4a4
Step 1 : COPY . /usr/share/nginx/html
 ---> Using cache
 ---> b8c178b653b9
Successfully built b8c178b653b9
```


## A Dockerfile
```
FROM        ubuntu:14.04
MAINTAINER  Matthias Luebken <matthias@giantswarm.io>

# To manually trigger cache invalidation
ENV build_date 2014-09-01

RUN apt-get update
RUN apt-get install -y nginx

RUN echo 'Hello world' > /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
```


## Dockerfile instructions 1

* `FROM` the parent image
* `MAINTAINER` the maintainer of this Dockerfile (optional)
* `RUN <command>` run the command during build time with '/bin/sh -c'
* `EXPOSE <port>` expose a specific port on the container
* `ADD <files>` add files from the build environment into the image with tar extraction
* `ENV <variable>` set environment variables
* `CMD ["<command>", "<arg 1>", "<arg 2>"]` run the commands when container is launched. Can be overwritten via the command line


## Dockerfile instructions 2

* `WORKDIR <dir>` set the working directory for `RUN` and `CMD/ENTRYPOINT`
* `USER <user>` specifies the USER 
* `VOLUME ["<dir>"]` adds a volume to a container
* `ONBUILD <build instruction>` execute the instruction when child image is 
* `ENTRYPOINT ["<command>", "<arg 1>", "<arg 2>"]` run the commands when container is launched. Command line args will be passed on.


## Excercise 4

1. Build a plain nginx image with a new Dockerfile<br>
   Check with localhost:8000
2. Add a custom index.html
3. Check nginx configuration during build time <br>
   `nginx -t`
4. Ensure that your build breaks with a broken config
5. Add custom logging<br>
```
# /etc/nginx/conf.d/logging.conf
    access_log /run/nginx/access.log;
    error_log /run/nginx/error.log;
```

<!--
Solution:

# Dockerfile
FROM nginx
ADD www /var/www/html

RUN nginx -t

ADD ./logging.conf /etc/nginx/conf.d/logging.conf
RUN mkdir /run/nginx

# logging.conf
access_log /run/nginx/access.log;
error_log /run/nginx/error.log;

# www/index.html
Hallo Docker Workshop!
-->
