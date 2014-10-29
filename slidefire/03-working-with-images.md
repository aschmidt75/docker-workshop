# Workgin with images


* `docker images` Available images on the host
* `docker rmi IMAGE` Delete an image
* `docker pull IMAGE` Pull an image from an repository
* `docker commit CONTAINER` Create a new image from a container's changes
* `docker diff CONTAINER` Inspect changes on a container's filesystem
* `docker history IMAGE` Show the history of an image
* `docker images -viz | dot -Tpng -o docker.png` dependency graph
* `docker build PATH` Build a new image from the source path