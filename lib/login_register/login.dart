import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lexiyang/main.dart';

///登录页面
///登录注册修改密码功能

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  String userName;
  String password;

  //输入框控制器
  TextEditingController _phonecontroller = new TextEditingController();
  TextEditingController _pwdcontroller = new TextEditingController();

  //登陆按钮 调用函数 并对密码账号正确性校验
  void login() {
    _writeLoginState();

    //获取到输入框的文本
    userName = _phonecontroller.text;
    password = _pwdcontroller.text;
    print("zhanghao "+userName);
    print("mima "+password);

    //进入校验层，待定

    //将数据发送到服务器，等待返回结果,成功则进入首页并销毁登录注册页面
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyHomePage()));
  }

  //将登录状态存入本地磁盘
  _writeLoginState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('login', true);
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
              )),
            new Padding(
              padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 15.0),
              child: new Stack(
                alignment: new Alignment(1.0, 1.0),
                //statck
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
                      '极速登录',
                      style: new TextStyle(
                          color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  onPressed: login,
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
                      print("zhuce");
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