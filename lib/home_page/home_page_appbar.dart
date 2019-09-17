import 'package:flutter/material.dart';

///定义首页的appBar样式

final Widget homeAppBar = new AppBar(
  title: Text('首页'),
  actions: <Widget>[
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        //待定
        print("转跳搜索页面");
      },
    ),
  ],
);