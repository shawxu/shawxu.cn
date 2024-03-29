<%@ language="jscript" codepage="65001" %>
<%
  var _t0 = new Date();
  Response.contentType = "application/json";
  Response.charSet = "utf-8";
%>
<!-- #include virtual = "/Lib_SSI/xx-json2.js.inc" -->
<!-- #include virtual = "/Lib_SSI/uuid.js.inc" -->
<!-- #include virtual = "/Lib_SSI/adojavas.inc" -->
<!-- #include virtual = "/Lib_SSI/xx-asp.js.inc" -->
<!-- #include virtual = "/Lib_SSI/xx-xdream.js.inc" -->
<%
  var formData = XXASP.parseFormData(Request);

  var connAccessDb = Server.createObject("ADODB.Connection");
  connAccessDb.connectionString = Application.contents("dbConnString");
  connAccessDb.connectionTimeout = XXASP.TIMEOUT.DB_CONN;
  connAccessDb.open();

  var objAdoCmd = Server.createObject("ADODB.Command");

  objAdoCmd.commandText = "SELECT * FROM Account WHERE Email = :email";

  /* =============================== */
  var userID; // = XXASP.UUID.v3(formData.email, XXASP.UUID.v3.DNS);
  var showID; // = XXASP.UUID.v5(formData.pwd, uuidBase);
  /* =============================== */

  objAdoCmd.parameters.append(objAdoCmd.createParameter("email", adVarChar, adParamInput,
    formData.email.length, formData.email));

  /* =============================== */
  var signUpTimeObj;
  var signupTime; // = XXASP.UTILS.toDBDateTimeString(dateTime);
  var pwdHash; // = XXASP.hashStringify(XXASP.sha1(formData.pwd + showID + signupTime)); //!!!!
  /* =============================== */

  objAdoCmd.activeConnection = connAccessDb;
  objAdoCmd.commandType = adCmdText;
  objAdoCmd.commandTimeout = XXASP.TIMEOUT.DB_FIND;

  var rsltObj = XXDRM.getOriginReturnJSON();

  try {
    var userCheckRs = objAdoCmd.execute();
  } catch (err) {
    XXASP.handleError(err, rsltObj);
    rsltObj.error = XXASP.readADOErrors(connAccessDb);
  }

  if ("object" == typeof userCheckRs) {
    if (!userCheckRs.BOF && !userCheckRs.EOF) {
      for (var i = 0, tmp, cl = userCheckRs.fields.count; i < cl; ++i) {
        tmp = userCheckRs.fields(i);
        if (tmp.name === "ShowID") {
          showID = tmp.value + "";
        } else if (tmp.name === "SignUpTime") {
          signUpTimeObj = new Date(tmp.value);
        } else if (tmp.name === "PasswordHash") {
          pwdHash = tmp.value + "";
        } else if (tmp.name === "UserID") {
          userID = tmp.value - 0;
        }
      }

      signupTime = XXASP.UTILS.toDBDateTimeString(signUpTimeObj);
      if (pwdHash === XXASP.hashStringify(XXASP.sha1(formData.pwd + showID + signupTime))) {
        //密码校验成功
        rsltObj.data.showID = showID;
        //Response.cookies("login")("sid") = showID;
        //Response.cookies("login")("uid") = userID;
        Response.cookies("login") = rsltObj.data.loginToken = XXASP.hashStringify(XXASP.md5(userID.toString() + showID + formData.email));
        Response.cookies("login").secure = true;
        Session.contents(rsltObj.data.loginToken) = JSON.stringify(
          {
            "uid" : userID,
            "sid" : showID,
            "email" : formData.email
          }
        );
      } else {
        rsltObj.code = -998;
        rsltObj.msg = "wrong pw";
      }
      
    } else { //没有有效的记录
      rsltObj.code = -999;
      rsltObj.msg = "no user";
    }
  }

  userCheckRs = null;
  objAdoCmd = null;
  connAccessDb.close();
  connAccessDb = null;

  rsltObj.data.duration = new Date() - _t0;

  Response.write(JSON.stringify(rsltObj));
%>
