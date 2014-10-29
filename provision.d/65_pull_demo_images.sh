docker pull 127.0.0.1:5000/ubuntu:14.04
docker tag 127.0.0.1:5000/ubuntu:14.04 ubuntu:14.04
docker tag 127.0.0.1:5000/ubuntu:14.04 ubuntu:latest
docker pull 127.0.0.1:5000/busybox:latest
#docker tag 127.0.0.1:5000/busybox:latest busybox:latest
docker rmi busybox
docker pull 127.0.0.1:5000/rossbachp/tomcat8
docker tag 127.0.0.1:5000/rossbachp/tomcat8:latest rossbachp/tomcat8:latest
docker pull 127.0.0.1:5000/dockerfile/java:oracle-java8
docker pull 127.0.0.1:5000/dockerfile/nginx
docker tag 127.0.0.1:5000/dockerfile/nginx:latest nginx:latest

docker pull 127.0.0.1:5000/progrium/registrator
docker tag 127.0.0.1:5000/progrium/registrator:latest progrium/registrator:latest

docker pull 127.0.0.1:5000/rossbachp/presentation
docker tag 127.0.0.1:5000/rossbachp/presentation:latest rossbachp/presentation:latest
