import 'package:flutter/material.dart';
import 'package:flukit/flukit.dart';
import 'package:lexiyang/video/event_bus.dart';
import 'package:lexiyang/video/video_widget.dart';
import 'package:lexiyang/video/constant.dart';

class VideoPage extends StatefulWidget {

  static int firstInitTimes = 1;

  @override
  VideoPageState createState() {
    return VideoPageState();
  }
}

//抖音效果，向下滑动播放下一个视频
class VideoPageState extends State<VideoPage> {
  SwiperController _controller = SwiperController();

  var movieList = [
    'http://hotsoon.snssdk.com/hotsoon/item/video/_playback/?video_id=8c03eff5c4e944b7bea6a8b50fc26a08&line=0&watermark=1&app_id=1112',
    'http://vt1.doubanio.com/201902111139/0c06a85c600b915d8c9cbdbbaf06ba9f/view/movie/M/302420330.mp4',
    'http://vt1.doubanio.com/201903032315/702b9ad25c0da91e1c693e5e4dc5a86e/view/movie/M/302430864.mp4',
    'http://hotsoon.snssdk.com/hotsoon/item/video/_playback/?video_id=8c03eff5c4e944b7bea6a8b50fc26a08&line=0&watermark=1&app_id=1112',
    'http://vt1.doubanio.com/201902090910/dd9181df828eebda0ee938828c156240/view/movie/M/302420843.mp4',
    'http://vt1.doubanio.com/201902090910/6b6a39c748dcc07231237b3417ee82d9/view/movie/M/302420770.mp4',
    'http://vt1.doubanio.com/201902090910/c1fe01d95232489f1ae86f16ff49e2dc/view/movie/M/302420500.mp4',
    'http://vt1.doubanio.com/201902090910/2adbf280ef6592e5e226c01a8dcef08c/view/movie/M/302410728.mp4',
    'http://vt1.doubanio.com/201902090910/b66baefd889c7469920a50c9038b7cf0/view/movie/M/302430004.mp4',
    'http://vt1.doubanio.com/201902090910/32c7149abe26ab663bfae4521d3e0b24/view/movie/M/302420036.mp4',
    'http://vt1.doubanio.com/201902090910/167419e47d57eb052524bc5b4a4455f8/view/movie/M/302400174.mp4',
    'http://vt1.doubanio.com/201902090910/6b6a39c748dcc07231237b3417ee82d9/view/movie/M/302420770.mp4',
    'http://vt1.doubanio.com/201902090910/2adbf280ef6592e5e226c01a8dcef08c/view/movie/M/302410728.mp4',
  ];

  @override
  void dispose() {
    super.dispose();
    VideoPage.firstInitTimes = 1;
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.page.floor() == _controller.page) {
        eventBus.emit(
          EventVideoPlayPosition + _controller.page.floor().toString(),
          _controller.page.floor()
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List.generate(13, (i) => buildVideoItem(i));
    return Scaffold(
      body: Swiper(
        autoStart: false,
        circular: false,
        direction: Axis.vertical,
        children: children,
        controller: _controller,
      )
    );
  }

  Widget buildVideoItem(int position) {
    print(position.toString());
    return VideoWidget(
      movieList[position],
      positionTag: position,
    );
  }
}