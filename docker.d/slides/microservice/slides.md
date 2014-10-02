# Scaling Apache Tomcat at docker based infrastructure

* [<andreas.schmidt@cassini.de>](mailto:andreas.schmidt@cassini.de)
* [<peter.rossbach@bee42.com>](mailto:peter.rossbach@bee42.com)

---
## Start the apache installation inside fresh container

```bash
$ vagrant up
$ vagrant ssh
$ docker run -ti -v /data/packages:/mnt ubuntu /bin/bash
root@26936f69cc5b:/#
```
***
Yummie, know lets dance really __step by step__!

--
###  content of `/data/packages`
```bash
$ ls /data/packages
apache2_2.4.7-1ubuntu4.1_amd64.deb
apache2-bin_2.4.7-1ubuntu4.1_amd64.deb
apache2-data_2.4.7-1ubuntu4.1_all.deb
libapache2-mod-jk_1.2.37-3_amd64.deb
libapr1_1.5.0-1_amd64.deb
libaprutil1_1.5.3-1_amd64.deb
libaprutil1-dbd-sqlite3_1.5.3-1_amd64.deb
libaprutil1-ldap_1.5.3-1_amd64.deb
libasn1-8-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb
libgssapi3-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb
libhcrypto4-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb
libheimbase1-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb
libheimntlm0-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb
libhx509-5-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb
libkrb5-26-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb
libldap-2.4-2_2.4.31-1+nmu2ubuntu8_amd64.deb
libroken18-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb
libsasl2-2_2.1.25.dfsg1-17build1_amd64.deb
libsasl2-modules-db_2.1.25.dfsg1-17build1_amd64.deb
libwind0-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb
libxml2_2.9.1+dfsg1-3ubuntu4.3_amd64.deb
openssl_1.0.1f-1ubuntu2.5_amd64.deb
ssl-cert_1.0.33_all.deb
```

--
### Now install packages super fast from local disk!
```bash
$ cd /mnt
$ dpkg -i *.deb
...
$ which apache
/usr/sbin/apache2
```
--
### check apache

```bash
$ sudo mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/apache2
$ /bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apache2 -V"
Server version: Apache/2.4.7 (Ubuntu)
Server built:   Jul 22 2014 14:36:38
Server's Module Magic Number: 20120211:27
Server loaded:  APR 1.5.1-dev, APR-UTIL 1.5.3
Compiled using: APR 1.5.1-dev, APR-UTIL 1.5.3
Architecture:   64-bit
Server MPM:     event
  threaded:     yes (fixed thread count)
    forked:     yes (variable process count)
Server compiled with....
 -D APR_HAS_SENDFILE
 -D APR_HAS_MMAP
 -D APR_HAVE_IPV6 (IPv4-mapped addresses enabled)
 -D APR_USE_SYSVSEM_SERIALIZE
 -D APR_USE_PTHREAD_SERIALIZE
 -D SINGLE_LISTEN_UNSERIALIZED_ACCEPT
 -D APR_HAS_OTHER_CHILD
 -D AP_HAVE_RELIABLE_PIPED_LOGS
 -D DYNAMIC_MODULE_LIMIT=256
 -D HTTPD_ROOT="/etc/apache2"
 -D SUEXEC_BIN="/usr/lib/apache2/suexec"
 -D DEFAULT_PIDLOG="/var/run/apache2.pid"
 -D DEFAULT_SCOREBOARD="logs/apache_runtime_status"
 -D DEFAULT_ERRORLOG="logs/error_log"
 -D AP_TYPES_CONFIG_FILE="mime.types"
 -D SERVER_CONFIG_FILE="apache2.conf"
```

--
### configure apache mod_jk support

add JkMount

```bash
$ sed -i 's/<\/VirtualHost>/\n\tJkMount \/* loadbalancer\n<\/VirtualHost>/g' /etc/apache2/sites-enabled/000-default.conf
```
--

## Copy the worker properties - We must replace this wrong config :)

```bash
root@26936f69cc5b:/# grep -v '#' /etc/libapache2-mod-jk/workers.properties | sed '/^$/d'
workers.tomcat_home=/usr/share/tomcat6
workers.java_home=/usr/lib/jvm/default-java
ps=/
worker.list=ajp13_worker
worker.ajp13_worker.port=8009
worker.ajp13_worker.host=localhost
worker.ajp13_worker.type=ajp13
worker.ajp13_worker.lbfactor=1
worker.loadbalancer.type=lb
worker.loadbalancer.balance_workers=ajp13_worker

CRTL-P CRTL-Q to leave container
```
--
### Add this to your VM!

```bash
$
$ cd /data
$ mkdir apache2-jk-config
$ mkdir apache2-log
$ cd apache2-jk-config/
$ touch workers.properties
```

---
### Create an images from installed apache httpd container

```bash
$ ID=$(docker ps -l | awk '/^[0-9a-f]/{print $1}')
$ echo $ID
26936f69cc5b
$ docker commit $ID apache2:0.1
0a5a66dd5ae876b6e01ce454c4c3679d32b42980ffd97b42a2572fbb41b580f5
$ docker images | grep apache2
apache2  0.1 0a5a66dd5ae8 25 seconds ago 209.4 MB
...
```
--
### clean up install container

