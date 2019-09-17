import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {

  @override
  VideoPageState createState() {
    return VideoPageState();
  }
}

class VideoPageState extends State<VideoPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('视频'),
      ),
    );
  }
}