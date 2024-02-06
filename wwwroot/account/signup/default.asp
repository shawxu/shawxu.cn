<%@ language="jscript" codepage="65001" %>
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
    "data" : {},
    "error" : null
  };

  try {
    objAdoCmd.execute();
  } catch (err) {
    XXASP.handleError(err, rsltObj);
    rsltObj.error = XXASP.readADOErrors(connAccessDb);
  }

  if ("function" == typeof connAccessDb.errors.clear && connAccessDb.errors.count > 0) {
    connAccessDb.errors.clear();
  }

  var identityRs = null;

  objAdoCmd.commandText = "SELECT @@IDENTITY";

  try {
    identityRs = objAdoCmd.execute();
  } catch (err) {
    XXASP.handleError(err, rsltObj);
    var tmp = XXASP.readADOErrors(connAccessDb);
    if (!rsltObj.error) {
      rsltObj.error = tmp;
    } else if ("object" == typeof tmp && tmp.length) {
      rsltObj.error = tmp.concat(rsltObj.error);
    }
  }

  if ("object" == typeof identityRs) {
    rsltObj.data.userID = identityRs.fields(0).value - 0;
    rsltObj.data.userShowID = showID;
  }

  identityRs = null;
  objAdoCmd = null;
  connAccessDb.close();
  connAccessDb = null;

  rsltObj.data.duration = new Date() - _t0;

  Response.write(JSON.stringify(rsltObj));
%>
