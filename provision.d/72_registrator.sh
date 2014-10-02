if [[ ! -x /usr/local/bin/registrator ]]; then
	cd /tmp
	mkdir registrator-install
	cd registrator-install
	git clone https://github.com/progrium/registrator
	sudo cp registrator/stage/registrator /usr/local/bin
	# start
	touch /usr/local/bin/start_registrator.sh
	chmod +x /usr/local/bin/start_registrator.sh
	echo 'sudo su - -c "killall registrator >/dev/null 2>&1; /usr/local/bin/registrator etcd:///tomcat8 >/var/log/registrator.log 2>&1 &" ' >/usr/local/bin/start_registrator.sh
fi

/usr/local/bin/start_registrator.sh

