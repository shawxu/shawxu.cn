<%@ language="jscript" codepage="65001"%>
<%
  Response.contentType = "application/json";
  Response.charSet = "utf-8";
  var _t0 = new Date();
%>
<!-- #include virtual = "/Lib_SSI/xx-json2.js.inc" -->
<!-- #include virtual = "/Lib_SSI/json2.js.inc" -->

<!-- #include virtual = "/Lib_SSI/adojavas.inc" -->
<!-- #include virtual = "/Lib_SSI/xx-asp.js.inc" -->
<%
  var totalByteLength = Request.totalBytes;
  var contentLengthHeader = Request.serverVariables("CONTENT_LENGTH");
  var formPostData = "";
  var strBoundary = "";
  var objFormData;
  var connAccessDb;

  //获取multipart form data的分隔符特征串
  strBoundary = XXASP.getBoundaryStr(Request);

  //流式读取出post data
  formPostData = XXASP.readPostStream(Request);

  objFormData = XXASP.parseMultipartData(formPostData, strBoundary);

  connAccessDb = Server.createObject("ADODB.Connection");
  var dbFilePath = Server.mapPath("/") + "\\App_Data\\xxblog.accdb"; //GOOD 64bit driver
  var connStr = "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" + dbFilePath + ";Persist Security Info=False;"; //GOOD 64bit OLEDB
  connAccessDb.open(connStr);

  //ID* Title Content PubTime UpdateTime ShowID
  connAccessDb.close();
  delete connAccessDb;

%>
{
  "code" : 0,
  "msg" : "<%= contentLengthHeader %>, ok",
  "bodyLength" : "<%= totalByteLength %>",
  "duration" : "<%= (new Date() - _t0) %>",
  "dbPath" : "<%= JSON.escString(dbFilePath) %>",
  "boundary" : "<%= JSON.escString(strBoundary) %>",
  "reqBodyDecoded" : "<%= JSON.escString(XXASP.dataMapQueryStringify(objFormData)) %>",
  "reqBodyJSON" : 
<%= JSON.stringify(objFormData) %>
}