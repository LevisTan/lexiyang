import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lexiyang/main.dart';
import 'package:lexiyang/login_register/register_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cipher2/cipher2.dart';
import 'package:lexiyang/api/get_sign.dart';
import 'package:lexiyang/http/dioutils.dart';
import 'package:lexiyang/api/url_api.dart';
import 'login_bean.dart';

///登录页面
///登录注册修改密码功能

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  String phoneNumber;
  String password;

  //输入框控制器
  TextEditingController _phonecontroller = new TextEditingController();
  TextEditingController _pwdcontroller = new TextEditingController();

  //登陆按钮 调用函数 并对密码账号正确性校验
  void login() async{
    //获取到输入框的文本
    phoneNumber = _phonecontroller.text;
    password = _pwdcontroller.text;

    if (phoneNumber == '' || password == '') {
      Fluttertoast.showToast(
        msg: '手机号码或密码错误',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      //AES加密密钥
      String key = 'llc2019050920aok';
      //AES加密偏移量
      String iv = '1983457286157286';
      //将密码进行AES加密
      String AESEncryptedPWD = await Cipher2.encryptAesCbc128Padding7(password, key, iv);
      //时间戳
      var time = DateTime.now().millisecondsSinceEpoch;
      //构建请求参数
      Map<String,dynamic> map = {
        'account' : phoneNumber,
        'password' : AESEncryptedPWD,
        'app_sid' : 'lxy',
        'time' : time,
      };
      map['sign'] = MySign.getSign(map);
      //接受服务器返回结果
      var result = await DioManager.getInstance().post(MyUrls.LOGIN, map);
      LoginBean loginBean = LoginBean.fromJson(result);
      //登录成功
      if (loginBean.status == 200) {
        Fluttertoast.showToast(msg: '登录成功');
        //进入首页
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyHomePage()));
        //保存token,积分和登陆状态
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('token', loginBean.payload.token);
        preferences.setString('score', loginBean.payload.score);
        preferences.setBool('login', true);
        //将手机号码，AES加密后的密码保存本地
        preferences.setString('phoneNumber', phoneNumber);
        preferences.setString('password', AESEncryptedPWD);
      } else {
        Fluttertoast.showToast(msg: '账号或密码错误');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(30.0),
              child: new Image.asset(
                'images/ic_launcher.png',
                scale: 1.2,
              )
            ),
            new Padding(
              padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 15.0),
              child: new Stack(
                alignment: new Alignment(1.0, 1.0),
                //stack
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new Padding(
                        padding: new EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                        child: new Image.asset(
                          'images/icon_username.png',
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      new Expanded(
                        child: new TextField(
                          controller: _phonecontroller,
                          keyboardType: TextInputType.phone,
                          decoration: new InputDecoration(
                            hintText: '请输入用户名',
                          ),
                        ),
                      ),
                    ]),
                  new IconButton(
                    icon: new Icon(Icons.clear, color: Colors.black45),
                    onPressed: () {
                      _phonecontroller.clear();
                    },
                  ),
                ],
              ),
            ),
            new Padding(
              padding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 40.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                    child: new Image.asset(
                      'images/icon_password.png',
                      width: 40.0,
                      height: 40.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  new Expanded(
                    child: new TextField(
                      controller: _pwdcontroller,
                      decoration: new InputDecoration(
                        hintText: '请输入密码',
                        suffixIcon: new IconButton(
                          icon: new Icon(Icons.clear, color: Colors.black45),
                          onPressed: () {
                            _pwdcontroller.clear();
                          },
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                ]),
            ),
            new Container(
              width: 340.0,
              child: new Card(
                color: Colors.blue,
                elevation: 16.0,
                child: new FlatButton(
                  child: new Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: new Text(
                      '登录',
                      style: new TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  onPressed: () { login(); },
                ),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.fromLTRB(12.0, 22.0, 15.0, 0.0),
                  child: new GestureDetector(
                    onTap: () {
                      //进入注册页面
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                    },
                    child: new Text(
                      '注册',
                      style: new TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.fromLTRB(12.0, 22.0, 26.0, 0.0),
                  child: new GestureDetector(
                    onTap: () {
                      print("wangjimima");
                    },
                    child: new Text(
                      '忘记密码?',
                      style: new TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}