```bash
docker stop $ID
docker rm $ID
```

---
## Start apache form newly created image

```bash
$ docker run -ti --rm \
 -v /data/apache2-jk-config/workers.properties: \
 /etc/libapache2-mod-jk/workers.properties \
 apache2:0.1 /bin/bash
```

***
Check apache2 config

```bash
$ ls -al /etc/libapache2-mod-jk/workers.properties
...
$ grep -i jkmount /etc/apache2/sites-enabled/000-default.conf
JkMount /* loadbalancer
$ exit
```
--
## really start the apache

```bash
$ docker run -d -ti \
 -v /data/apache2-jk-config/workers.properties:\
/etc/libapache2-mod-jk/workers.properties \
 -v /data/apache2-log/:/var/log/apache2/ \
 -p 127.0.0.1:6000:80   \
 --name apache2 \
 apache2:0.1 \
 /bin/bash -c "source /etc/apache2/envvars && \
 exec /usr/sbin/apache2 -D FOREGROUND"
9794b009031d844bbb11fcea75d29a48dc79d1019e68a4610dfaea98499289d4

```

--
## check the network binding

```bash
$ wget -O - http://0.0.0.0:6000/status
 --2014-10-01 17:22:34--  http://0.0.0.0:6000/status
 Connecting to 0.0.0.0:6000... connected.
 HTTP request sent, awaiting response... 500 Internal Server Error
 2014-10-01 17:22:34 ERROR 500: Internal Server Error.
```

***
OK, we are do´nt configured and started the apache tomcat backends!

