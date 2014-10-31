if [[ ! -d /data ]]; then
	sudo mkdir /data
	sudo chmod -R g+wx /data
	sudo chgrp -R vagrant /data
fi
if [[ ! -d /data/packages ]]; then
	sudo mkdir /data/packages
	sudo chmod a+rwx /data/packages
fi

which wget || sudo apt-get install wget

if [[ ! -f /tmp/.apache2.downloaded ]]; then
	>/tmp/apache2-pkglist
	for p in apache2 apache2-bin apache2-data libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap ssl-cert libapache2-mod-jk openssl libldap-2.4-2 apache2-api-20120211 libxml2 libgssapi3-heimdal libsasl2-2 libsasl2-modules-db libasn1-8-heimdal libhcrypto4-heimdal libheimntlm0-heimdal libkrb5-26-heimdal libroken18-heimdal libheimbase1-heimdal libhx509-5-heimdal libwind0-heimdal; do
		sudo apt-get --print-uris --yes download $p | grep -E "http" | tr -d "\'" | awk '{ print $1 }' >>/tmp/apache2-pkglist
	done
	cd /data/packages
	cat /tmp/apache2-pkglist
	wget --quiet --input-file /tmp/apache2-pkglist
	touch /tmp/.apache2.downloaded
fi

sudo cp /mnt/docker.d/apache_httpd/* /data/packages
cd /data/packages
./build.sh

