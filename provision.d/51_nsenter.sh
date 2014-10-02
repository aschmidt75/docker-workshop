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
if [[ -z `which docker-enter` ]]; then
  sudo cp /mnt/bin/docker-enter /usr/local/bin
  chmod +x /usr/local/bin/docker-enter
fi
