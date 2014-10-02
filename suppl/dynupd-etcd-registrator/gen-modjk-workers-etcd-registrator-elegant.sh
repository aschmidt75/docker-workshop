#!/bin/bash

# config generator
source dynupd.source

# gen-modjk-workers-etc-registrator-elegant.sh
# generate a new mod_jk config based on ectd config.
# use the registrator scheme
IDS=$(etcdctl ls ${ETCD_KEY}/${APP_NAME} | grep "${JK_TARGET_FILE_PORT}")

#NUM_WORKERS=$(echo $IDS | wc -w)
#echo Found $NUM_WORKERS containers.

echo "worker.list=loadbalancer,jk-status" >$JK_TARGET_FILE
echo "worker.loadbalancer.type=lb" >>$JK_TARGET_FILE
echo "worker.loadbalancer.sticky_session=false" >>$JK_TARGET_FILE
echo "worker.loadbalancer.method=B" >>$JK_TARGET_FILE

# config status work
echo "worker.jk-status.type=status" >>$JK_TARGET_FILE
echo "worker.jk-status.read_only=true" >>$JK_TARGET_FILE

echo "worker.template.type=ajp13" >>$JK_TARGET_FILE
echo "worker.template.connection_pool_timeout=300" >>$JK_TARGET_FILE
echo "worker.template.connection_pool_minsize=0" >>$JK_TARGET_FILE
echo "worker.template.max_reply_timeouts=10" >>$JK_TARGET_FILE
echo "worker.template.reply_timeout=5000" >>$JK_TARGET_FILE
echo "worker.template.lbfactor=1" >>$JK_TARGET_FILE
echo "worker.template.retries=2" >>$JK_TARGET_FILE
echo "worker.template.activation=A" >>$JK_TARGET_FILE
# auto recover HEAD/GET request
# don't recover all other request
# close after failure
echo "worker.template.recovery_options=31" >>$JK_TARGET_FILE

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

	echo ${WORKER}.reference=worker.template >>$JK_TARGET_FILE
	echo ${WORKER}.host=$HOST >>$JK_TARGET_FILE
	echo ${WORKER}.port=$PORT >>$JK_TARGET_FILE
	echo "worker.loadbalancer.balance_workers=$CONTAINER_NAME" >>$JK_TARGET_FILE

	I=$(($I+1))
done


#cat $JK_TARGET_FILE
