import 'dart:io';

import 'package:flutter/material.dart';
import 'package:streamly/model/video_model.dart';
import 'package:streamly/widget/appBar.dart';
import 'package:streamly/widget/video_view.dart';

import '../util/view_util.dart';
import '../widget/navigation_bar.dart';

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
      body: MediaQuery.removePadding(
          removeTop: Platform.isIOS,
          context: context,
          child: Column(children: [
            MyNavigationBar(
              color: Colors.black,
              statusStyle: StatusStyle.LIGHT_CONTENT,
              height: Platform.isAndroid ? 0 : 50,
            ),
            _videoView(),
            Text('Video Detail Page, vid: ${widget.videoModel.vid}'),
            Text('Video Detail Page, title: ${widget.videoModel.title}')
          ])),
    );
  }

  _videoView() {
    var model = widget.videoModel;
    return VideoView(
      model.url!,
      cover: model.cover,
      overlayUI: videoAppBar(),
    );
  }
}
