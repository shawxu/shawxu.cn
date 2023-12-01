<%@ language="jscript" %>
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
			<% Response.Write(
        Session.LCID + "<br>" +
        Session.codePage + "<br>" +
        Session.SessionID + "<br>"
      );

      //Session("uname") = "xx";
      for(var itr = new Enumerator(Session.Contents), itm = null; !itr.atEnd(), itm = itr.item(); itr.moveNext()) {
        Response.Write(itm + " : " + Session(itm) + "<br>");
      }
      Response.Write("Hello world! " + Session("uname"));
      %>
      <br>
		</article>
	</main>
</body>
</html>