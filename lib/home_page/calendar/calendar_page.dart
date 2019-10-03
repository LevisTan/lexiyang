import 'package:flutter/material.dart';
//github日历组件
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

import 'package:flutter_custom_calendar/utils/date_util.dart';

class MyCalendar extends StatefulWidget {

  @override
  MyCalendarState createState() {
    return MyCalendarState();
  }
}

class MyCalendarState extends State<MyCalendar> {

  //顶部显示年份和月份
  String topYearAndMonth;
  String currentDay;
  CalendarController controller;
  //是否为第一次打开，是则显示当前日期，否则选择选中日期
  bool firstLoad = true;

  @override
  void initState() {
    currentDay = "${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日";
    topYearAndMonth = "${DateTime.now().year}年${DateTime.now().month}月";
    controller = new CalendarController(
        weekBarItemWidgetBuilder: () {
          return CustomStyleWeekBarItem();
        },
        dayWidgetBuilder: (dateModel) {
          return CustomStyleDayWidget(dateModel);
        }
    );

    controller.addMonthChangeListener(
      (year,month) {
        setState(() {
          topYearAndMonth = "$year年$month月";
        });
      }
    );

    //刷新选择的时间
    controller.addOnCalendarSelectListener((dateModel) {
      setState(() {
        firstLoad = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('日历'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new IconButton(
                    icon: Icon(Icons.navigate_before),
                    onPressed: () {
                      controller.moveToPreviousMonth();
                    }),
                new Text(topYearAndMonth),
                new IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () {
                      controller.moveToNextMonth();
                    }),
              ],
            ),
            CalendarViewWidget(
              calendarController: controller,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Text(
                  firstLoad ? currentDay : "${controller.getSingleSelectCalendar().toString()}",
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//显示星期的样式
class CustomStyleWeekBarItem extends BaseWeekBar {
  List<String> weekList = ["一", "二", "三", "四", "五", "六", "日"];

  @override
  Widget getWeekBarItem(int index) {
    return new Container(
      child: new Center(
        child: new Text(weekList[index]),
      ),
    );
  }
}

//日历中日期文字的显示样式
class CustomStyleDayWidget extends BaseCustomDayWidget {
  CustomStyleDayWidget(DateModel dateModel) : super(dateModel);

  @override
  void drawNormal(DateModel dateModel, Canvas canvas, Size size) {
    //判断是否为当前日期，是则高亮显示
    bool isCurrentDay = false;
    if (DateTime.now().year == dateModel.year && DateTime.now().month == dateModel.month && DateTime.now().day == dateModel.day) {
      isCurrentDay = true;
    }
    bool isInRange = dateModel.isInRange;

    //顶部的文字
    TextPainter dayTextPainter = new TextPainter()
      ..text = TextSpan(
          text: dateModel.day.toString(),
          style: new TextStyle(
              color: !isInRange ? Colors.grey :
              isCurrentDay ? Colors.blue : Colors.black, fontSize: 16))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    dayTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    dayTextPainter.paint(canvas, Offset(0, 10));

    //下面的文字
    TextPainter lunarTextPainter = new TextPainter()
      ..text = new TextSpan(
          text: dateModel.lunarString,
          style: new TextStyle(
              color: !isInRange ? Colors.grey :
              isCurrentDay ? Colors.blue : Colors.grey, fontSize: 12))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    lunarTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    lunarTextPainter.paint(canvas, Offset(0, size.height / 2));
  }

  @override
  void drawSelected(DateModel dateModel, Canvas canvas, Size size) {
    //绘制背景
    Paint backGroundPaint = new Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;
    double padding = 8;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        (size.width - padding) / 2, backGroundPaint);

    //顶部的文字
    TextPainter dayTextPainter = new TextPainter()
      ..text = TextSpan(
          text: dateModel.day.toString(),
          style: new TextStyle(color: Colors.white, fontSize: 16))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    dayTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    dayTextPainter.paint(canvas, Offset(0, 10));

    //下面的文字
    TextPainter lunarTextPainter = new TextPainter()
      ..text = new TextSpan(
          text: dateModel.lunarString,
          style: new TextStyle(color: Colors.white, fontSize: 12))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    lunarTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    lunarTextPainter.paint(canvas, Offset(0, size.height / 2));
  }
}