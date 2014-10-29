# Running in containers


## Running a command in a container

```
$ docker run ubuntu echo helloworld
helloworld
```

```
$ docker help run

Usage: docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

Run a command in a new container
...
```


## Running an interactive command in a container

```
$ docker run -it ubuntu /bin/bash
root@be9db7f93391:/# ps
  PID TTY          TIME CMD
    1 ?        00:00:00 bash
   17 ?        00:00:00 ps
root@be9db7f93391:/# hostname
be9db7f93391
```


## Starting a background container

```
$ docker run -d ubuntu /bin/bash -c "while true; do echo hello; sleep 1; done"
cf1417763edad98420e2b26fd1a55fec0ea88c6c404449eb647322f6fa9c364b
$ docker ps
CONTAINER ID        IMAGE                         COMMAND                CREATED             STATUS              PORTS               NAMES
cf1417763eda        127.0.0.1:5000/ubuntu:14.04   "/bin/bash -c 'while   4 seconds ago       Up 4 seconds                            cocky_wilson
```


## Listing containers
* `docker ps -a` List all containers

```
$ docker ps -a
CONTAINER ID        IMAGE                         COMMAND                CREATED             STATUS                         PORTS               NAMES
cf1417763eda        127.0.0.1:5000/ubuntu:14.04   "/bin/bash -c 'while   29 seconds ago      Up 29 seconds                                      cocky_wilson
be9db7f93391        127.0.0.1:5000/ubuntu:14.04   "/bin/bash"            23 minutes ago      Exited (130) 17 minutes ago                        desperate_goldstine
```


## Stopping and restarting a container
* `docker stop CONTAINER` Stop a container (SIGTERM)
* `docker kill CONTAINER` Kill a container (SIGKILL)
* `docker run --name mycontainer -i -t ubuntu /bin/bash` Naming the container
* `docker start CONTAINER` Starting a stopped container by name or id


## Attaching
* `docker attach CONTAINER` Attaching to a container
* `Ctrl-p + Ctrl-q` Detach from a container


## Information about a container
* `docker logs --follow mycontainer` Show and follow STDOUT and STDERR
* `docker top mycontainer` Show running processes
* `docker inspect mycontainer` More information about a container


## Remove a container
* `docker rm CONTAINER` Remove a container
* `docker rm $(docker ps -a -q)` Remove all container
# Run options
* `docker run [OPTIONS] IMAGE [COMMAND] [ARG...]`
* `-i -t` Keep STDIN open attach a pseudo-TTY
* `-p <hostport>:<containerport` Publish a specfic port
* `-P` Publish all exposed ports to the host interfaces
* `-t` Tag a build
* `-d` Detached mode: run container in the background
* `-e` Set environment variables


