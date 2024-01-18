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


  var connAccessDb = Server.createObject("ADODB.Connection");
  connAccessDb.connectionString = Session.contents("dbConnString");
  connAccessDb.connectionTimeout = XXASP.TIMEOUT.DB_CONN;
  connAccessDb.open();

  var dateTime = new Date();
  var objAdoCmd = Server.createObject("ADODB.Command");

  var uuidBase = XXASP.UUID.v3(formData.email, XXASP.UUID.v3.DNS);
  var showID = XXASP.UUID.v5(formData.pwd, uuidBase);

  objAdoCmd.commandText = "INSERT INTO Account (ShowID, Email, PasswordHash, SignUpTime) VALUES (:showid, :email, :pwdhash, :signuptime)";

  objAdoCmd.parameters.append(objAdoCmd.createParameter("showid", adVarChar, adParamInput,
    38, showID));

  objAdoCmd.parameters.append(objAdoCmd.createParameter("email", adVarChar, adParamInput,
    formData.email.length, formData.email));

  /* =============================== */
  var signupTime = XXASP.UTILS.toDBDateTimeString(dateTime);
  var pwdHash = XXASP.hashStringify(XXASP.sha1(formData.pwd + showID + signupTime)); //!!!!
  /* =============================== */
  objAdoCmd.parameters.append(objAdoCmd.createParameter("pwdhash", adVarChar, adParamInput,
    pwdHash.length, pwdHash));

  objAdoCmd.parameters.append(objAdoCmd.createParameter("signuptime", adDBTimeStamp, adParamInput,
    20, signupTime));

  objAdoCmd.activeConnection = connAccessDb;
  objAdoCmd.commandType = adCmdText;
  objAdoCmd.commandTimeout = XXASP.TIMEOUT.DB_INSERT;
  objAdoCmd.execute();

  objAdoCmd = null;
  connAccessDb.close();
  connAccessDb = null;
%>
  <script>
    window.parent.postMessage(<%= JSON.stringify(formData) %>, "*");
  </script>
</body>
</html>
