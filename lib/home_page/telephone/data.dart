import 'package:flutter/material.dart';
import 'constants.dart';

//定义电话页面顶部导航栏
class MyTab {
  //导航标题
  final String title;
  //导航数据的类别
  final int category;

  const MyTab(this.title,this.category);
}

//导航栏中items
const List<MyTab> myTab = const<MyTab>[
  const MyTab("服务", MyConstants.SERVICE),
  const MyTab("家人", MyConstants.FAMILY),
  const MyTab("紧急", MyConstants.EMERGENCY)
];

//联系人类，tab下对应的数据的抽象
class Contact {
  //头像，暂时为icon
  IconData icon;
  //名字
  String name;
  //电话号码
  String phoneNumber;

  Contact(this.icon,this.name,this.phoneNumber);
}

//服务号码数据
List<Contact> serviceList = <Contact>[
  Contact(Icons.wb_sunny, "天气预报", "121"),
  Contact(Icons.timer, "报时服务", "117"),
  Contact(Icons.phone, "电信综合服务", "10000"),
  Contact(Icons.phone, "联通客服热线", "10010"),
  Contact(Icons.phone, "联通话费查询", "10011"),
  Contact(Icons.phone, "移动客服热线", "10086"),
  Contact(Icons.call, "国际人工长途电话", "103"),
  Contact(Icons.call, "国际直拨受话人付费电话", "108"),
  Contact(Icons.phone, "国内邮政编码查询", "184"),
  Contact(Icons.phone, "供电局", "95598"),
  Contact(Icons.phone, "税务局通用电话", "12366"),
  Contact(Icons.phone, "消费者申诉举报电话", "12315"),
  Contact(Icons.phone, "中国铁通客服热线", "10050"),
  Contact(Icons.phone, "中国网通客服热线", "10060"),
  Contact(Icons.phone, "电话及长途区号查询", "114"),
  Contact(Icons.phone, "市话障碍自动受理", "112"),
  Contact(Icons.phone, "价格监督举报", "12358"),
  Contact(Icons.phone, "质量监督电话", "12365"),
  Contact(Icons.phone, "机构编制违规举报热线", "12310"),
  Contact(Icons.phone, "环保局监督电话", "12369"),
];

//紧急号码数据
List<Contact> emergencyList = <Contact>[
  Contact(Icons.people_outline, "警察", "110"),
  Contact(Icons.local_hospital, "急救", "120"),
  Contact(Icons.people, "火警", "119"),
  Contact(Icons.directions_car, "交警", "122"),
];