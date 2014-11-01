DS_=$(which docker-squash)
if [[ -z $DS_ ]]; then
	wget --quiet https://github.com/jwilder/docker-squash/releases/download/v0.0.10/docker-squash-linux-amd64-v0.0.10.tar.gz
	sudo tar -C /usr/local/bin -xzvf docker-squash-linux-amd64-v0.0.10.tar.gz
	rm docker-squash-linux-amd64-v0.0.10.tar.gz
fi
