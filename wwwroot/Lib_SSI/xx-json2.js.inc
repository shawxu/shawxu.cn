<%
  if (typeof JSON != "object") {
    JSON = {};
  }

  //插入JSON的字符串字面量时需要做必要的转义
  JSON.escString = function(str) {
    var RE = /[\\\n\r\t\/\'\"]/g;
    var RP_MAP = {
      "\\": "\\\\",
      "\n": "\\n",
      "\r": "\\r",
      "\t": "\\t",
      "\/": "\\\/",
      "\'": "\\'",
      "\"": "\\\""
    };
    return str.replace(RE, function(a) {
      return RP_MAP[a];
    });
  };

  //把JSON对象以字面量形式展现出来，有格式，适合服务器输出JSON文本
  //该方法使用递归，因此需要检查深度，目前支持最高8层递归调用
  //也即是支持的JSON最大深度8
  JSON.stringify = function(jsl, depth) {
    //字串常量声明
    var QT = "\"",
      CM = ",",
      CL = ":",
      OLB = "{",
      OLE = "}",
      ALB = "[",
      ALE = "]",
      SP = " ",
      ZS = "",
      CRLF = "\r\n",
      IDTU = "\t",
      MAXDP = 7;

    //内部变量声明
    var rslt, //结果字符串
      ta, //工具数组，用以合成字符串
      isArr, //判断object是否是一个Array
      k, //遍历器，kayName
      idt, //前缩进字符串
      ridt; //后缩进字符串

    if ("number" != typeof depth) { //初始化depth
      depth = 0; //默认值
    } else if (depth > MAXDP) { //递归深度满
      return QT + QT; //直接返回空串表达
    }

    if(jsl === undefined) { //处理undefined
      rslt = "undefined";
    } else if ("string" == typeof jsl) { //处理字符串
      rslt = QT + JSON.escString(jsl) + QT; //字符串字面量，需要转义
    } else if ("number" == typeof jsl) { //处理数字
      if (isNaN(jsl)) { //特殊数字NaN
        rslt = "NaN";
      } else if (!isFinite(jsl)) { //特殊数字Infinity
        rslt = jsl < 0 ? "-Infinity" : "Infinity";
      } else {
        rslt = jsl.toString();
      }
    } else if ("object" == typeof jsl) { //处理对象一类数据
      if (jsl === null) { //处理特殊对象null
        rslt = "null";
      } else { //对象处理逻辑，该工具方法复杂部分
        ta = []; //初始化工具数组
        ta.push((isArr = (jsl instanceof Array)) ? ALB : OLB); //加入数组或对象起始符号{或[

        idt = (new Array((depth + 1) + 1)).join(IDTU); //计算前缩进串长度
        ta.push(CRLF, idt); //加入换行和前缩进

        for (k in jsl) { //进入成员遍历，注意数组也可以被for in遍历
          if (!isArr) { //不是数组是对象
            ta.push(QT, JSON.escString(k), QT, CL); //加入keyName表达，字符串字面量，需要转义
          }
          ta.push(JSON.stringify(jsl[k], depth + 1), CM); //递归调用，获得值表达
          ta.push(CRLF, idt); //对象成员间有换行，下一个成员前缩进
        }

        if (ta[ta.length - 1] == idt) { //弹出最后一个前缩进
          ta.pop();
        }
        if (ta[ta.length - 1] == CRLF) { //弹出最后一个换行
          ta.pop();
        }
        if (ta[ta.length - 1] == CM) { //弹出最后一个逗号
          ta.pop();
        }
        if (ta[ta.length - 1] == (isArr ? ALB : OLB)) { //若是无成员对象
          ta.push(SP); //加入空格即可
        } else { //对象有成员，即将结束闭合
          ridt = (new Array((depth + 1))).join(IDTU); //计算后缩进值
          ta.push(CRLF, ridt); //加入换行和后缩进
        }
        ta.push(isArr ? ALE : OLE); //加入对象结束符]或}
        rslt = ta.join(ZS); //生成结果字符串
      }
    } else {
      rslt = QT + QT; //数字，字符串，对象，数组以外的数据类型（如function）不支持
    }
    return rslt; //返回结果
  };
%>