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
  <meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>shawxu.cn /blog</title>
  <style>
    caption {
      caption-side:bottom;
    }
    tbody {
      font-size:x-small;
    }
  </style>
</head>
<body>
	<main id="container">
		<article>
			<%
        Response.Write(
          Session.LCID + "<br>" +
          Session.codePage + "<br>" +
          Session.SessionID + "<br>"
        );

        for(var itr = new Enumerator(Session.Contents), itm = null; !itr.atEnd(), itm = itr.item(); itr.moveNext()) {
          Response.Write(itm + " : " + Session(itm) + "<br>");
        }
        Response.Write("Hello world! " + Session("uname"));
      %>
      <br>
		</article>
    <article>
    <%
      var connAccessDb = Server.createObject("ADODB.Connection");
      var rSet = Server.createObject("ADODB.Recordset");
      var dbFilePath = Server.mapPath("/") + "\\App_Data\\xxblog.accdb"; //GOOD 64bit driver
      connAccessDb.connectionString = "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" + dbFilePath + ";Persist Security Info=False;"; //GOOD 64bit OLEDB
      connAccessDb.open();

      rSet.open("SELECT * FROM Blog", connAccessDb, adOpenForwardOnly);
      //var strTable = rSet.getString(adClipString, 200, "</td><td>", "</td></tr><tr><td>", "&nbsp;");
      var restArrStr = [];
      var rCnt = 0;

      restArrStr.push("<table style=\"width:1280px;\"><caption>Blog</caption>");
      while (!rSet.EOF) {
        if (rCnt == 0) {
          restArrStr.push("<thead><tr>");
          for (var i = 0, cl = rSet.fields.count; i < cl; ++i) {
            switch (rSet.fields(i).name) {
              case "Content":
                restArrStr.push("<th style=\"width:480px;\">");
                break;
              default:
                restArrStr.push("<th>");
            }
            restArrStr.push(rSet.fields(i).name, "</th>");
          }
          restArrStr.push("</tr></thead><tbody>");
        }
        restArrStr.push("<tr>");
        for (var i = 0, cl = rSet.fields.count; i < cl; ++i) {
          switch (rSet.fields(i).name) {
            case "Content":
            case "Title":
              restArrStr.push("<td style=\"white-space:pre;\">");
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
      connAccessDb.close();

      rSet = null;
      connAccessDb = null;
    %>
    <%= restArrStr.join("") %>
    </article>
	</main>
</body>
</html>