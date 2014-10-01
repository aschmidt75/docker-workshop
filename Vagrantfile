# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Ubuntu 14.04 (trusty tahr, 64bit)
  config.vm.box 	= 'trusty64'
  config.vm.box_url 	= "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.hostname 	= 'docker-workshop'

  config.vm.define "docker-workshop-vm", primary: true do |s|
    # mount our specs into vm, run serverspec locally
    s.vm.synced_folder "spec.d/", "/mnt/spec.d"
    s.vm.synced_folder "docker.d/", "/mnt/docker.d"
    s.vm.synced_folder "suppl/dynupd-etc-registrator", "/mnt/dynupd"

    s.vm.provider "virtualbox" do |vb|
    	vb.gui = false
        vb.customize [ "modifyvm", :id, "--memory", "1024"]
        vb.customize [ "modifyvm", :id, "--cpus", "1"]
    end

    s.vm.provision "shell", inline:
	    'sudo su - -c "killall -9 apt-get >/dev/null 2>&1; apt-get update -yqq"'

    # -- PART Microservices
    # download stuff we need as packages, so we do not need
    # wifi during the workshop
    s.vm.provision 'shell', inline: <<EOS
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
	wget --input-file /tmp/apache2-pkglist
	touch /tmp/.apache2.downloaded
fi

EOS

    # install puppet module for docker
    # image already contains puppet
    s.vm.provision "shell", inline:
	    'sudo su - -c "( puppet module list | grep -q garethr-docker ) || puppet module install -v 1.1.3 garethr-docker"'

    # provision the node
    s.vm.provision :puppet, :options => "--verbose" do |puppet|
 	puppet.manifests_path = "puppet.d/manifests"
	puppet.module_path = "puppet.d/modules"
        puppet.manifest_file = "default.pp"
    end

    # demo user fix
    s.vm.provision "shell", inline:
	    'sudo usermod -G docker demo'

    # install nsenter
    # from: https://blog.codecentric.de/2014/07/vier-wege-in-den-docker-container/
    s.vm.provision 'shell', inline: <<EOS
if [[ -z `which nsenter` ]]; then
	TMPDIR=`mktemp -d` && {
		cd $TMPDIR
		curl --silent https://www.kernel.org/pub/linux/utils/util-linux/v2.24/util-linux-2.24.tar.gz | tar -zxf-
		cd util-linux-2.24
		./configure --without-ncurses
		make nsenter
		sudo cp nsenter /usr/local/bin
		rm -fr $TMPDIR
    	}
fi
EOS

    # Install fig via pip
    s.vm.provision 'shell', inline: <<EOS
echo == Ensure fig is installed
PIP_=$(which pip)
if [[ -z $PIP_ ]]; then
	sudo apt-get -yqq install python-pip
fi
pip --version
FIG_=$(which fig)
if [[ -z $FIG_ ]]; then
	pip install fig
fi
fig --version
EOS

    # download and unpack docker squash
    # https://github.com/jwilder/docker-squash
    s.vm.provision 'shell', inline: <<EOS
DS_=$(which docker-squash)
if [[ -z $DS_ ]]; then
	wget https://github.com/jwilder/docker-squash/releases/download/v0.0.8/docker-squash-linux-amd64-v0.0.8.tar.gz
	sudo tar -C /usr/local/bin -xzvf docker-squash-linux-amd64-v0.0.8.tar.gz
	rm docker-squash-linux-amd64-v0.0.8.tar.gz
fi
EOS

    # download and set up registry
    s.vm.provision 'shell', inline: <<EOS
sysctl vm.overcommit_memory=1
docker images | grep -wq -E '^registry' || sudo docker pull registry:latest

if [[ ! -d /data ]]; then
	sudo mkdir /data
	sudo chmod -R g+wx /data
	sudo chgrp -R vagrant /data
fi
if [[ ! -d /data/registry ]]; then
	sudo mkdir /data/registry
	sudo chgrp -R docker /data/registry
fi
if [[ ! -d /data/static_images ]]; then
	sudo mkdir /data/static_images
	sudo chgrp -R vagrant /data/static_images
fi

touch /usr/local/bin/start_registry.sh
chmod +x /usr/local/bin/start_registry.sh
echo '#!/bin/bash' >/usr/local/bin/start_registry.sh
echo 'docker run -d -p 127.0.0.1:5000:5000 -u root -v /data/registry:/data -e STORAGE_PATH=/data -e MIRROR_SOURCE=https://registry-1.docker.io -e MIRROR_SOURCE_INDEX=https://index.docker.io --name registry registry' >>/usr/local/bin/start_registry.sh

#
(docker ps registry | grep -wq registry.*Up) || /usr/local/bin/start_registry.sh
sleep 10

EOS

    # pull demo image(s) through our private registry
    s.vm.provision 'shell', inline: <<EOS
docker pull 127.0.0.1:5000/ubuntu:14.04
docker tag 127.0.0.1:5000/ubuntu:14.04 ubuntu:14.04
docker tag 127.0.0.1:5000/ubuntu:14.04 ubuntu:latest
docker pull 127.0.0.1:5000/busybox:latest
docker tag 127.0.0.1:5000/busybox:latest busybox:latest
docker pull 127.0.0.1:5000/rossbachp/tomcat8
docker tag 127.0.0.1:5000/rossbachp/tomcat8:latest rossbachp/tomcat8:latest
EOS

    # get us some etcd
    s.vm.provision 'shell', inline: <<EOS
if [[ ! -x /usr/local/bin/etcd ]]; then
	cd /tmp
	mkdir etcd-install
	cd etcd-install
	wget https://github.com/coreos/etcd/releases/download/v0.4.6/etcd-v0.4.6-linux-amd64.tar.gz
	tar xfvz etcd-v0.4.6-linux-amd64.tar.gz
	sudo cp etcd-v0.4.6-linux-amd64/etcd /usr/local/bin
	sudo cp etcd-v0.4.6-linux-amd64/etcdctl /usr/local/bin
	# start etcd
	touch /usr/local/bin/start_etcd.sh
	chmod +x /usr/local/bin/start_etcd.sh
	echo 'sudo su - -c "killall etcd >/dev/null 2>&1; /usr/local/bin/etcd -v >/var/log/etcd.log 2>&1 &" ' >/usr/local/bin/start_etcd.sh
fi
/usr/local/bin/start_etcd.sh
EOS

    # and progriums' registrator as well
    s.vm.provision 'shell', inline: <<EOS
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

EOS

    # install & run serverspec
    s.vm.provision 'shell', inline: <<EOS
( sudo gem list --local | grep -q rake ) || {
	sudo gem install rake -v '10.3.2' --no-ri --no-rdoc
}
( sudo gem list --local | grep -q rspec ) || {
	sudo gem install rspec -v '2.99.0' --no-ri --no-rdoc
}
( sudo gem list --local | grep -q specinfra ) || {
	sudo gem install specinfra -v '1.21.0' --no-ri --no-rdoc
}
( sudo gem list --local | grep -q serverspec ) || {
	sudo gem install serverspec -v '1.10.0' --no-ri --no-rdoc
}
EOS
    s.vm.provision 'shell', inline: <<EOS
cd /mnt/spec.d
rake spec
EOS

  end

end
