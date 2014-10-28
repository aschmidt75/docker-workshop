if [[ ! -x /usr/local/bin/etcd ]]; then
	cd /tmp
	mkdir etcd-install
	cd etcd-install
	wget --quiet https://github.com/coreos/etcd/releases/download/v0.4.6/etcd-v0.4.6-linux-amd64.tar.gz
	tar xfvz etcd-v0.4.6-linux-amd64.tar.gz
	sudo cp etcd-v0.4.6-linux-amd64/etcd /usr/local/bin
	sudo cp etcd-v0.4.6-linux-amd64/etcdctl /usr/local/bin
	# start etcd
	touch /usr/local/bin/start_etcd.sh
	chmod +x /usr/local/bin/start_etcd.sh
	echo 'sudo su - -c "killall etcd >/dev/null 2>&1; /usr/local/bin/etcd -v >/var/log/etcd.log 2>&1 &" ' >/usr/local/bin/start_etcd.sh
fi
/usr/local/bin/start_etcd.sh
