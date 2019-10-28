import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'event_bus.dart';
import 'constant.dart';
import 'video_detail_scene.dart';
import 'package:lexiyang/found_video_page/found_video_page_body.dart';
import 'screen.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String url;
  final String previewImgUrl; //预览图片的地址
  final bool showProgressBar; //是否显示进度条
  final bool showProgressText; //是否显示进度文本
  final int positionTag;

  VideoWidget(this.url, {
    Key key,
    this.previewImgUrl: '',
    this.showProgressBar = true,
    this.showProgressText = true,
    this.positionTag
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoWidgetState();
  }
}

class VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController _controller;
  bool _hideActionButton = true;
  bool videoPrepared = false; //视频是否初始化

  //心形按钮
  bool isLike = false;
  int likeCount = 100;

  @override
  void initState() {
    super.initState();
    eventBus.on(EventVideoPlayPosition + widget.positionTag.toString(), (arg) {
      if (arg == widget.positionTag) {
        _controller.play();
        videoPrepared = true;
      } else {
        _controller.pause();
      }
      setState(() {});
    });

    _controller = VideoPlayerController.network(widget.url)
      ..initialize()
      ..setLooping(true).then((_) {
        if (widget.positionTag == 0 && VideoPage.firstInitTimes == 1) {
          VideoPage.firstInitTimes = 2;
          _controller.play();
          videoPrepared = true;
        }
        setState(() {});
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
    eventBus.off(EventVideoPlayPosition + widget.positionTag.toString());
    _controller.dispose(); //释放播放器资源
  }

  Widget getPreviewImg() {
    return Offstage(
      offstage: videoPrepared,
      child: Image.asset(
        widget.previewImgUrl,
        fit: BoxFit.cover,
        width: Screen.width,
        height: Screen.height,
      )
    );
  }

  //点击屏幕显示暂停按钮
  getPauseView() {
    return Offstage(
      offstage: _hideActionButton,
      child: Stack(
        children: <Widget>[
          Align(
            child: Container(
              child: Image.asset('img/ic_playing.png'),
              height: 50,
              width: 50
            ),
            alignment: Alignment.center,
          )
        ],
      ),
    );
  }

  // 右侧评论,分享，转发等功能按钮
  Widget _getRightActionView() {
    //采用Positioned绝对位置布局
    return Positioned (
      bottom: 0,
      right: 0,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 15, 100),
        child: Column(
          children: <Widget>[
            //喜欢按钮
            IconButton(
              icon: Icon(Icons.favorite),
              color: isLike ? Colors.red : Colors.white,
              onPressed: clickLikeButton,
              iconSize: 36.0,
            ),
            //喜欢数量
            Text(
              '$likeCount',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 18),
            //评论按钮
            GestureDetector(
              child: Image.asset('images/video_msg_icon.png',width: 36, height: 36),
              onTap: clickCommentButton,
            ),
            //评论的数量
            Text('1.3w',style: TextStyle(color: Colors.white),),
            SizedBox(height: 18),
            //转发按钮
            IconButton(
              icon: Icon(Icons.share),
              onPressed: clickShareButton,
              color: Colors.white,
              iconSize: 36.0,
            ),
            //转发量
            Text('0.5w',style: TextStyle(color: Colors.white),),
          ],
        ),
      ),
    );
  }

  //喜欢按钮被点击了
  clickLikeButton () {
    setState(() {
      isLike = !isLike;
      if (isLike) {
        likeCount++;
      } else {
        likeCount--;
      }
    });
  }

  //转发事件
  clickShareButton () {
    Share.share('我是乐夕阳，来自猎风工作室');
  }

  //评论事件
  clickCommentButton () {

  }


//  getRightActionView() {
//    return Positioned(
//      bottom: 0,
//      right: 0,
//      child: Container(
//        margin: EdgeInsets.fromLTRB(0, 0, 15, 120),
//        child: Column(
//          children: <Widget>[
//            Container(
//              child: Column(
//                children: <Widget>[
//                  IconButton(
//                    icon: Icon(Icons.favorite),
//                    color: isLike ? Colors.red : Colors.white,
//                    onPressed: () {
//                      setState(() {
//                        isLike = !isLike;
//                      });
//                    }
//                  ),
//                  Text(
//                    "1.6w",
//                    style: TextStyle(
//                      fontSize: 15,
//                      color: Colors.white,
//                      decoration: TextDecoration.none),
//                  )
//            ])),
//            SizedBox(height: 8),
//            Container(
//              child: Column(children: <Widget>[
//              Image.asset('img/video_msg_icon.png',
//                  width: 36, height: 36),
//              Text(
//                "1.3w",
//                style: TextStyle(
//                    fontSize: 15,
//                    color: Colors.white,
//                    decoration: TextDecoration.none),
//              ),
//            ])),
//
//            SizedBox(height: 8),
//            GestureDetector(
//              child: Container(
//                  child: Column(children: <Widget>[
//                Image.asset('img/video_share_icon.png',
//                    width: 36, height: 36),
//                Text(
//                  "2.1w",
//                  style: TextStyle(
//                      fontSize: 15,
//                      color: Colors.white,
//                      decoration: TextDecoration.none),
//                ),
//              ])),
//              onTap: () {
//                Share.share("全最强开源flutter");
//              }),
//          ],
//        )));
//  }

  getLeftActionView() {
    return Positioned(
      child: Container(
          width: Screen.width,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "奔驰G级AMG",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              decoration: TextDecoration.none),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "@没那么简单",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              decoration: TextDecoration.none),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "最爱大奔",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              decoration: TextDecoration.none),
                        ),
                        SizedBox(height: 8),
                      ]),
                ),
                Container(width: Screen.height, height: 1, color: Colors.white),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      "点赞是鼓励，评论才是真爱...",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                    height: 50),
              ])),
      bottom: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      GestureDetector(
        child: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Center(
            child: Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                getPauseView(),
              ],
            ),
          ),
        ),
        onTap: () {
          if (_controller.value.isPlaying) {
            _controller.pause();
            _hideActionButton = false;
          } else {
            _controller.play();
            videoPrepared = true;
            _hideActionButton = true;
          }
          setState(() {});
        },
      ),
      getPreviewImg(), ///预览图
      _getRightActionView()///
      //getRightActionView(), /// 右侧转发，评论按钮
      //getLeftActionView(), /// 左侧文案
    ]);
  }
}
