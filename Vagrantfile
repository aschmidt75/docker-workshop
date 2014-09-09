# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Ubuntu 14.04 (trusty tahr, 64bit)
  config.vm.box 	= 'trusty64'
  config.vm.box_url 	= "http://cloud-images.ubuntu.com/vagrant/trusty/20140723/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.hostname 	= 'docker-workshop'

  config.vm.define "docker-workshop-vm", primary: true do |s|
    # mount our specs into vm, run serverspec locally
    s.vm.synced_folder "spec.d/", "/mnt/spec.d"

    s.vm.provision "shell", inline:
	    'sudo su - -c "killall -9 apt-get; apt-get update -yqq"'

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
#if [[ ! -f /data/static_images/registry-latest-image.tar ]]; then
#	echo saving image ...
#	sudo docker save -o /data/static_images/registry-latest-image.tar registry
#	sudo chown vagrant. /data/static_images/registry-latest-image.tar
#fi

touch /usr/local/bin/start_registry.sh
chmod +x /usr/local/bin/start_registry.sh
echo '#!/bin/bash' >/usr/local/bin/start_registry.sh
echo 'docker run -d -p 127.0.0.1:5000:5000 -u root -v /data/registry:/data -e STORAGE_PATH=/data -e MIRROR_SOURCE=https://registry-1.docker.io -e MIRROR_SOURCE_INDEX=https://index.docker.io --name registry registry' >>/usr/local/bin/start_registry.sh

#
(docker ps registry | grep -wq registry.*Up) || /usr/local/bin/start_registry.sh

EOS

    # pull demo image(s) through our private registry
    s.vm.provision 'shell', inline: <<EOS
docker pull 127.0.0.1:5000/ubuntu:14.04
docker tag 127.0.0.1:5000/ubuntu:14.04 ubuntu:14.04
docker tag 127.0.0.1:5000/ubuntu:14.04 ubuntu:latest
docker pull 127.0.0.1:5000/busybox:latest
docker tag 127.0.0.1:5000/busybox:latest busybox:latest
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
cd /mnt/spec.d
rake spec

EOS

  end
  
end
