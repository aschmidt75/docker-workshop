# 5) Volumes


## Volumes

* For persisted and shared data
* A special directory that bypasses the Union File System
* Volumes can be shared between containers
* Changes to a volume are immediate
* Volumes persist until no containers uses them


## docker run -v
```
# also doable with VOLUME in your Dockerfile
docker run -v <containerpath> ...

# only on docker run
docker run -v <hostpath>:<containerpath> ...
```


## Volume container

* Volumes live as long as a container uses them (running or stopped)
* They get deleted if you clean up your containers (`docker rm`).
* To persist data, they must live outside of the container
  1. Use `-v <host>:<path>` to manually manage your volumes
  2. Use a separate container to store the data


## Excercise 5a

Based on solution from exercise 4. 

1. Extend the Dockerfile to specify a new volume at `/mnt/logs`. 
2. Change your config files to write to the new folder.
3. Start your container, open the index file in your browser.
4. Start a new container with `--volumes-from` to tail the logfile.

<!--
Solution 5a:
# Dockerfile
FROM nginx
ADD www /var/www/html

RUN nginx -t

ADD ./logging.conf /etc/nginx/conf.d/logging.conf
RUN mkdir /run/nginx
VOLUME /mnt/logs

# logging.conf
access_log /mnt/logs/access.log;
error_log /mnt/logs/error.log;

# Shell
docker run -v /tmp/thecontainerlogs:/mnt/logs <image>
tail -f /tmp/thecontainerlogs/access.log
-->


## Exercise 5b - Data container
1. Start a data container with a volume at `/mnt/logs`
2. Start the nginx image with `--volumes-from=<fist container>`
3. Make a request and examine the logs
4. Restart the nginx and check old log entries
