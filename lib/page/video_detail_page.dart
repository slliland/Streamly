import 'dart:io';

import 'package:flutter/material.dart';
import 'package:streamly/model/video_model.dart';
import 'package:streamly/widget/appBar.dart';
import 'package:streamly/widget/video_view.dart';

import 'package:streamly/model/video_model.dart' as video;
import 'package:streamly/model/owner.dart' as owner;
import 'package:underline_indicator/underline_indicator.dart';

import '../util/color.dart';
import '../util/view_util.dart';
import '../widget/expandable_content.dart';
import '../widget/hi_tab.dart';
import '../widget/navigation_bar.dart';
import '../widget/video_header.dart';

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
    // Black status bar, only on Android
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
            // iOS Black Status Bar
            MyNavigationBar(
              color: Colors.black,
              statusStyle: StatusStyle.LIGHT_CONTENT,
              height: Platform.isAndroid ? 0 : 46,
            ),
            _buildVideoView(),
            _buildTabNavigation(),
            Flexible(
              child: TabBarView(
                controller: _controller,
                children: [
                  _buildDetailList(),
                  Container(
                    child: Center(
                      child: Text(
                        'Coming soon...',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
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
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 10), // Uniform padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TabBar on the left
            Expanded(
              child: TabBar(
                controller: _controller,
                isScrollable: true,
                indicator: UnderlineIndicator(
                  strokeCap: StrokeCap.round, // Rounded indicator
                  borderSide: BorderSide(color: primaryColor, width: 2),
                  insets: EdgeInsets.symmetric(horizontal: 0),
                ), // No underline
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(fontSize: 14),
                tabs: tabs.map((tab) => Tab(text: tab)).toList(),
              ),
            ),
            // Static Icon on the right
            Padding(
              padding: EdgeInsets.only(left: 10), // Add spacing to the left
              child: Icon(
                Icons.live_tv_rounded,
                color: Colors.grey,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDetailList() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [...buildContents()],
    );
  }

  buildContents() {
    return [
      VideoHeader(
        owner: convertOwner(widget.videoModel.owner),
      ),
      ExpandableContent(mo: widget.videoModel)
    ];
  }

  // Conversion helper
  owner.Owner convertOwner(video.Owner videoOwner) {
    return owner.Owner.fromJson(videoOwner.toJson());
  }
}
