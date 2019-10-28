//天气json解析

class WeatherBean {
  int status;
  Payload payload;

  WeatherBean({this.status,this.payload});

  factory WeatherBean.fromJson(Map<String,dynamic> json) {
    return WeatherBean(
      status: json['status'],
      payload: json['status'] == 200 ? Payload.fromJson(json['payload']) : null
    );
  }
}

class Payload {
  String msg;
  Result result;

  Payload({this.msg,this.result});

  factory Payload.fromJson(Map<String,dynamic> json) {
    return Payload(
      msg: json['msg'],
      result: json['msg'] == 'ok' ? Result.fromJson(json['result']) : null
    );
  }
}

class Result {
  String weather;
  String temp;
  String temphigh;
  String templow;
  String humidity;
  String pressure;
  String windspeed;
  String winddirect;
  String windpower;
  String updatetime;

  List<Index> index;
  List<Daily> daily;
  List<Hourly> hourly;

  Result({
    this.temp,this.weather,this.temphigh,this.templow,
    this.humidity,this.pressure,this.index,this.daily,this.hourly,
    this.updatetime, this.winddirect,this.windpower,this.windspeed
  });

  factory Result.fromJson(Map<String,dynamic> json) {
    //处理列表
    var tempIndex = json['index'] as List;
    List<Index> indexList = tempIndex.map((i) => Index.fromJson(i)).toList();

    var tempDaily = json['daily'] as List;
    List<Daily> dailyList = tempDaily.map((i) => Daily.fromJson(i)).toList();

    var tempHourly = json['hourly'] as List;
    List<Hourly> hourlyList = tempHourly.map((i) => Hourly.fromJson(i)).toList();

    return Result(
      weather: json['weather'],
      temp: json['temp'],
      temphigh: json['temphigh'],
      templow: json['templow'],
      humidity: json['humidity'],
      pressure: json['pressure'],
      winddirect: json['winddirect'],
      windpower: json['windpower'],
      windspeed: json['windspeed'],
      updatetime: json['updatetime'],
      index: indexList,
      daily: dailyList,
      hourly: hourlyList
    );
  }
}

//生活指数
class Index {
  String iname;
  String ivalue;
  String detail;

  Index({this.iname,this.ivalue,this.detail});

  factory Index.fromJson(Map<String,dynamic> json) {
    return Index(
      iname: json['iname'],
      ivalue: json['ivalue'],
      detail: json['detail']
    );
  }
}

//未来七天天气
class Daily {
  String date;
  String week;

  DayNight day;
  DayNight night;

  Daily({this.date,this.week,this.day,this.night});

  factory Daily.fromJson(Map<String,dynamic> json) {
    return Daily(
      date: json['date'],
      week: json['week'],
      day: json['day'] == null ? null : DayNight.fromJson(json['day']),
      night: json['night'] == null ? null : DayNight.fromJson(json['night'])
    );
  }
}

//白天和晚间天气
class DayNight {
  String templow;
  String temphigh;
  String img;

  DayNight({this.templow,this.temphigh,this.img});

  factory DayNight.fromJson(Map<String,dynamic> json) {
    return DayNight(
      temphigh: json['temphigh'],
      templow: json['templow'],
      img: json['img']
    );
  }
}

//24小时天气
class Hourly {
  String time;
  String weather;
  String temp;
  String img;

  Hourly({this.time,this.weather,this.img,this.temp});

  factory Hourly.fromJson(Map<String,dynamic> json) {
    return Hourly(
      time: json['time'],
      weather: json['weather'],
      temp: json['temp'],
      img: json['img']
    );
  }
}