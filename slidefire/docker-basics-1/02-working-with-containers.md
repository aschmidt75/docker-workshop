# 2) Working with containers


## docker run

```
# run a command in a container
$ docker run ubuntu echo helloworld
helloworld
```


## docker run again

```
# run an interactive command
$ docker run -it ubuntu /bin/bash
root@be9db7f93391:/# hostname
be9db7f93391
```

```
# run a while loop in a deamonized container
$ docker run -d ubuntu /bin/bash -c "while true; do echo hello; sleep 1; done"
cf1417763edad98420e2b26fd1a55fec0ea88c6c404449eb647322f6fa9c364b
$ docker ps
CONTAINER ID        IMAGE                         COMMAND                CREATED             STATUS              PORTS               NAMES
cf1417763eda        127.0.0.1:5000/ubuntu:14.04   "/bin/bash -c 'while   4 seconds ago       Up 4 seconds                            cocky_wilson
```

```
# name a cointainer
$ docker run --name mycontainer -i -t ubuntu /bin/bash
```


## docker ps

```
# List running container
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

# List all container
$ docker ps -a
CONTAINER ID        IMAGE                         COMMAND                CREATED             STATUS                         PORTS               NAMES
cf1417763eda        127.0.0.1:5000/ubuntu:14.04   "/bin/bash -c 'while   29 seconds ago      Up 29 seconds                                      cocky_wilson
be9db7f93391        127.0.0.1:5000/ubuntu:14.04   "/bin/bash"            23 minutes ago      Exited (130) 17 minutes ago                        desperate_goldstine
```


## docker {kill, stop, start}

```bash
# Kill a container (SIGKILL)
$ docker kill 8003a50512e9
8003a50512e9
```

```bash
# Stop a container (SIGTERM)
$ docker stop mycontainer
```

```bash
# Start a container
$ docker start mycontainer
```


## docker rm

```
# Remove a container
$ docker rm mycontainer
```

```
# Remove all containers
$ docker rm $(docker ps -a -q)
```


## docker {logs, top, inspect}

```
# Show and follow STDOUT and STDERR
$ docker logs --follow mycontainer 
```

```
# Show running processes
$ docker top mycontainer
```

```
# More information about a container
$ docker inspect mycontainer
```


## Excercise 2a

1. Print `hello-wjax with a Docker container
2. Start a bash in a container and remove the `ls` command
3. Start a background container with a while loop
4. {Examine, stop, start} that container
5. Enter that container with `docker exec`


## Excercise 2b

1. Start the nginx container and publish the port 80 to 8000.
2. Verify it in you browser.
