<%@ page import="java.io.*" %>
<%@ page import="java.util.Properties" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>sysinfo</title>
    <script type="text/javascript">

    </script>
</head>
<body>
    <%--<h3><a href="sysinfo.jsp">系统属性</a></h3>--%>
    <%
        String currentPath = new java.io.File(application.getRealPath(request.getRequestURI())).getParent();
        Properties props=System.getProperties();

    %>

    <div id="divSysinfo" style="width: 98%; height: 100%;">
        <textarea cols="80" rows="16" style="width:100%;">
            当前路径：<%=currentPath%>
            操作系统：<%=props.getProperty("os.name")%>
            系统构架：<%=props.getProperty("os.arch")%>
            系统版本：<%=props.getProperty("os.version")%>
            用户名称：<%=props.getProperty("user.name")%>
            用户主目录：<%=props.getProperty("user.home")%>
            用户工作目录：<%=props.getProperty("user.dir")%>
            Java路径：<%=props.getProperty("java.home")%>
            Java类路径：<%=props.getProperty("java.class.path")%>
        </textarea>
    </div>
</body>
</html>