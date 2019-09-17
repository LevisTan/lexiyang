import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lexiyang/login_register/login.dart';
import 'package:flutter/services.dart';
import 'package:lexiyang/found_video_page/found_video_page_appbar.dart';
import 'package:lexiyang/home_page/home_page_appbar.dart';
import 'package:lexiyang/person_page/person_page_appbar.dart';
import 'package:lexiyang/home_page/home_page_body.dart';
import 'package:lexiyang/person_page/person_page_body.dart';
import 'package:lexiyang/found_video_page/found_video_page_body.dart';

//登录状态，实现自动登录功能
var loginState;

void main() async {
  //获取用户登录状态
  SharedPreferences preferences = await SharedPreferences.getInstance();
  loginState = preferences.getBool('login');
  if (loginState == null) {
    loginState = false;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: loginState ? MyHomePage() : LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //当前页面索引
  var _currentIndex = 0;

  //当前页面对象
  HomePage homePage;
  VideoPage videoPage;
  PersonPage personPage;

  //当前页面appBar样式
  getCurrentAppBar() {
    if (_currentIndex == 0) {
      return homeAppBar;
    } else if (_currentIndex == 1) {
      return vedioAppBar;
    } else if (_currentIndex == 2) {
      return personAppBar;
    }
  }

  //当前页面body样式
  getCurrentBoby() {
    if (_currentIndex == 0) {
      //??运算，当homePage为空时将new HomePage()赋值给homePage，否则保持不变
      homePage ??= new HomePage();
      return homePage;
    } else if (_currentIndex == 1) {
      videoPage ??= new VideoPage();
      return videoPage;
    } else if (_currentIndex == 2) {
      personPage ??= new PersonPage();
      return PersonPage();
    }
  }

  //底部导航栏items
  var bottomNavigationBarItems = [
    new BottomNavigationBarItem(
      title: Text(
        '首页',
      ),
      icon: Icon(Icons.home,),
    ),
    new BottomNavigationBarItem(
      title: Text(
        '发现',
      ),
      icon: Icon(Icons.explore,),
    ),
    new BottomNavigationBarItem(
      title: Text(
        '我',
      ),
      icon: Icon(Icons.perm_identity,),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCurrentAppBar(),
      body: getCurrentBoby(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: bottomNavigationBarItems,
        type: BottomNavigationBarType.fixed,
        onTap: ((index) {
          setState(() {
            _currentIndex = index;
          });
        }),
      ),
    );
  }
}
