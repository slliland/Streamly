import 'dart:io';

import 'package:flutter/material.dart';
import 'package:streamly/model/video_model.dart';
import 'package:streamly/widget/appBar.dart';
import 'package:streamly/widget/video_view.dart';

import '../util/view_util.dart';
import '../widget/hi_tab.dart';
import '../widget/navigation_bar.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoDetailPage(this.videoModel);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  List tabs = ["Intro", "Comments: 288"];

  @override
  void initState() {
    super.initState();
    //黑色状态栏，仅Android
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _controller = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
          removeTop: Platform.isIOS,
          context: context,
          child: Column(
            children: [
              //iOS 黑色状态栏
              MyNavigationBar(
                color: Colors.black,
                statusStyle: StatusStyle.LIGHT_CONTENT,
                height: Platform.isAndroid ? 0 : 46,
              ),
              _buildVideoView(),
              _buildTabNavigation(),
            ],
          )),
    );
  }

  _buildVideoView() {
    var model = widget.videoModel;
    return VideoView(
      model.url!,
      cover: model.cover,
      overlayUI: videoAppBar(),
    );
  }

  _buildTabNavigation() {
    //使用Material实现阴影效果
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        height: 39,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabBar(),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.live_tv_rounded,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  _tabBar() {
    return HiTab(
      tabs.map<Tab>((name) {
        return Tab(
          text: name,
        );
      }).toList(),
      controller: _controller,
    );
  }
}
