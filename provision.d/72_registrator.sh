if [[ ! -x /usr/local/bin/registrator ]]; then
	cd /tmp
	mkdir registrator-install
	cd registrator-install
	wget --quiet https://github.com/progrium/registrator/releases/download/v0.4.0/registrator_0.4.0_linux_x86_64.tgz
	tar xfvz ./registrator_0.4.0_linux_x86_64.tgz && rm ./registrator_0.4.0_linux_x86_64.tgz
	#git clone https://github.com/progrium/registrator
	sudo cp ./registrator /usr/local/bin
	# start
	touch /usr/local/bin/start_registrator.sh
	chmod +x /usr/local/bin/start_registrator.sh
	echo 'sudo su - -c "killall registrator >/dev/null 2>&1; /usr/local/bin/registrator etcd:///tomcat8 >/var/log/registrator.log 2>&1 &" ' >/usr/local/bin/start_registrator.sh
fi

/usr/local/bin/start_registrator.sh

