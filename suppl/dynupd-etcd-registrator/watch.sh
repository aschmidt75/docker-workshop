#!/bin/bash

source dynupd.source

# watch.sh
# Endlosschleife:
# ruft etcdctl watch auf, welches terminiert, sobald sich im Applikationszweig
# des etcd etwas ändert. Daraufhin wird die Konfiguation erneuert. Der Apache container wird neugestartet

while true; do
	echo -n "."
	etcdctl watch --recursive ${ETCD_KEY}/${APP_NAME} >/dev/null
	echo -n "+"

	sleep 2
	./gen-modjk-workers-etcd-registrator.sh
	docker restart apache2 >/dev/null
done
