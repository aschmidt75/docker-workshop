#!/bin/bash
DATE=`date +'%Y%m%d%H%M'`
DECK=scale-tomcat-deck
EDITION_TAG=wjax2014
if [ ! "x" == "x`docker ps -a | grep $DECK`" ]; then
  docker stop $DECK
  docker rm $DECK
fi

mkdir -p build
BASE=`pwd`
mkdir -p build/md
cp slides.md build/md
docker run -ti --rm -v $BASE/images:/opt/presentation/images -v  $BASE/build/md:/opt/presentation/lib/md -v $BASE/build:/build -p 8000:8000 rossbachp/presentation /bin/bash -c "grunt package && mv reveal-js-presentation.zip /build/$DECK.zip"
cd build
mkdir -p $DECK
cd $DECK
#you must have zip installed - apt-get install -y zip
unzip ../$DECK.zip
cp $BASE/LICENSE .
cd ..
tar czf slidefire.tar.gz $DECK
rm -rf build/$DECK.zip
rm -rf build/$DECK
rm -rf build/md

cat <<EOT >Dockerfile
FROM rossbachp/slidefire
MAINTAINER Peter Rossbach <peter.rossbach@bee42.com>
EOT
docker build -t=rossbachp/$DECK .
docker tag --force=true rossbachp/$DECK rossbachp/$DECK:$EDITION_TAG
docker tag --force=true rossbachp/$DECK rossbachp/$DECK:$DATE
