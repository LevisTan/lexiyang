import 'package:flutter/material.dart';
import 'package:flukit/flukit.dart';
import 'package:lexiyang/video/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weather_database.dart';
import 'package:lexiyang/api/url_api.dart';
import 'package:lexiyang/api/get_sign.dart';
import 'weather_bean.dart';
import 'package:lexiyang/http/dioutils.dart';


class WeatherPage extends StatefulWidget {

  @override
  WeatherPageState createState() {
    return WeatherPageState();
  }
}

class WeatherPageState extends State<WeatherPage> {

  //appbar顶部城市名字,默认为北京
  String _city = '北京';
  //swiper子项数量
  static int listlength = 1;

  //存放从本地加载的城市数据
  var _list = [];

  SwiperController _controller = new SwiperController();

  @override
  void initState() {
    //将默认数据放入列表中
    setState(() {
      City city = new City();
      city.cityName = _city;
      _list = [city];
    });

    getCities();
    //swiper控制器监听
    _controller.addListener((){
      if (listlength > 1) {
        setState(() {
          _city = _list[_controller.index].cityName;
        });
      }
    });
  }

  //获取城市数据，来自sharedpreferences和database
  getCities() async{
    //step1:从sharedpreferences获取一个城市数据,作为默认城市
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String city = preferences.getString("city");
      if (city != null) {
        _city = city;
      }
      print("city from SharedPreferences:" + city);
    } catch (e) {
      print(e);
    }
    //将第一个城市数据放入列表中
    setState(() {
      City city = new City();
      city.cityName = _city;
      _list = [city];
    });
    //step2:从database中获取多个城市数据,并添加在列表中(用户添加的多个城市数据)
    try {
      var tempList = await WeatherDBProvider.db.getAllCities();
      _list += tempList;
    } catch (e) {
      print(e);
    }
    //刷新列表长度
    if (_list.length > 1) {
      setState(() {
        listlength = _list.length;
      });
    }
  }

  setCityToSpClient() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("city", "北京");
  }

  insertCityToDB() {
//    var list1 = [
//      "上海",
//      "厦门",
//      "娄底",
//      "南京",
//      "长沙",
//    ];
//    for (int i=0; i<5; i++) {
//      City city = new City();
//      city.cityName = list1[i];
//      WeatherDBProvider.db.insert(city);
//    }
//    setState(() { });
  }


  //自定义appbar，使其appbar文字能动态改变(setState)

  @override
  Widget build(BuildContext context) {

    //轮播天气界面,不要设置为类成员变量，否则无法改变状态
    List<Widget> swiperData = List.generate(listlength, (i) {
      return Container(
        decoration: BoxDecoration(
          //背景图片,从本地加载，当然也可以根据城市名字从网络加载相关图片
          image: DecorationImage(
            image: i % 2 == 0 ? AssetImage("images/second_bg.jpg") : AssetImage("images/weather_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: WeatherDataPage(_list[i].cityName,i),
      );
    });

    return Container(
      width: Screen.width,
      height: Screen.height,
      //分为appbar和内容部分（轮播组件部分）
      child: Column(
        children: <Widget>[
          //自定义appbar部分
          Container(
            width: Screen.width,
            height: 100.0,
            decoration: BoxDecoration(color: Colors.blue),
              child: Padding(padding: EdgeInsets.fromLTRB(12.0, 30.0, 10.0, 12.0),
                child: Row(children: <Widget>[
                  GestureDetector(
                    child: Icon(Icons.location_city,color: Colors.white,),
                    onTap: () {
                      print("city");
                      //test
                      setCityToSpClient();
                    },
                  ),
                  Spacer(flex: 1,),
                  Text(
                    _city,
                    style: TextStyle(
                      color: Colors.white,fontSize: 20.0,
                      decoration: TextDecoration.none,  //去除下划线
                    ),
                  ),
                  Spacer(flex: 1,),
                  GestureDetector(
                    child: Icon(Icons.settings,color: Colors.white,),
                    onTap: () { print("setting"); insertCityToDB();},
                  ),
                ],
              ),
            ),
          ),
          //下面为天气轮播部分界面
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Swiper(
                autoStart: false,
                circular: false,
                direction: Axis.horizontal,
                children: swiperData,
                controller: _controller,
                //轮播圆点
                indicator: CircleSwiperIndicator(
                  itemColor: Colors.grey
                ),
                indicatorAlignment: AlignmentDirectional.topCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//天气页的视图，显示数据，根据地点参数查询地点天气素具
class WeatherDataPage extends StatefulWidget {

  //统一按照城市名字查询天气
  String cityName;
  //轮播的序号
  int position;

  WeatherDataPage(this.cityName,this.position);

  @override
  WeatherDataPageState createState() {
    return WeatherDataPageState();
  }
}

//存放对应轮播页面的天气对象数据
List<WeatherBean> dataList = [];

class WeatherDataPageState extends State<WeatherDataPage> {
  //暂存当前页面天气数据
  WeatherBean _weatherBean;
  int position;
  //判断加载是否成功
  bool isOK = false;

  //字体样式1
  var textStyle1 = TextStyle(
    fontSize: 25.0,
    color: Colors.white,
    decoration: TextDecoration.none,
  );

  //顶部今天天气详情部分
  Widget _todayWeather() {
    return Container(
      child: Column(
        children: <Widget>[
          //天气，如:21度
          Padding(padding: EdgeInsets.only(top: 50.0),
            child: Text(
              '${_weatherBean.payload.result.temp}' + '℃',
              style: TextStyle(
                color: Colors.white,
                fontSize: 100.0,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          //阳光，如:晴
          Padding(padding: EdgeInsets.only(top: 5.0),
            child: Text(
              '${_weatherBean.payload.result.weather}',
              style: textStyle1,
            ),
          ),
          //温度范围
          Padding(padding: EdgeInsets.only(top: 5.0),
            child: Text(
              '${_weatherBean.payload.result.templow}' + '℃' + '/' + '${_weatherBean.payload.result.temphigh}' + '℃',
              style:  textStyle1,
            ),
          ),
          //风力
          Padding(padding: EdgeInsets.only(top: 5.0),
            child: Text(
              '${_weatherBean.payload.result.winddirect}' + ' ' + '${_weatherBean.payload.result.windpower}',
              style: textStyle1,
            ),
          ),
          //更新时间
          Padding(padding: EdgeInsets.only(left: 0.0,top: 10.0),
            child: Text(
              '${_weatherBean.payload.result.updatetime}' + ' 更新',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  //24小时天气
  Widget _buildHour(List<Hourly> hours) {
    List<Widget> widgets = [];
    for (int i=0; i<hours.length; i++) {
      widgets.add(_getHourItem(hours[i]));
    }
    return Container(
      child: SingleChildScrollView(
        //水平滚动
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widgets,
        ),
      ),
    );
  }
  
  //24小时天气item
  Widget _getHourItem(Hourly hourly) {
    return Container(
      height: 150,
      width: 80,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            hourly.time,
            style: TextStyle(color: Colors.white, fontSize: 12,decoration: TextDecoration.none,),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            hourly.weather,
            style: TextStyle(color: Colors.white, fontSize: 15,decoration: TextDecoration.none,),
          ),
          SizedBox(
            height: 15,
          ),
          Image(
            image: AssetImage('images/${hourly.img}.png'),
            height: 30,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            hourly.temp+"℃",
            style: TextStyle(color: Colors.white, fontSize: 16,decoration: TextDecoration.none,),
          ),
        ],
      ),
    );
  }

  //未来7天天气
  Widget _getDays(List<Daily> days) {
    List<Widget> widgets = [];
    for (int i=0; i<days.length; i++) {
      widgets.add(_getDaysItem(days[i],i));
    }
    return Container(
      width: Screen.width,
      height: 300,
      child: Column(
        children: widgets,
      ),
    );
  }

  //未来七天天气item
  Widget _getDaysItem(Daily daily,int i) {
    return Container(
      width: Screen.width,
      height: 40,
      padding: EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            //显示今天
            i == 0 ? daily.date + ' ' + '今  天' : daily.date + ' ' + daily.week,
            style: TextStyle(color: Colors.white, fontSize: 15,decoration: TextDecoration.none,),
          ),
          Spacer(flex: 1,),
          Image(
            image: AssetImage('images/${daily.day.img}.png'),
            height: 30,
          ),
          Spacer(flex: 1,),
          Text(
            daily.night.templow + '℃' + '/' + daily.day.temphigh + '℃',
            style: TextStyle(color: Colors.white, fontSize: 15,decoration: TextDecoration.none,),
          ),
        ],
      ),
    );
  }

  //生活指数
  Widget _getIndex(List<Index> indexes) {
    return Container(
      child: Column(
        children: <Widget>[
          _getIndexItem(indexes[0], indexes[1]),
          Divider(color: Colors.black38,height: 20,),
          _getIndexItem(indexes[2], indexes[3]),
          Divider(color: Colors.black38,height: 20,),
          _getIndexItem(indexes[5], indexes[6]),
          Divider(color: Colors.black38,height: 20,),
        ],
      ),
    );
  }

  //生活指数item
  Widget _getIndexItem(Index index1,Index index2) {
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(width: 20.0,),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  index1.iname,
                  style: TextStyle(color: Colors.white, fontSize: 10,decoration: TextDecoration.none,),
                ),
                SizedBox(height: 15.0,),
                Text(
                  index1.ivalue,
                  style: TextStyle(color: Colors.white, fontSize: 20,decoration: TextDecoration.none,),
                ),
              ],
            ),
          ),
          //左右隔离做一下调整,屏幕适配可能会出现问题(无法对齐)
          SizedBox(width: index1.iname == '紫外线指数' ? Screen.width/2.4 : Screen.width/3),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  index2.iname,
                  style: TextStyle(color: Colors.white, fontSize: 10,decoration: TextDecoration.none,),
                ),
                SizedBox(height: 15.0,),
                Text(
                  index2.ivalue,
                  style: TextStyle(color: Colors.white, fontSize: 20,decoration: TextDecoration.none,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //天气界面详情
  Widget getItem() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //顶部今天天气部分
          _todayWeather(),
          //分割线
          Divider(color: Colors.black38,height: 20.0,),
          //24小时天气
          _buildHour(_weatherBean.payload.result.hourly),
          //分割线
          Divider(color: Colors.black38,height: 20.0,),
          //未来7天天气
          _getDays(_weatherBean.payload.result.daily),
          //分割线
          Divider(color: Colors.black38,height: 5.0,),
          //生活指数
          _getIndex(_weatherBean.payload.result.index),
          //数据提供者
          SizedBox(height: 10.0,),
          Text(
            '数据由极速数据提供',
            style: TextStyle(color: Colors.black38, fontSize: 10,decoration: TextDecoration.none,),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          isOK ? getItem() : CircularProgressIndicator(),
        ],
      ),
    );
  }

  //根据城市名字请求数据
  @override
  void initState() {
    position = widget.position;
    //已经加载过数据，直接获取
    if (position < dataList.length) {
      _weatherBean = dataList[position];
      isOK = true;
    } else {
      //第一次从服务器加载数据
      loadData();
    }
  }

  //请求数据
  loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //从本地获取token
    String token = preferences.getString('token');
    //时间戳
    var time = DateTime.now().millisecondsSinceEpoch;
    //请求参数
    Map<String,dynamic> map = {
      'token' : token,
      'app_sid' : 'lxy',
      'api' : 'find_city_weather',
      'cityname' : widget.cityName,
      'time' : time,
    };
    map['sign'] = MySign.getSign(map);
    //发送请求
    var result = await DioManager.getInstance().post(MyUrls.FIND_CITY_WEATHER, map);
    print("--------------------------result:" + result.toString());
    _weatherBean = WeatherBean.fromJson(result);
    //将获取的数据添加到列表中，节约网络资源
    dataList.add(_weatherBean);
    //加载成功
    isOK = true;
  }
}