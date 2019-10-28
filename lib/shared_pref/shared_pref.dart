import 'package:shared_preferences/shared_preferences.dart';

//sharedpreferences
//单例模式

//待定


class MySharedPref {
  static MySharedPref _mySharedPref = MySharedPref._();
  static SharedPreferences _preferences;

  //构造函数
  MySharedPref._();

  static Future<MySharedPref> getInstance() async{
    if (_mySharedPref == null) {
      _mySharedPref = MySharedPref._();
      await _mySharedPref._init();
    }
    return _mySharedPref;
  }

  Future _init() async{
    _preferences = await SharedPreferences.getInstance();
  }
}