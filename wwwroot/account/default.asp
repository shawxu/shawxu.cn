<%@ language="jscript" codepage="65001" enablesessionstate="false" %>
<!-- #include virtual = "/Lib_SSI/xx-json2.js.inc" -->
<!-- #include virtual = "/Lib_SSI/uuid.js.inc" -->
<!-- #include virtual = "/Lib_SSI/adojavas.inc" -->
<!-- #include virtual = "/Lib_SSI/xx-asp.js.inc" -->
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
  <link rel="stylesheet" href="https://shawxu.net/assets/style/main.css">
	<title>shawxu.cn /account</title>
</head>
<body>
	<main id="container">
		<article>
      <h5>Session ID: NO Session</h5>
		</article>
    <article>
      <h6>Hi</h6>
      <%
        var connAccessDb = Server.createObject("ADODB.Connection");
        connAccessDb.connectionString = Application.contents("dbConnString");
        connAccessDb.connectionTimeout = XXASP.TIMEOUT.DB_CONN;
        connAccessDb.open();

        var rSet = Server.createObject("ADODB.Recordset");
        rSet.open("SELECT * FROM Account", connAccessDb, adOpenForwardOnly);
        var restArrStr = [];
        var rCnt = 0;

        restArrStr.push("<table><caption>Table Account</caption>");
        while (!rSet.EOF) {
          if (rCnt == 0) { //展现表头
            restArrStr.push("<thead><tr>");
            for (var i = 0, cl = rSet.fields.count; i < cl; ++i) {
              switch (rSet.fields(i).name) {
                /*case "Content":
                  restArrStr.push("<th class=\"blogcontent\">");
                  break;
                case "Title":
                  restArrStr.push("<th class=\"blogtitle\">");
                  break;*/
                default:
                  restArrStr.push("<th>");
              }
              restArrStr.push(rSet.fields(i).name, "</th>");
            }
            restArrStr.push("</tr></thead>");
          } //表头展现结束
          restArrStr.push("<tbody><tr>");
          for (var i = 0, cl = rSet.fields.count; i < cl; ++i) {
            switch (rSet.fields(i).name) {
              /*case "Content":
                restArrStr.push("<td class=\"blogcontent words\">");
                break;
              case "Title":
                restArrStr.push("<td class=\"blogtitle words\">");
                break;*/
              default:
                restArrStr.push("<td>");
            }
            if (rSet.fields(i).name === "SignUpTime") {
              restArrStr.push(XXASP.UTILS.toDBDateTimeString(new Date(rSet.fields(i).value)), " ## ");
            }// else {
              restArrStr.push(rSet.fields(i).value, "</td>");
            //}
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
      Time: <%= "function" == typeof _t0.toUTCString ? _t0.toUTCString() : (_t0 + " #") %><br>
      Time: <%= "function" == typeof _t0.toGMTString ? _t0.toGMTString() : (_t0 + " #") %><br>
      Time: <%= "function" == typeof _t0.toISOString ? _t0.toISOString() : (_t0 + " #") %><br>
      Time: <%= "function" == typeof _t0.toLocaleString ? _t0.toLocaleString() : (_t0 + " #") %><br>
      Duration: <%= new Date() - _t0 %>
    </article>
	</main>
</body>
</html>