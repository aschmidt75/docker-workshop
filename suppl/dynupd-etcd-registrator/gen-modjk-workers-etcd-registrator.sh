#!/bin/bash

source dynupd.source

# gen-modjk-workers-etc-registrator.sh
# Generiert die mod_jk-Konfiguration neu.
# Die Informationen zur Weiterleitung stammen ausschließlich
# aus etcd (über registrator) und werden über etcdctl abgefragt.

# finde Applikation über die Schlüssel
IDS=$(etcdctl ls ${ETCD_KEY}/${APP_NAME} | grep "${JK_TARGET_FILE_PORT}")

NUM_WORKERS=$(echo $IDS | wc -w)
#echo Found $NUM_WORKERS containers.

>"$JK_TARGET_FILE"
echo 'workers.tomcat_home=/usr/share/tomcat6
workers.java_home=/usr/lib/jvm/default-java
ps=/
' >>"$JK_TARGET_FILE"
WORKERS_LIST=""
for ID in $IDS; do

	CONTAINER_NAME=$(echo $ID | tr '/:' '  ' | awk '{ print $(NF-1) }')

	if [[ -z $WORKERS_LIST ]]; then
		WORKERS_LIST="$CONTAINER_NAME"
	else
		WORKERS_LIST="$WORKERS_LIST,$CONTAINER_NAME"
	fi
done
echo "worker.list=loadbalancer" >>$JK_TARGET_FILE
echo "worker.loadbalancer.type=lb" >>$JK_TARGET_FILE
echo "worker.loadbalancer.sticky_session=false" >>$JK_TARGET_FILE
echo "worker.loadbalancer.balance_workers=$WORKERS_LIST" >>$JK_TARGET_FILE


# for each ID ..
I=1
for ID in $IDS; do
	# get port forwarding
	CONTAINER_NAME=$(echo $ID | tr '/:' '  ' | awk '{ print $(NF-1) }')
	FORWARDING=$(etcdctl get $ID)
	# split host/port
	HOST=$(echo $FORWARDING | awk -F':' '{ print $1 }')
	HOST=172.17.42.1
	PORT=$(echo $FORWARDING | awk -F':' '{ print $2 }')

	WORKER="worker.$CONTAINER_NAME"

	echo ${WORKER}.type=ajp13 >>$JK_TARGET_FILE
	echo ${WORKER}.lbfactor=1 >>$JK_TARGET_FILE
	echo ${WORKER}.host=$HOST >>$JK_TARGET_FILE
	echo ${WORKER}.port=$PORT >>$JK_TARGET_FILE

	I=$(($I+1))
done


#cat $JK_TARGET_FILE
