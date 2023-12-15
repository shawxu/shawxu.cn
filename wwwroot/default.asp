<%@ language="jscript" %>
<% 
  var _t0 = new Date();
  Response.charset = "utf-8";
%>
<!-- #include virtual = "/Lib_SSI/xx-asp.js.inc" -->
<!DOCTYPE html>
<html lang="zh-cn">
<head>
  <meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="https://s3.shawxu.net/images/favicons/xx-v1/favicon.ico">
  <link rel="stylesheet" href="https://s3.shawxu.net/css/bootstrap.min.css">
	<title>shawxu.cn /.</title>
</head>
<body>
	<main id="container">
		<article>
      <h6>
        <%
          var dateValueAppStart = Number(Application.Contents("XXASP_APP_START"));
          var dateAppStart = new Date(dateValueAppStart);
        %>
        Application started at: <%= dateValueAppStart %> => <%= dateAppStart.toString() %><br>
        Now: <%= (new Date()).valueOf() %><br>
        Session.LCID: <%= Session.LCID %><br>
        Session.codePage: <%= Session.codePage %><br>
        Session.sessionID: <%= Session.sessionID %><br>
        Path: <%= Server.mapPath("/") + "\\App_Data\\xxblog.accdb;" %>
      </h6>
			<%
        for(var itr = new Enumerator(Session.contents), itm = null, tmp = []; !itr.atEnd(), itm = itr.item(); itr.moveNext()) {
          tmp.push(itm + " : " + Session.contents(itm));
        }
        tmp.push(Request.cookies.count);
        Response.write(tmp.join("<br>") + "<br>");
        Response.flush();

        //XXASP.sleep(2);

        for(var itr = new Enumerator(Request.serverVariables), itm = null, tmp = []; !itr.atEnd(), itm = itr.item(); itr.moveNext()) {
          if(itm == "ALL_HTTP" || itm == "ALL_RAW"){
            tmp.push(itm + " : <pre>" + Request.serverVariables(itm) + "</pre>");
          }else{
            tmp.push(itm + " : <i style=\"font-weight:300\">" + Request.serverVariables(itm) + "</i>");
          }
        }
        Response.write(tmp.join("<br>"));
      %>
      <br>
      Page running time take: <%= (new Date() - _t0) %> ms
		</article>
	</main>
</body>
</html>