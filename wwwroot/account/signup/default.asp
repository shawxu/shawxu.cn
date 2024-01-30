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
  var formData = XXASP.parseFormData(Request);


  var connAccessDb = Server.createObject("ADODB.Connection");
  connAccessDb.connectionString = Session.contents("dbConnString");
  connAccessDb.connectionTimeout = XXASP.TIMEOUT.DB_CONN;
  connAccessDb.open();

  var objAdoCmd = Server.createObject("ADODB.Command");

  objAdoCmd.commandText = "INSERT INTO Account (ShowID, Email, PasswordHash, SignUpTime) VALUES (:showid, :email, :pwdhash, :signuptime)";

  /* =============================== */
  var uuidBase = XXASP.UUID.v3(formData.email, XXASP.UUID.v3.DNS);
  var showID = XXASP.UUID.v5(formData.pwd, uuidBase);
  /* =============================== */
  objAdoCmd.parameters.append(objAdoCmd.createParameter("showid", adVarChar, adParamInput,
    showID.length, showID));

  objAdoCmd.parameters.append(objAdoCmd.createParameter("email", adVarChar, adParamInput,
    formData.email.length, formData.email));

  /* =============================== */
  var dateTime = new Date();
  var signupTime = XXASP.UTILS.toDBDateTimeString(dateTime);
  var pwdHash = XXASP.hashStringify(XXASP.sha1(formData.pwd + showID + signupTime)); //!!!!
  /* =============================== */
  objAdoCmd.parameters.append(objAdoCmd.createParameter("pwdhash", adVarChar, adParamInput,
    pwdHash.length, pwdHash));

  objAdoCmd.parameters.append(objAdoCmd.createParameter("signuptime", adDBTimeStamp, adParamInput,
    signupTime.length, signupTime));

  objAdoCmd.activeConnection = connAccessDb;
  objAdoCmd.commandType = adCmdText;
  objAdoCmd.commandTimeout = XXASP.TIMEOUT.DB_INSERT;

  var rsltObj = {
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

  rsltObj.data = formData; //DEBUG
  delete rsltObj.data["pwd"];
  rsltObj.data.showid = showID;

  objAdoCmd = null;
  connAccessDb.close();
  connAccessDb = null;

  Response.write(JSON.stringify(rsltObj));
%>
