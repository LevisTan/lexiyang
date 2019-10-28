import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lexiyang/http/dioutils.dart';
import 'package:lexiyang/api/url_api.dart';
import 'verification_bean.dart';
import 'regist_bean.dart';
import 'package:cipher2/cipher2.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lexiyang/main.dart';
import 'package:lexiyang/api/get_sign.dart';


class RegisterPage extends StatefulWidget {

  @override
  RegisterPageState createState() {
    return RegisterPageState();
  }
}

//注册页面
class RegisterPageState extends State<RegisterPage> {

  //输入控制器
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _verificationCodeController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  //对应输入框中数据
  String phoneNumber;
  String userName;
  String password;
  String verificationCode;

  //获取验证码按钮点击事件
  _getVerifyCode() async{
    bool canRigister = true;
    phoneNumber = _phoneNumberController.text;
    //手机号码校验
    if (!RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$').hasMatch(phoneNumber)) {
      phoneNumber = null;
      _phoneNumberController.clear();
      canRigister = false;
      myToast("手机号码错误，请重新输入");
    }
    password = _passwordController.text;
    if (password == null || password == '') {
      canRigister = false;
      myToast("请输入密码");
    }
    userName = _userNameController.text;
    if (userName == null || userName == '') {
      canRigister = false;
      myToast("请输入用户名");
    }
    //手机号码格式正确且用户名称密码不为空，允许请求验证码
    if (canRigister == true) {
      //请求获取短信验证接口参数
      Map<String,dynamic> map = {
        'account' : phoneNumber,
        'app_sid' : 'lxy',
        'type' : 0,
      };
      var result = await DioManager.getInstance().post(MyUrls.GET_VERIFICATION_CODE, map);
      print("================================result:" + result.toString());
      VerificationCodeBean verificationCodeBean = VerificationCodeBean.fromJson(result);
      print("================================errmsg:" + verificationCodeBean.payload.errmsg);
      //大写OK
      if (verificationCodeBean.payload.errmsg == 'OK') {
        myToast("获取验证码成功");
      } else {
        myToast("获取验证码失败");
      }
    }
  }

  //吐司
  myToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  //注册按钮点击事件
  _register() async{
    verificationCode = _verificationCodeController.text;
    if (verificationCode == null || verificationCode == '') {
      myToast("请填写验证码");
    } else {
      //AES加密密钥
      String key = 'llc2019050920aok';
      //AES加密偏移量
      String iv = '1983457286157286';
      //将密码进行AES加密
      String AESEncryptedPWD = await Cipher2.encryptAesCbc128Padding7(password, key, iv);
      //13位时间戳(单位毫秒)
      String time = DateTime.now().millisecondsSinceEpoch.toString();
      //请求参数
      Map<String,dynamic> map = {
        'account' : phoneNumber,
        'password' : AESEncryptedPWD,
        'app_sid' : 'lxy',
        'type' : 0,
        'username' : userName,
        'verifycode' : verificationCode,
        'time' : time,
      };
      //加上sign字段的map
      map['sign'] = MySign.getSign(map);
      //请求服务器注册接口
      var result = await DioManager.getInstance().post(MyUrls.REGISTER, map);
      print("--------------------------------result:" + result.toString());
      RegistBean registBean = RegistBean.fromJson(result);

      //注册成功
      if (registBean.status == 200) {
        //进入首页
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyHomePage()));
        //将token保存在本地
        saveInfoToNative("token", registBean.payload.token);
        print("=============================token:" + registBean.payload.token);
        saveInfoToNative("phoneNumber", phoneNumber);
        saveInfoToNative("password", AESEncryptedPWD);

        //保存登录状态为true，用于自动登录，后期修改为单例模式
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setBool('login', true);
      } else {
        myToast("注册失败");
      }
    }
  }

  //按规则获取sign字段value
//  Map<String,dynamic> getHaveSignMap(Map<String,dynamic> map) {
//    String secret = 'llc201905131618wtk';
//    var list = [];
//    //将map中key放入列表中
//    map.forEach((key,value){
//      list.add(key);
//    });
//    //将list按ascii码值排序
//    list.sort();
//    //拼接字符串
//    String str = '';
//    list.forEach((key){
//      //不能使用 str = str + 'aa';这种操作
//      str = '$str' + key + "=" + map[key].toString();
//    });
//    //print("====================str:" + str);
//    String waitStr = secret + str + secret;
//    //print("=================waitstr:" + waitStr);
//    //将waitStr进行md5加密
//    String waitSign = md5.convert(utf8.encode(waitStr)).toString();
//    //print("==============waitstrMD5:" + waitSign);
//    //将waitSign转换为小写
//    String sign = waitSign.toLowerCase();
//    //print("================waitSign小写:" + sign);
//    map['sign'] = sign;
//    //返回含有sign字段的map
//    print("=====最后的map：" + map.toString());
//    return map;
//  }

  //保存基本信息到本地
  saveInfoToNative(String key,String value) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('注册'),),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50.0,),
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 12,right: 12),
              child: Row(
                children: <Widget>[
                  Text('手机号码:',style: TextStyle(fontSize: 15,color: Colors.black),),
                  Expanded(
                    child: TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: '输入手机号码'
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 12,right: 12),
              child: Row(
                children: <Widget>[
                  Text('密      码  :',style: TextStyle(fontSize: 15,color: Colors.black),),
                  Expanded(
                    child: TextField(
                      obscureText: true,
                      controller: _passwordController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                          hintText: '输入密码'
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 12,right: 12),
              child: Row(
                children: <Widget>[
                  Text('用 户 名  :',style: TextStyle(fontSize: 15,color: Colors.black),),
                  Expanded(
                    child: TextField(
                      controller: _userNameController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: '输入用户名'
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 12,right: 12),
              child: Row(
                children: <Widget>[
                  Text('验 证 码  :',style: TextStyle(fontSize: 15,color: Colors.black),),
                  Expanded(
                    child: TextField(
                      controller: _verificationCodeController,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: '输入验证码'
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    child:RaisedButton(
                      //请求服务器，发送验证码
                      onPressed: (){ _getVerifyCode(); },
                      color: Colors.grey,
                      child: Text('获取验证码',style: TextStyle(color: Colors.white,fontSize: 10),),
                    )
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 45,
              margin: EdgeInsets.only(top: 50,left:10,right:10),
              child: RaisedButton(
                //注册成功进入主页,保存token到本地
                onPressed: (){ _register(); },
                shape: StadiumBorder(side:BorderSide.none),
                color: Color(0xff44c5fe),
                child: Text('注        册',
                  style: TextStyle(color: Colors.white,fontSize: 18,),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}