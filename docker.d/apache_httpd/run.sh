#!/bin/bash

if [[ ! -d /data/apache2-jk-config ]]; then
	mkdir /data/apache2-jk-config
fi

# embed workers.properties
F_HOST=/data/apache2-jk-config/workers.properties
F_CONT=/etc/libapache2-mod-jk/workers.properties

if [[ ! -f $F_HOST ]]; then
	touch $F_HOST
fi

ID=$(docker run \
	--detach 	\
	-v $F_HOST:$F_CONT \
	-v /data/apache2-log/:/var/log/apache2/ \
	-p 127.0.0.1:6000:80   \
	--name apache2 \
	syncpoint/apache2
)

echo started apache in $ID

docker port $ID 80
 
