<%
  if (typeof XXASP != "object") {
    XXASP = {};
  }

  if (typeof XXASP.TIMEOUT != "object") {
    XXASP.TIMEOUT = {
        DB_INSERT: 3,
        DB_FIND: 3,
        DB_CONN: 5
      };
  }

  //获取multipart form data分割特征串的工具方法
  //若参数为空，默认从http request header去取并处理
  //以"boundary="为匹配特征
  XXASP.getBoundaryStr = function (objRequest) {
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
  XXASP.parseMultipartData = function (srcData, strBdr) {
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

  XXASP.parseFormData = function (objRequest) {
    var rsltMap = {};

    for (var itr = new Enumerator(objRequest.form), itm = null, kn = "", vlu = ""; !itr.atEnd(), kn = itr.item(); itr.moveNext()) {
      itm = objRequest.form(kn);

      if ("object" == typeof itm && "number" == typeof itm.count) {
        if (1 === itm.count) {
          rsltMap[kn] = itm(1);
        } else if (1 < itm.count) {
          var tmp = (rsltMap[kn] = []);
          for (var i = 0, l = itm.count; i < l; ++i) {
            tmp.push(itm(1 + i));
          }
        } else {
          rsltMap[kn] = "";
        }
      }
    }
    return rsltMap;
  };


  XXASP.readPostStream = function (objRequest) {
    if (!objRequest || !(t = objRequest.totalBytes)) {
      return res;
    }

    var objAdoStream = null, res = "", t;

    //依赖ado基础库
    if ("undefined" == typeof adTypeBinary) {
      var adTypeBinary = 1;
    }

    //依赖ado基础库
    if ("undefined" == typeof adTypeText) {
      var adTypeText = 2;
    }

    objAdoStream = Server.createObject("ADODB.Stream");

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


  XXASP.dataMapQueryStringify = function (dataMap) {
    dataMap = "object" == typeof dataMap ? dataMap : {};
    var rest = [], t;
    for(var k in dataMap) {
      if("string" == typeof k && "string" == typeof (t = dataMap[k])) {
        rest.push(Server.URLEncode(k) + "=" + Server.URLEncode(t));
      }
    }
    return rest.join("&");
  };
  
  /*
    //ADO Errors
		Description	"The changes ..."	String
		HelpContext	5003022	Number
		HelpFile	""	String
		NativeError	-105121349	Number
		Number	-2147467259	Number
		Source	"Microsoft Access Database Engine"	String
		SQLState	"3022"	String
  */
  XXASP.readADOErrors = function (connObj) {
    var rslt = null;
    if ("object" == typeof connObj && "undefined" != typeof connObj.errors) {
      if (connObj.errors.count > 0) {
        var adoErrors = [], tmp;
        for (var i = 0, itm; i < connObj.errors.count; ++i) {
          itm = connObj.errors(i);
          if ("object" == typeof itm) {
            tmp = {};
            if ("number" == typeof itm.Number) {
              tmp.number = itm.Number;
            }
            if ("string" == typeof itm.Description) {
              tmp.description = itm.Description;
            }
            if ("number" == typeof itm.HelpContext) {
              tmp.helpContext = itm.HelpContext;
            }
            if ("string" == typeof itm.HelpFile) {
              tmp.helpFile = itm.HelpFile;
            }
            if ("number" == typeof itm.NativeError) {
              tmp.nativeError = itm.NativeError;
            }
            if ("string" == typeof itm.Source) {
              tmp.source = itm.Source;
            }
            if ("string" == typeof itm.SQLState) {
              tmp.sqlState = itm.SQLState;
            }
          }
          adoErrors.push(tmp);
        }
        rslt = adoErrors;
      }
    }

    return rslt;
  };

  /*
  //javascript Error
  description	"The changes you requested to the table were not successful because they would create duplicate values in the index, primary key, or relationship. Change the data in the field or fields that contain duplicate data, remove the index, or redefine the index to permit duplicate entries and try again."	String
  message	"The changes you requested to the table were not successful because they would create duplicate values in the index, primary key, or relationship. Change the data in the field or fields that contain duplicate data, remove the index, or redefine the index to permit duplicate entries and try again."	String
  name	"Error"	String
  number	-2147467259	Number
  */
  XXASP.handleError = function (errObj, retObj) {
    if ("object" != typeof retObj) {
      retObj = {};
    }
    if ("object" == typeof errObj) {
      if ("number" == typeof errObj.number && errObj.number !== 0) {
        retObj.code = errObj.number;
      }

      if ("string" == typeof errObj.message && errObj.message.length > 0) {
        retObj.msg = errObj.message;
      } else if ("string" == typeof errObj.description && errObj.description.length > 0) {
        retObj.msg = errObj.description;
      }
    }
  };

  if (typeof XXASP.UTILS != "object") {
    XXASP.UTILS = {};
  }

  XXASP.UTILS.toDBDateTimeString = function (objDT, withMsec) {
    if ("undefined" == typeof objDT || "function" != typeof objDT.getFullYear) {
      objDT = new Date();
    }

    var arrDT = [], tmp;
    arrDT.push(
      objDT.getFullYear(), "-",
      (tmp = objDT.getMonth() + 1) < 10 ? "0" + tmp : tmp, "-",
      (tmp = objDT.getDate()) < 10 ? "0" + tmp : tmp, " ",
      (tmp = objDT.getHours()) < 10 ? "0" + tmp : tmp, ":",
      (tmp = objDT.getMinutes()) < 10 ? "0" + tmp : tmp, ":",
      (tmp = objDT.getSeconds()) < 10 ? "0" + tmp : tmp
    );
    
    if (!!withMsec) {
      arrDT.push(".", objDT.getMilliseconds());
    }

    return arrDT.join("");
  };


%>