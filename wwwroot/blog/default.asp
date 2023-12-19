<%@ language="jscript" codepage="65001"%>
<!-- #include virtual = "/Lib_SSI/xx-json2.js.inc" -->
<!-- #include virtual = "/Lib_SSI/adojavas.inc" -->
<!-- #include virtual = "/Lib_SSI/xx-asp.js.inc" -->
<!-- #include virtual = "/Lib_SSI/uuid.js.inc" -->
<%
  Response.charSet = "utf-8";
  var _t0 = new Date();
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
  <meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>shawxu.cn /blog</title>
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
      var rSet = Server.createObject("ADODB.RecordSet");
      var dbFilePath = Server.mapPath("/") + "\\App_Data\\xxblog.accdb"; //GOOD 64bit driver
      connAccessDb.connectionString = "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" + dbFilePath + ";Persist Security Info=False;"; //GOOD 64bit OLEDB
      connAccessDb.open();

      rSet.open("SELECT * FROM Blog", connAccessDb, adOpenForwardOnly);
      var strTable = rSet.getString(adClipString, 200, "</td><td>", "</td></tr><tr><td>", "&nbsp;");

      rSet.close();
      connAccessDb.close();
      delete rSet;
      delete connAccessDb;
    %>
    <%= dbFilePath %>
    <pre><table>
      <tbody>
        <tr>
          <td><%= strTable %></td>
        </tr>
      </tbody>
    </table></pre>
    </article>
	</main>
</body>
</html>