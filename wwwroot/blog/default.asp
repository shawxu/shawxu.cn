<%@ language="jscript" codepage="65001"%>
<!-- #include virtual = "/Lib_SSI/xx-json2.js.inc" -->
<!-- #include virtual = "/Lib_SSI/adojavas.inc" -->
<!-- #include virtual = "/Lib_SSI/xx-asp.js.inc" -->
<!-- #include virtual = "/Lib_SSI/uuid.js.inc" -->
<%
  var _t0 = new Date();
  Response.charSet = "utf-8";
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
  <meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="https://s3.shawxu.net/images/favicons/xx-v1/favicon.ico">
  <link rel="stylesheet" href="https://s3.shawxu.net/css/bootstrap.min.css">
	<title>shawxu.cn /blog</title>
  <style>
    @font-face {
      font-family: "JetBrains Mono";
      src: url("https://shawxu.net/assets/style/font/JetBrainsMono-Regular.woff2");
    }

    body {
      font-family: "JetBrains Mono";
    }
    table {
      width:1200px;
    }
    caption {
      caption-side:top;
    }
    tbody, thead {
      font-size:0.75rem;
    }
    td, th {
      max-height:50px;
      overflow:hidden;
    }
    .words {
      font-size:0.6rem;
      white-space:pre-wrap;
      word-break:break-word;
    }
    .blogtitle {
      width:160px;
    }
    .blogcontent {
      width:480px;
    }
  </style>
</head>
<body>
	<main id="container">
		<article>
      <h5>Session ID: <%= Session.SessionID %></h5>
		</article>
    <article>
      <h6>Hello <%= Session("uname") %></h6>
      <%
        var connAccessDb = Server.createObject("ADODB.Connection");
        connAccessDb.connectionString = Session.contents("dbConnString");
        connAccessDb.connectionTimeout = XXASP.TIMEOUT.DB_CONN;
        connAccessDb.open();

        var rSet = Server.createObject("ADODB.Recordset");
        rSet.open("SELECT * FROM Blog", connAccessDb, adOpenForwardOnly);
        var restArrStr = [];
        var rCnt = 0;

        restArrStr.push("<table><caption>Table Blog</caption>");
        while (!rSet.EOF) {
          if (rCnt == 0) { //展现表头
            restArrStr.push("<thead><tr>");
            for (var i = 0, cl = rSet.fields.count; i < cl; ++i) {
              switch (rSet.fields(i).name) {
                case "Content":
                  restArrStr.push("<th class=\"blogcontent\">");
                  break;
                case "Title":
                  restArrStr.push("<th class=\"blogtitle\">");
                  break;
                default:
                  restArrStr.push("<th>");
              }
              restArrStr.push(rSet.fields(i).name, "</th>");
            }
            restArrStr.push("</tr></thead><tbody>");
          } //表头展现结束
          restArrStr.push("<tr>");
          for (var i = 0, cl = rSet.fields.count; i < cl; ++i) {
            switch (rSet.fields(i).name) {
              case "Content":
                restArrStr.push("<td class=\"blogcontent words\">");
                break;
              case "Title":
                restArrStr.push("<td class=\"blogtitle words\">");
                break;
              default:
                restArrStr.push("<td>");
            }

            restArrStr.push(rSet.fields(i).value, "</td>");
          }
          restArrStr.push("</tr>");

          rSet.moveNext();
          ++rCnt;
        }
        restArrStr.push("</tbody></table>");

        rSet.close();
        rSet = null;

        connAccessDb.close();
        connAccessDb = null;
      %>
      <%= restArrStr.join("") %>
      Duration: <%= new Date() - _t0 %>
    </article>
	</main>
</body>
</html>