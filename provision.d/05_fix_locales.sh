#
#sudo apt-get install console-common
sudo locale-gen de_DE.UTF-8
sudo update-locale LANG=de_DE.UTF-8

>/etc/default/locale
sudo echo 'LANG=de_DE.UTF-8' >>/etc/default/locale
sudo echo 'LC_MESSAGES=POSIX' >>/etc/default/locale

locale -a
locale

