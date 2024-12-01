import 'package:flutter/material.dart';
import 'package:streamly/model/video_model.dart';
import 'package:streamly/widget/video_view.dart';

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
      body: Column(children: [
        Text('Video Detail Page, vid: ${widget.videoModel.vid}'),
        Text('Video Detail Page, title: ${widget.videoModel.title}'),
        _videoView()
      ]),
    );
  }

  _videoView() {
    var model = widget.videoModel;
    return VideoView(model.url!, cover: model.cover!);
  }
}
