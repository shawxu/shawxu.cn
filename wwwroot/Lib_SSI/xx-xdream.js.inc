<%
  if (typeof XXDRM != "object") {
    XXDRM = {};
  }

  /*
    "code" : 0,
    "msg" : "ok",
    "data" : {},
    "error" : null
  */
  XXDRM.getOriginReturnJSON = function () {
    var obj = new Object();
    obj.code = 0;
    obj.msg = "ok";
    obj.data = new Object();
    obj.error = null;

    return obj;
  };



%>