```bash
$ docker stop apache2
```
---
### Service Discovery with ETCD and Registrator to scale out!
![](images/etcd-registrator-watch.png)

  * [etcd](https://github.com/coreos/etcd)
  * [registrator](https://github.com/progrium/registrator)

--
### start ectd + registrator at your docker host (SMELL)

```bash
$ sudo /bin/bash
$ /usr/local/bin/start_etcd.sh
$ /usr/local/bin/start_registrator.sh

```
check setup

```bash
$ ps -ef |grep etcd
root      4248     1  0 17:30 ?        00:00:00 /usr/local/bin/etcd -v
...
$ ps -ef |grep registrator
root      4312     1  0 17:33 ?        00:00:00 /usr/local/bin/registrator etcd:///tomcat8
...

$ exit
$ etcdctl ls /
/tomcat8
```

--
### look at the scripts


```bash
$ cat /usr/local/bin/start_etcd.sh
sudo su - -c "killall etcd; /usr/local/bin/etcd \
 -v >/var/log/etcd.log 2>&1 &"
$ cat /usr/local/bin/start_registrator.sh
sudo su - -c "killall registrator; /usr/local/bin/registrator \
 etcd:///tomcat8 >/var/log/registrator.log 2>&1 &"
```

---
## start apache tomcat 8 container

```bash
$ docker run -tdi \
 -e "SERVICE_NAME=app" \
 --volumes-from status:ro \
 -P rossbachp/tomcat8
e2e2404b36ceb8226e0c723d18b7ea4a6d92134a79d042a6308fe4d36aea2503
```

Registrator auto setup start

```bash
$ etcdctl ls /tomcat8/app
/tomcat8/app/docker-workshop:goofy_meitner:8080
/tomcat8/app/docker-workshop:goofy_meitner:8009
# get exposed tomcat port
$ etcdctl get /tomcat8/app/docker-workshop:goofy_meitner:8009
127.0.1.1:49153
```

***
[check Dockerbox tomcat 8  project](https://github.com/rossbachp/dockerbox/tree/master/docker-images/tomcat8)

--
### Design rossbachp/tomcat8 docker image

![](images/design-tomcat8-images.png)
***
You can deploy your own webapps and tomcat extended library with local volumes or better with a docker data container.

[rossbachp/tomcat8 project](https://github.com/rossbachp/dockerbox/tree/master/docker-images/tomcat8)
--
## Goals

  * use minimal ubuntu and java8 base images (work in progress)
  * inject libs and wars as volumes (data container)
  * deploy the manager app and generate password at start
  * clean up installation and remove examples and unused `*.bat`, .. files.
  * squash footprint and clean up build artefacts
  * use a nicer access log pattern :-)
  * use a cleanup server.xml without comments
    * use separate executor
    * setup HTTP (8080) and AJP (8009) connectors and expose ports
    * currently not support APR Connectors or configure other then standard NIO
  * reuse existing cool ideas from other nice guys. Many thanks;)


---
### Create worker.properties to access tomcat from httpd

```bash
$ cd /mnt/dynupd
$ ./gen-modjk-workers-etcd-registrator.sh
$ cat /data/apache2-jk-config/workers.properties
$ docker restart apache2
```

--
### check status

```
$ curl http://127.0.0.1:6000/status/index.jsp

<html>
<body>
<h1>Docker Tomcat Status page</h1>

<ul>
  <li>Hostname : e2e2404b36ce</li>
  <li>Tomcat Version : Apache Tomcat/8.0.11</li>
  <li>Servlet Specification Version :
3.1</li>
  <li>JSP version :
2.3</li>
</ul>
</body>
```

***
Yeph, successfull access !

  * **ToDo:** add new status.war at status image! DATE!

--
### start next one

```bash
$ docker run -tdi -e "SERVICE_NAME=app" --volumes-from status:ro -P rossbachp/tomcat8
$ docker ps | grep tomcat8
f7609e148ad1        127.0.0.1:5000/rossbachp/tomcat8:201408281657-squash   "/opt/tomcat/bin/tom   5 seconds ago       Up 4 seconds        0.0.0.0:49155->8080/tcp, 0.0.0.0:49156->8009/tcp   sick_davinci
e2e2404b36ce        127.0.0.1:5000/rossbachp/tomcat8:201408281657-squash   "/opt/tomcat/bin/tom   17 minutes ago      Up 17 minutes       0.0.0.0:49153->8009/tcp, 0.0.0.0:49154->8080/tcp   goofy_meitner
$ cd /mnt/dynupd
$ ./gen-modjk-workers-etcd-registrator.sh
$ cat /data/apache2-jk-config/workers.properties
$ docker restart apache2
```

--
## check loadbalancing

```bash
$ curl http://127.0.0.1:6000/status/index.jsp
...
  <li>Hostname : e2e2404b36ce</li>
...
```

```bash
$ curl http://127.0.0.1:6000/status/index.jsp

  <li>Hostname : f7609e148ad1</li>
...
```
--
### watch and update the config

** PLEASE: Use another shell **

```bash
$ cd /mnt/dynupd
$ ./watch.sh
```

start the next tomcat and check with curl!
```bash
docker run -tdi -e "SERVICE_NAME=app" --volumes-from status:ro -P rossbachp/tomcat8
```

stop tomcat a check!
```bash
$ docker stop <tomcat container id>
```
---
### Tune the things

  * better mod_jk config
  * apache graceful restart

--
### Better mod_jk support

  * switch watch.sh off!
  * look at `get_modjk-workers-ectd-registrator-elegant.sh`
  * open the container and config mod_jk
    - patch
  * commit new image apache2 again and start
  * switch to `get_modjk-workers-ectd-registrator-elegant.sh`
--
### add jkstatus mapping

```bash
$ sudo /bin/bash
$ docker-enter <apache container-id> /bin/bash`
$ sed -i 's/<\/VirtualHost>/\n\tJkMountCopy ON\n<\/VirtualHost>/g' /etc/apache2/sites-enabled/000-default.conf
$ sed -i 's/        Allow from 127.0.0.1/        Allow from 127.0.0.1 172.17.42.1/g' /etc/apache2/mods-enabled/jk.conf
$ exit
```
--
### graceful restart apache!

```bash
$ ID=$(docker ps | grep apache2 | awk '/^[0-9a-f]/{print $1}')
$ sudo docker-enter $ID /bin/bash
$ /bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apachectl graceful"
```

check jk-status at your docker-workshop host

```bash
$ curl -s http://127.0.0.1:6000/jk-status?mime=prop | grep address
worker.goofy_meitner.address=172.17.42.1:49153
worker.sick_davinci.address=172.17.42.1:49156
```
--
### commit apache image

```bash
$ ID=$(docker ps | grep apache2 | awk '/^[0-9a-f]/{print $1}')
$ echo $ID
9794b009031d
$ docker stop $ID
$ docker commit $ID apache2:0.2
0a5a66dd5ae876b6e01ce454c4c3679d32b42980ffd97b42a2572fbb41b580f5
$ docker images | grep apache2
apache2  0.2  ae7da438a1ba  9 seconds ago  209.4 MB
...
```

--
## restart apache2
```bash
$ ID=$(docker ps | grep apache2 | awk '/^[0-9a-f]/{print $1}')
$ docker stop $ID
$ docker rm $ID
$ docker run -d -ti \
 -v /data/apache2-jk-config/workers.properties:\
/etc/libapache2-mod-jk/workers.properties \
 -v /data/apache2-log/:/var/log/apache2/ \
 -p 127.0.0.1:6000:80   \
 --name apache2 \
 apache2:0.2 \
 /bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apache2 -D FOREGROUND"
```


***
FINISH this autoscaling httpd with tomcat lesson...

---
## Optimize

  * install log and config at separate docker data scratch container
  * use external accessable network interfaces!
  * build a watcher images
  * use Dockerfile to build images :-)
    * httpd
    * watcher
    * ectd
    * registrator
    * setup log volumes or install logstash-forwarder
  * add jkstatus to the config
  * optimize worker.properties generation
  * check nsenter graceful httpd restart

***
It´s up to you!

---
## Summary

  * autoscaling is so easy
  * Fun power pack
  * good ald knowledge can't combine with new infrabricks
***
Many Thanks that you really follow us!

Andreas & Peter

follow our [blog infrabricks](http://www.infrabricks.de)
