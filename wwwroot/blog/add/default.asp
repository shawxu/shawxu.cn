<%@ language="jscript"%>
<%
  Response.contentType = "application/json";
  Response.charSet = "utf-8";
%>
<!-- #include virtual = "/Lib_SSI/xx-json2.js.inc" -->
<!-- #include virtual = "/Lib_SSI/json2.js.inc" -->
<%
  var objContentType = Request.serverVariables("CONTENT_TYPE");
  var totalByteLength = Request.totalBytes;
  var contentLengthHeader = Request.serverVariables("CONTENT_LENGTH");
  var formPostData = "";
  var strBoundary = "";
  var objFormData;

  //获取multipart form data分割特征串的工具方法
  //若参数为空，默认从http request header去取并处理
  //以"boundary="为匹配特征
  function getBoundaryStr(srcStr) {
    if("string" != typeof srcStr) {
      srcStr = objContentType + "";
    }
    if(srcStr.length > 0) {
      var m = srcStr.match(/boundary\=\-*(\w+)/i);
      if(m && m[1]) {
        return m[1];
      }
    }

    return "";
  }

  //解析multipart form data本体，到map结构
  function parseMultipartData(srcData, strBdr){
    var resMap = {};
    if("string" != typeof srcData || "string" != typeof strBdr || srcData.length < 1 || strBdr.length < 1){
      return resMap;
    }

    var re = new RegExp("\\-+" + strBdr + "\\-*");
    var rslt = srcData.split(re);
    if(rslt && rslt.length > 0) {
      for(var i = 0, l = rslt.length; i < l; ++i) { //Content-Disposition: form-data; name="log"
        var tmp = rslt[i];
        var subRe = /form\-data\;\ name\=\"(.+)\"(?:\r\n)+((?:.|\r\n)+)$/;
        var m = tmp.match(subRe);
        if(m && m[1] && m[2]) {
          resMap[m[1]] = m[2];
        } else {
          continue;
        }
      }
    }
    return resMap;
  }


  function dataMapStringify(dataMap) {
    dataMap = "object" == typeof dataMap ? dataMap : {};
    var rest = [], t;
    for(var k in dataMap) {
      if("string" == typeof k && "string" == typeof (t = dataMap[k])) {
        rest.push(Server.URLEncode(k) + "=" + Server.URLEncode(t));
      }
    }
    return rest.join("&");
  }

  function readPostStream(objRequest) {
    var objAdoStream = Server.createObject("ADODB.Stream");
    var adTypeBinary = 1,
      adTypeText = 2;
    var res = "", t;

    if (!objRequest || !(t = objRequest.totalBytes)) {
      return res;
    }

    //使用ADO stream工具对象读取multipart form data的流，转换为标准字符串
    objAdoStream.type = adTypeBinary; //字节流模式
    objAdoStream.open(); //打开流
    objAdoStream.write(objRequest.binaryRead(t)); //用request body的流式读取后写入
    objAdoStream.position = 0; //流指针归位初始点
    objAdoStream.type = adTypeText; //转换为文本模式
    objAdoStream.charset = "utf-8"; //设定文本模式以utf-8来认知
    res = objAdoStream.readText(); //读取文本到字符串变量
    objAdoStream.close(); //关闭流工具
    objAdoStream = null; //释放对象引用，待回收
    return res;
  }

  //获取multipart form data的分隔符特征串
  strBoundary = getBoundaryStr();

  //流式读取出post data
  formPostData = readPostStream(Request);

  objFormData = parseMultipartData(formPostData, strBoundary);

  if ("object" == typeof objFormData && "string" == typeof objFormData.timing) {
    objFormData.timing = DC_JSON.parse(objFormData.timing);
  }
%>
{
  "code" : 0,
  "msg" : "<%= contentLengthHeader%>, ok",
  "bodyLength" : "<%= totalByteLength%>",
  "boundary" : "<%= JSON.escString(strBoundary) %>",
  "reqBodyDecoded" : "<%= JSON.escString(dataMapStringify(parseMultipartData(formPostData, strBoundary))) %>",
  "reqBodyJSON" : 
<%= JSON.stringify(objFormData)%>
}