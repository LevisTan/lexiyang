import 'dart:convert';
import 'package:crypto/crypto.dart';

class MySign {
  //获取sign签名，网络请求公共操作
  static String getSign(Map<String,dynamic> map) {
    String secret = 'llc201905131618wtk';
    var list = [];
    //将map中key放入列表中
    map.forEach((key,value){
      list.add(key);
    });
    //将list按ascii码值排序
    list.sort();
    //拼接字符串
    String str = '';
    list.forEach((key){
      str = '$str' + key + "=" + map[key].toString();
    });

    String waitStr = secret + str + secret;
    //将waitStr进行md5加密
    String waitSign = md5.convert(utf8.encode(waitStr)).toString();
    //将waitSign转换为小写
    String sign = waitSign.toLowerCase();

    return sign;
  }
}