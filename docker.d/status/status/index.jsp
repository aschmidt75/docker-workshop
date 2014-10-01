<%@ page session="false" %>
<html>
<body>
<h1>Docker Tomcat Status page</h1>

<ul>
  <li>Hostname : <%= java.net.InetAddress.getLocalHost().getHostName()%></li>
  <li>Tomcat Version : <%= application.getServerInfo() %></li>
  <li>Servlet Specification Version :
<%= application.getMajorVersion() %>.<%= application.getMinorVersion() %></li>
  <li>JSP version :
<%=JspFactory.getDefaultFactory().getEngineInfo().getSpecificationVersion() %></li>
</ul>
</body>
</html>
