# Building your own image


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


## Dockerfile instructions
* `FROM` the parent image
* `MAINTAINER` the maintainer of this Dockerfile (optional)
* `RUN <command>` run the command during build time with '/bin/sh -c'
* `RUN ["<command>", "<arg 1>", "<arg 2>"]` run the command during build time as is (exec format)
* `EXPOSE <port>` expose a specific port on the container
* `CMD ["<command>", "<arg 1>", "<arg 2>"]` run the commands when container is launched. Can be overwritten via the command line
* `ENTRYPOINT ["<command>", "<arg 1>", "<arg 2>"]` run the commands when container is launched. Command line args will be passed on.
* `WORKDIR <dir>` set the working directory for `RUN` and `CMD/ENTRYPOINT`
* `ENV <variable>` set environment variables
* `USER <user>` specifies the USER 
* `VOLUME ["<dir>"]` adds a volume to a container
* `ADD <files>` add files from the build environment into the image with tar extraction
* `COPY <files>` same as ADD without the extraction
* `ONBUILD <build instruction>` execute the instruction when child image is build