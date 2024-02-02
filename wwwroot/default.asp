<%@ language="jscript" codepage="65001" %>
<% 
  var _t0 = new Date();
  Response.charset = "utf-8";
%>
<!-- #include virtual = "/Lib_SSI/uuid.js.inc" -->
<!-- #include virtual = "/Lib_SSI/adojavas.inc" -->
<!-- #include virtual = "/Lib_SSI/xx-asp.js.inc" -->
<!DOCTYPE html>
<html lang="zh-cn">
<head>
  <meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="https://s3.shawxu.net/images/favicons/xx-v1/favicon.ico">
  <link rel="stylesheet" href="https://s3.shawxu.net/css/bootstrap.min.css">
  <style>
    @font-face {
      font-family: "JetBrains Mono";
      src: url("https://shawxu.net/assets/style/font/JetBrainsMono-Regular.woff2");
    }

    body {
      font-family: "JetBrains Mono";
    }
  </style>
	<title>shawxu.cn /.</title>
</head>
<body>
	<main id="container">
		<article>
      <h6>
        <%
          var dateValueAppStart = Number(Application.contents("XXASP_APP_START"));
          var dateValueSnStart = Number(Session.contents("XXASP_SN_START"));
          var dateAppStart = new Date(dateValueAppStart);
          var dateSnStart = new Date(dateValueSnStart);
          var uuidV1 = XXASP.UUID.v1();
          var uuidV4 = XXASP.UUID.v4();
        %>
        Application started at: <%= dateValueAppStart %> => <%= dateAppStart.toString() %><br>
        Session started at: <%= dateValueSnStart %> => <%= dateSnStart.toString() %><br>
        Now: <%= XXASP.UTILS.toDBDateTimeString(_t0) %><br><br>
        Session.LCID: <%= Session.LCID %><br>
        Session.codePage: <%= Session.codePage %><br>
        Response.codePage: <%= Response.codePage %><br>
        Session.sessionID: <%= Session.sessionID %><br><br>
        "你好世界！" md5 array: <%= XXASP.md5("你好世界！") %><br>
        "你好世界！" md5 string: <%= XXASP.hashStringify(XXASP.md5("你好世界！")) %><br><br>
        "Hello world!" sha1 array: <%= XXASP.sha1("Hello world!") %><br>
        "Hello world!" sha1 string: <%= XXASP.hashStringify(XXASP.sha1("Hello world!")) %><br><br>
        uuid v1: <%= uuidV1 %><br><br>
        uuid v3: <%= XXASP.UUID.v3("shawxu.cn", uuidV1) %><br>
        uuid v3 name: <%= XXASP.UUID.v3.name %><br>
        uuid v3 DNS: <%= XXASP.UUID.v3.DNS %><br>
        uuid v3 URL: <%= XXASP.UUID.v3.URL %><br><br>
        uuid v4: <%= uuidV4 %><br><br>
        uuid v5: <%= XXASP.UUID.v5("https://shawxu.cn", uuidV4) %><br>
        uuid v5 name: <%= XXASP.UUID.v5.name %><br>
        uuid v5 DNS: <%= XXASP.UUID.v5.DNS %><br>
        uuid v5 URL: <%= XXASP.UUID.v5.URL %><br>
      </h6>
			<%
        for(var itr = new Enumerator(Session.contents), itm = null, tmp = []; !itr.atEnd(), itm = itr.item(); itr.moveNext()) {
          tmp.push(itm + " : " + Session.contents(itm));
        }
        tmp.push(Request.cookies.count);
        Response.write(tmp.join("<br>") + "<br>");
        Response.flush();

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