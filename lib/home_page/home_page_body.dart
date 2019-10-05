import 'package:flutter/material.dart';
import 'package:lexiyang/vo/news_vo.dart';
import 'package:lexiyang/home_page/home_page_appbar.dart';
import 'package:lexiyang/home_page/calendar/calendar_page.dart';
import 'package:lexiyang/home_page/telephone/telephone_page.dart';


//显示首页的body部分，顶部为宫格,作为功能入口，共两行，每行四个
//其后为新闻列表,新闻数据来自网络

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  //listview控制器
  ScrollController _scrollController = ScrollController();

  //新闻列表list,由于body部分为一个listview，头部加载了三个其他组件，所以新闻列表前三条数据无法显示
  //将第一条数据加载4遍
  List<NewsData> _newsList = [
    new NewsData('标题1', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/default.png'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/default.png'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/default.png'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
    new NewsData('标题', 'http://47.102.118.187:8080/images/test1.jpg'),
  ];
  
  

  //构造listview不同item
  //前两行显示功能入口，其后显示新闻列表
  //_开头为私有
  Widget _buildWidget(BuildContext context, int index) {
    if (index == 0) {
      //第一行天气，日历，闹钟，电话入口
      print("1");
      return _buildRow0(context, index);
    } else if (index == 1) {
      //第二行自诊，运动，地图，菜谱入口
      print("2");
      return _buildRow1(context, index);
    } else if (index == 2) {
      //提示该组件以下内容为新闻
      print("3");
      return _buildNewSeparate();
    } else {
      //构建新闻列表
      print("新闻");
      return _buildNewsItem(index);
    }
  }

  //构建第一行功能入口
  Widget _buildRow0(BuildContext context, int index) {
    Widget widget = new Row(

      children: <Widget>[
        Padding(padding: EdgeInsets.only(left: 20.0)),
        _buildRowItem(Icons.wb_sunny, '天气'),
        Spacer(flex: 1,),
        _buildRowItem(Icons.calendar_today, '日历'),
        Spacer(flex: 1,),
        _buildRowItem(Icons.timer, '闹钟'),
        Spacer(flex: 1,),
        _buildRowItem(Icons.phone, '电话'),
        Padding(padding: EdgeInsets.only(left: 20.0)),
      ],
    );
    return widget;
  }

  //构建第二行功能入口
  Widget _buildRow1(BuildContext context, int index) {
    Widget widget = new Row(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(left: 20.0)),
        _buildRowItem(Icons.local_hospital, '自诊'),
        Spacer(flex: 1,),
        _buildRowItem(Icons.directions_run, '运动'),
        Spacer(flex: 1,),
        _buildRowItem(Icons.map, '地图'),
        Spacer(flex: 1,),
        _buildRowItem(Icons.restaurant_menu, '菜谱'),
        Padding(padding: EdgeInsets.only(left: 20.0)),
      ],
    );
    return widget;
  }

  //图标颜色
  Map<String, Color> _iconColor = {
    '天气' : Colors.blue,
    '日历' : Colors.red,
    '闹钟' : Colors.lightBlue,
    '电话' : Colors.lightBlue,
    '自诊' : Colors.red,
    '运动' : Colors.green,
    '地图' : Colors.yellow,
    '菜谱' : Colors.green,
  };

  //功能入口子项，上面为图标按钮，下面为文字
  Widget _buildRowItem (IconData icon, String name) {
    Color color = _iconColor[name];
    return new GestureDetector(
      onTap: () {
        //根据不同item进入不同页面
        if (name == '日历') {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> MyCalendar()));
        } else if (name == '电话') {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> TelephonePage()));
        } else {
          print("hahah");
        }
      },
      child: Column(
        children: <Widget>[
          new Padding(padding: EdgeInsets.only(top: 15.0)),
          new Icon(icon,color: color,size: 40.0,),
          new Text(name,style: TextStyle(fontSize: 14.0),),
        ],
      ),
    );
  }

  //新闻提示组件，用于分割功能入口和新闻数据
  Widget _buildNewSeparate() {
    return new Padding(
      padding: EdgeInsets.only(top: 10.0,left: 5.0,right: 5.0,bottom: 10.0),
      child: Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 20.0)),
          new Text('新闻',style: TextStyle(fontSize: 18.0),),
          Spacer(flex: 1,),
          new Icon(Icons.arrow_forward_ios),
          Padding(padding: EdgeInsets.only(left: 20.0)),
        ],
      ),
    );
  }

  //新闻列表子项
  Widget _buildNewsItem(int index) {
    if (index < _newsList.length) {
      return new Padding(
        padding: EdgeInsets.all(20.0),
        child: ListTile(
          title: Text(_newsList[index].title),
          leading: Image.network(_newsList[index].pictureUrl),
          //点击进入新闻详情页面
          onTap: null,
        ),
      );
    }
    return _getMoreWidget();
  }

  //listview分割线
  Widget _buildSeparated (BuildContext context, int index) {
    //前两行不需要分割线
    if (index < 1) {
      return new Padding(padding: EdgeInsets.all(1.0));
    } else {
      return Divider();
    }
  }

  //下拉加载更多组件
  Widget _getMoreWidget () {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          '加载中...',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  //下拉刷新函数
  Future _onRefresh() async {
    await Future.delayed(Duration(seconds: 3),(){
      setState(() {
        //为了测试，刷新后直接将_list第一项数据删除,实际中则是网络请求数据
      });
    });
  }

  //状态初始化
  @override
  void initState() {
    //加载数据
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        print("上拉加载更多");
        //数据加载函数，并调用setstate函数
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.separated(
          itemBuilder: (context, index) => _buildWidget(context,index),
          separatorBuilder: (context, index) => _buildSeparated(context, index),
          itemCount: _newsList.length + 1,
        ),
      ),
    );
  }
}