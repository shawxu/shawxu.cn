<%
  if (typeof XXASP != "object") {
    XXASP = {};
  }

  if (typeof XXASP.RETURN_CODE != "object") {
    XXASP.RETURN_CODE = {
        OK: 0,
        NO_SYS_OBJ: 400
      };
  }

  if (typeof XXASP.TIMEOUT != "object") {
    XXASP.TIMEOUT = {
        DB_INSERT: 3,
        DB_CONN: 5
      };
  }

  //获取multipart form data分割特征串的工具方法
  //若参数为空，默认从http request header去取并处理
  //以"boundary="为匹配特征
  XXASP.getBoundaryStr = function(objRequest) {
    var srcStr, t;

    if (!objRequest || !objRequest.serverVariables || !(t = objRequest.serverVariables("CONTENT_TYPE"))) {
      return null;
    }

    srcStr = t + "";

    if(srcStr.length > 0) {
      var m = srcStr.match(/boundary\=\-*(\w+)/i);
      if(m && m[1]) {
        return m[1];
      }
    }

    return null;
  };


  //解析multipart form data本体，到map结构
  XXASP.parseMultipartData = function(srcData, strBdr){
    var resMap = {};
    if("string" != typeof srcData || "string" != typeof strBdr || srcData.length < 1 || strBdr.length < 1){
      return resMap;
    }

    var re = new RegExp("(?:\\r\\n)?\\-+" + strBdr + "\\-*");
    var rslt = srcData.split(re);
    if(rslt && rslt.length > 0) {
      for(var i = 0, l = rslt.length; i < l; ++i) { //Content-Disposition: form-data; name="log"
        var tmp = rslt[i];
        var subRe = /form\-data\;\ name\=\"(.+)\"(?:\r\n){0,2}((?:.|\r\n)+)$/;
        var m = tmp.match(subRe);
        if(m && m[1] && m[2]) {
          resMap[m[1]] = m[2];
        } else {
          continue;
        }
      }
    }
    return resMap;
  };


  XXASP.readPostStream = function(objRequest) {
    var objAdoStream = Server.createObject("ADODB.Stream");
    //依赖ado基础库
    //var adTypeBinary = 1,
    //  adTypeText = 2;
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
  };


  XXASP.dataMapQueryStringify = function(dataMap) {
    dataMap = "object" == typeof dataMap ? dataMap : {};
    var rest = [], t;
    for(var k in dataMap) {
      if("string" == typeof k && "string" == typeof (t = dataMap[k])) {
        rest.push(Server.URLEncode(k) + "=" + Server.URLEncode(t));
      }
    }
    return rest.join("&");
  };

  if (typeof XXASP.UTILS != "object") {
    XXASP.UTILS = {};
  }

  XXASP.UTILS.toDBDateTimeString = function(objDT, withMsec) {
    if ("undefined" == typeof objDT || "function" != typeof objDT.getUTCFullYear) {
      objDT = new Date();
    }

    var arrDT = [];
    arrDT.push(objDT.getUTCFullYear(), "-",
      objDT.getUTCMonth() + 1, "-",
      objDT.getUTCDate(), " ",
      objDT.getUTCHours(), ":",
      objDT.getUTCMinutes(), ":",
      objDT.getUTCSeconds());
    
    if (!!withMsec) {
      arrDT.push(".", objDT.getUTCMilliseconds());
    }
    
    return arrDT.join("");
  }


%>