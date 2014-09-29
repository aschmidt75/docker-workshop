docker-workshop
=========================

includes

 * Puppet module garethr/puppet, manages
 * demo user (pwd: demo) in docker group w/ sudo
 * bridge utils
 * apache2 installed and running
 * nsenter
 * fig
 * docker-squash
 * docker registry
   * configured as mirror-proxy to public docker hub
   * contains images for ubuntu:latest and busybox:latest
   * demo images from rossbachp
 * serverspec
   * spec for all items above 
 * etcd
 * registrator from progrium
 * ufw is stopped
 

todos:
 * apache2 does not yet serve files from /data/static

License
=======
The MIT License (MIT)
Copyright (c) 2014 Andreas Schmidt
