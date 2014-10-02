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
