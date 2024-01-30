<%@ language="jscript" codepage="65001"%>
<%
  var _t0 = new Date();
  Response.contentType = "application/json";
  Response.charSet = "utf-8";
%>
<!-- #include virtual = "/Lib_SSI/xx-json2.js.inc" -->
<!-- #include virtual = "/Lib_SSI/adojavas.inc" -->
<!-- #include virtual = "/Lib_SSI/xx-asp.js.inc" -->
<!-- #include virtual = "/Lib_SSI/uuid.js.inc" -->
<%
  var totalByteLength = Request.totalBytes;
  var contentLengthHeader = Request.serverVariables("CONTENT_LENGTH") - 0;
  var formPostData = "";
  var strBoundary = "";
  var objFormData;
  var rsltObj = null;

  //获取multipart form data的分隔符特征串
  strBoundary = XXASP.getBoundaryStr(Request);

  //流式读取出post data
  formPostData = XXASP.readPostStream(Request);

  objFormData = XXASP.parseMultipartData(formPostData, strBoundary);

  if (!objFormData.title || !objFormData.content) {
    //没从POST负载解析出指定的数据
    rsltObj = {
      "code" : -999,
      "msg" : "no upload data",
      "data" : {},
      "error" : "no upload data"
    };


  } else {
    var connAccessDb = Server.createObject("ADODB.Connection");
    connAccessDb.connectionString = Session.contents("dbConnString");
    connAccessDb.connectionTimeout = XXASP.TIMEOUT.DB_CONN;
    connAccessDb.open();

    var dateTime = new Date();
    var objAdoCmd = Server.createObject("ADODB.Command");
    var showID = XXASP.UUID.v4();
    var timeStr = XXASP.UTILS.toDBDateTimeString(dateTime);

    objAdoCmd.commandText = "INSERT INTO Blog (ShowID, Title, Content, PubTime, UpdateTime, OwnerID) VALUES (:uuidv4, :title, :content, :pubtime, :updtime, 1)";

    objAdoCmd.parameters.append(objAdoCmd.createParameter("uuidv4", adVarChar, adParamInput,
      showID.length, showID));
    objAdoCmd.parameters.append(objAdoCmd.createParameter("title", adLongVarWChar, adParamInput,
      objFormData.title.length, objFormData.title));
    objAdoCmd.parameters.append(objAdoCmd.createParameter("content", adLongVarWChar, adParamInput,
      objFormData.content.length, objFormData.content));
    objAdoCmd.parameters.append(objAdoCmd.createParameter("pubtime", adDBTimeStamp, adParamInput,
      timeStr.length, timeStr));
    objAdoCmd.parameters.append(objAdoCmd.createParameter("updtime", adDBTimeStamp, adParamInput,
      timeStr.length, timeStr));

    objAdoCmd.activeConnection = connAccessDb;
    objAdoCmd.commandType = adCmdText;
    objAdoCmd.commandTimeout = XXASP.TIMEOUT.DB_INSERT;

    rsltObj = {
      "code" : 0,
      "msg" : "ok",
      "data" : null,
      "error" : null
    };

    try {
      objAdoCmd.execute();
    } catch (err) {
      XXASP.handleError(err, rsltObj);
      rsltObj.error = XXASP.readADOErrors(connAccessDb);
    }

    objAdoCmd = null;
    connAccessDb.close();
    connAccessDb = null;
  }


  rsltObj.bodyLength = totalByteLength;
  rsltObj.lengthHeader = contentLengthHeader;
  rsltObj.duration = (new Date() - _t0);
  rsltObj.boundary = JSON.escString(strBoundary);
  rsltObj.reqBodyDecoded = JSON.escString(XXASP.dataMapQueryStringify(objFormData));
  rsltObj.reqBodyJSON = objFormData;

  Response.write(JSON.stringify(rsltObj));
%>