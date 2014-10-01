# Start a simple docker java webapp data container

## build status app

```bash
sudo apt-get install -y zip
cd status
zip -r ../status.war .
cd ..
sudo docker build -t="rossbachp/status" .
```

## run tomcat with container

```bash
$ docker run -it --name=status rossbachp/status ls /webapps/*.war
status.war
$ docker run -it --rm --name=tomcat8 --volumes-from status:ro -P rossbachp/tomcat8
=> Creating and admin user with a random password in Tomcat
=> Done!
========================================================================
You can now configure to this Tomcat server using:

    admin:AJaANYAF7rFZ

========================================================================
Checking *.war in /webapps
Linking /webapps/status.war --> /opt/tomcat/webapps/status.war
Checking tomcat extended libs *.jar in /libs
Using CATALINA_BASE:   /opt/tomcat
Using CATALINA_HOME:   /opt/tomcat
Using CATALINA_TMPDIR: /opt/tomcat/temp
Using JRE_HOME:        /usr
Using CLASSPATH:       /opt/tomcat/bin/bootstrap.jar:/opt/tomcat/bin/tomcat-juli.jar
Using CATALINA_PID:    /opt/tomcat/temp/tomcat.pid
01-Oct-2014 11:00:13.228 INFO [main] org.apache.coyote.AbstractProtocol.init Initializing ProtocolHandler ["http-nio-8080"]
01-Oct-2014 11:00:13.323 INFO [main] org.apache.tomcat.util.net.NioSelectorPool.getSharedSelector Using a shared selector for servlet write/read
01-Oct-2014 11:00:13.342 INFO [main] org.apache.coyote.AbstractProtocol.init Initializing ProtocolHandler ["ajp-nio-8009"]
01-Oct-2014 11:00:13.497 INFO [main] org.apache.tomcat.util.net.NioSelectorPool.getSharedSelector Using a shared selector for servlet write/read
01-Oct-2014 11:00:13.506 INFO [main] org.apache.catalina.startup.Catalina.load Initialization processed in 1924 ms
01-Oct-2014 11:00:13.671 INFO [main] org.apache.catalina.core.StandardService.startInternal Starting service Catalina
01-Oct-2014 11:00:13.672 INFO [main] org.apache.catalina.core.StandardEngine.startInternal Starting Servlet Engine: Apache Tomcat/8.0.11
01-Oct-2014 11:00:13.746 INFO [localhost-startStop-1] org.apache.catalina.startup.HostConfig.deployWAR Deploying web application archive /opt/tomcat/webapps/status.war
01-Oct-2014 11:00:14.721 INFO [localhost-startStop-1] org.apache.catalina.startup.HostConfig.deployWAR Deployment of web application archive /opt/tomcat/webapps/status.war has finished in 974 ms
01-Oct-2014 11:00:14.729 INFO [localhost-startStop-1] org.apache.catalina.startup.HostConfig.deployDirectory Deploying web application directory /opt/tomcat/webapps/manager
01-Oct-2014 11:00:14.844 INFO [localhost-startStop-1] org.apache.catalina.startup.HostConfig.deployDirectory Deployment of web application directory /opt/tomcat/webapps/manager has finished in 114 ms
01-Oct-2014 11:00:14.858 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-nio-8080"]
01-Oct-2014 11:00:14.869 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["ajp-nio-8009"]
01-Oct-2014 11:00:14.873 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in 1366 ms
```

## Access tomcat with a new shell!
```bash
$template='{{ range $key, $value := .NetworkSettings.Ports }}{{ $key }}={{ (index $value 0).HostPort }} {{ end }}'
docker inspect --format="${template}" tomcat8
8009/tcp=49153 8080/tcp=49154
$ curl http://127.0.0.1:49154/status/index.jsp
<html>
<body>
<h1>Docker Tomcat Status page</h1>

<ul>
  <li>Hostname : c38ecdb7103c</li>
  <li>Tomcat Version : Apache Tomcat/8.0.11</li>
  <li>Servlet Specification Version :
3.1</li>
  <li>JSP version :
2.3</li>
</ul>
</body>
</html>

## See password at tomcat log output
$ curl --user "admin:AJaANYAF7rFZ" http://127.0.0.1:49154/manager/text/list
OK - Listed applications for virtual host localhost
/manager:running:0:manager
/status:running:0:status
```

## Kill test Tomcat

```bash
$ docker ps
CONTAINER ID        IMAGE                                                  COMMAND                CREATED             STATUS              PORTS                                              NAMES
c38ecdb7103c        127.0.0.1:5000/rossbachp/tomcat8:201408281657-squash   "/opt/tomcat/bin/tom   4 minutes ago       Up 4 minutes        0.0.0.0:49153->8009/tcp, 0.0.0.0:49154->8080/tcp   tomcat8
$ docker kill c38ecdb7103c
c38ecdb7103c
```
