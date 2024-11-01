import 'package:flutter/material.dart';
import 'package:streamly/model/video_model.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoDetailPage(this.videoModel, {Key? key}) : super(key: key);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Detail Page')),
      body: Center(
        child: Text('Video Detail Page, vid: ${widget.videoModel.vid}'),
      ),
    );
  }
}
