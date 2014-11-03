#!/bin/bash
NAME=rossbachp/scale-tomcat-deck
docker build -t="$NAME" .
DATE=`date +'%Y%m%d%H%M'`
ID=$(docker inspect -f "{{.Id}}" "$NAME")
docker tag $ID "$NAME:$DATE"
docker push $NAME
