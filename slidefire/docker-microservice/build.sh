#!/bin/bash
NAME=rossbachp/autoscaling-apache-tomcat-slides
docker build -t="$NAME" .
DATE=`date +'%Y%m%d%H%M'`
ID=$(docker inspect -f "{{.Id}}" "$NAME")
docker tag $ID "$NAME:$DATE"
docker push $NAME
