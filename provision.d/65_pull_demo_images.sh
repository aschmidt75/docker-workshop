# pull images directly on vm, tag for local registry and push to registry

DOCKER_IMAGES="ubuntu:latest busybox:latest rossbachp/tomcat8:latest rossbachp/presentation:latest dockerfile/java:oracle-java8 dockerfile/nginx:latest progrium/registrator"
LOCAL_URL=127.0.0.1:5000

for DOCKER_IMAGE in $DOCKER_IMAGES; do
  echo -- processing $DOCKER_IMAGE
  docker pull $DOCKER_IMAGE
  R=$LOCAL_URL/$DOCKER_IMAGE
  docker tag $DOCKER_IMAGE $R
  docker push $R
done

# delete some images, so we can show docker pull
docker rmi busybox:latest
