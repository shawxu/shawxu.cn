<%@ language="jscript" codepage="65001"%>
<%
  var _t0 = new Date();
  Response.charSet = "utf-8";
%>
<!-- #include virtual = "/Lib_SSI/xx-json2.js.inc" -->
<!-- #include virtual = "/Lib_SSI/adojavas.inc" -->
<!-- #include virtual = "/Lib_SSI/xx-asp.js.inc" -->
<!-- #include virtual = "/Lib_SSI/uuid.js.inc" -->
<!DOCTYPE html>
<html lang="zh-cn">
<head>
  <meta charset="UTF-8">
  <title>Sign up result</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<%
  var formData = XXASP.parseFormData(Request);

  /*var totalByteLength = Request.totalBytes;
  var contentLengthHeader = Request.serverVariables("CONTENT_LENGTH");
  var formPostData = "";
  var strBoundary = "";
  var objFormData;

  //获取multipart form data的分隔符特征串
  strBoundary = XXASP.getBoundaryStr(Request);

  //流式读取出post data
  formPostData = XXASP.readPostStream(Request);

  objFormData = XXASP.parseMultipartData(formPostData, strBoundary);

  var connAccessDb = Server.createObject("ADODB.Connection");
  connAccessDb.connectionString = Session.contents("dbConnString");
  connAccessDb.connectionTimeout = XXASP.TIMEOUT.DB_CONN;
  connAccessDb.open();

  var dateTime = new Date();
  var objAdoCmd = Server.createObject("ADODB.Command");

  objAdoCmd.commandText = "INSERT INTO Blog (ShowID, Title, Content, PubTime, UpdateTime, OwnerID) VALUES (:uuidv4, :title, :content, :pubtime, :updtime, 1)";

  objAdoCmd.parameters.append(objAdoCmd.createParameter("uuidv4", adVarChar, adParamInput,
    38, XXASP.UUID.v4()));
  objAdoCmd.parameters.append(objAdoCmd.createParameter("title", adLongVarWChar, adParamInput,
    objFormData.title.length, objFormData.title));
  objAdoCmd.parameters.append(objAdoCmd.createParameter("content", adLongVarWChar, adParamInput,
    objFormData.content.length, objFormData.content));
  objAdoCmd.parameters.append(objAdoCmd.createParameter("pubtime", adDBTimeStamp, adParamInput,
    20, XXASP.UTILS.toDBDateTimeString(dateTime)));
  objAdoCmd.parameters.append(objAdoCmd.createParameter("updtime", adDBTimeStamp, adParamInput,
    20, XXASP.UTILS.toDBDateTimeString(dateTime)));

  objAdoCmd.activeConnection = connAccessDb;
  objAdoCmd.commandType = adCmdText;
  objAdoCmd.commandTimeout = XXASP.TIMEOUT.DB_INSERT;
  objAdoCmd.execute();

  objAdoCmd = null;
  connAccessDb.close();
  connAccessDb = null;*/
%>
  <script>
    window.parent.postMessage(<%= JSON.stringify(formData) %>, "*");
  </script>
</body>
</html>
