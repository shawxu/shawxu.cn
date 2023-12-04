<%@ language="jscript" %>
<% 
  Response.buffer = false;
  var _t0 = new Date();
  Response.charset = "utf-8";
  //Response.addHeader("Cache-control", "max-age=15");
  //Response.addHeader("Last-modified", _t0.toGMTString().replace("UTC", "GMT"));
 %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
  <meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="https://s3.shawxu.net/images/favicons/xx-v1/favicon.ico">
	<title>shawxu.cn /.</title>
</head>
<body>
	<main id="container">
		<article><h6>
			<% Response.write(
        (new Date()).toUTCString() + "<br>" +
        Session.LCID + "<br>" +
        Session.codePage + "<br>" +
        Session.sessionID + "<br>"
      );

      for(var itr = new Enumerator(Session.contents), itm = null, tmp = []; !itr.atEnd(), itm = itr.item(); itr.moveNext()) {
        tmp.push(itm, " : ", Session.contents(itm), "<br>");
      }
      Response.write(tmp.join("") + "<br>");
      //Response.flush();

      Response.write(Response.cookies.count + "<br>");

      for(var itr = new Enumerator(Request.serverVariables), itm = null, tmp = []; !itr.atEnd(), itm = itr.item(); itr.moveNext()) {
        if(itm == "ALL_HTTP" || itm == "ALL_RAW"){
          tmp.push("# ", itm, " : <br><pre>", Request.serverVariables(itm), "</pre>");
        }else{
          tmp.push("# ", itm, " : ", Request.serverVariables(itm), "<br>");
        }
      }
      Response.write(tmp.join("") + "Hello world!<br>" + (new Date() - _t0));
      //Response.flush();
      %>
      <br>
		</h6></article>
	</main>
</body>
</html>