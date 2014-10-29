grep -wq Korrektes /home/demo/.bashrc
if [[ $? -ne 0 ]]; then
	echo "echo '-- Korrektes Keyboard-Layout einstellen: '" >>/home/demo/.bashrc
	echo "echo 'sudo apt-get install console-common'" >>/home/demo/.bashrc
	echo "echo 'sudo dpkg-reconfigure console-common'" >>/home/demo/.bashrc
	echo "echo 'in GUI > Select from Full List > mac/german/macbook oder pc/quertz/german/Standard/latin1 no dead keys'" >>/home/demo/.bashrc
fi

