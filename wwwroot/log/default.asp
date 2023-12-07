<%@ language="jscript"%>
<%
  Response.contentType = "application/json";
  Response.charSet = "utf-8";
%>
<!-- #include virtual = "/Lib_SSI/xx-json2.js.inc" -->
<!-- #include virtual = "/Lib_SSI/json2.js.inc" -->
<!-- #include virtual = "/Lib_SSI/xx-asp.js.inc" -->
<%
  var totalByteLength = Request.totalBytes;
  var contentLengthHeader = Request.serverVariables("CONTENT_LENGTH");
  var formPostData = "";
  var strBoundary = "";
  var objFormData;

  //获取multipart form data的分隔符特征串
  strBoundary = XXASP.getBoundaryStr(Request);

  //流式读取出post data
  formPostData = XXASP.readPostStream(Request);

  objFormData = XXASP.parseMultipartData(formPostData, strBoundary);

  if ("object" == typeof objFormData && "string" == typeof objFormData.timing) {
    objFormData.timing = DC_JSON.parse(objFormData.timing);
  }
%>
{
  "code" : 0,
  "msg" : "<%= contentLengthHeader%>, ok",
  "bodyLength" : "<%= totalByteLength%>",
  "boundary" : "<%= JSON.escString(strBoundary) %>",
  "reqBodyDecoded" : "<%= JSON.escString(XXASP.dataMapQueryStringify(objFormData)) %>",
  "reqBodyJSON" : 
<%= JSON.stringify(objFormData)%>
}