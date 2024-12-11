import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_overlay/flutter_overlay.dart';
import 'package:provider/provider.dart';
import 'package:streamly/barrage/hi_socket.dart';
import 'package:streamly/http/core/hi_error.dart';
import 'package:streamly/http/dao/video_detail_dao.dart';
import 'package:streamly/model/video_detail_mo.dart';
import 'package:streamly/model/video_model.dart';
import 'package:streamly/widget/appBar.dart';
import 'package:streamly/widget/video_toolbar.dart';
import 'package:streamly/widget/video_view.dart';

import 'package:streamly/model/video_model.dart';
import 'package:translator/translator.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../barrage/barrage_input.dart';
import '../barrage/barrage_switch.dart';
import '../barrage/hi_barrage.dart';
import '../http/dao/favorite_dao.dart';
import '../http/dao/like_dao.dart';
import '../provider/theme_provider.dart';
import '../util/color.dart';
import '../util/hi_constants.dart';
import '../util/toast.dart';
import '../util/view_util.dart';
import '../widget/expandable_content.dart';
import '../widget/hi_tab.dart';
import '../widget/navigation_bar.dart';
import '../widget/video_header.dart';
import '../widget/video_large_card.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoDetailPage(this.videoModel);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  List tabs = ["Intro", "Comm: 288"];
  VideoDetailMo? videoDetailMo;
  VideoModel? videoModel;
  List<VideoModel> videoList = [];
  var _barrageKey = GlobalKey<HiBarrageState>();
  bool _inoutShowing = false;
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = context.read<ThemeProvider>();
    // Black status bar, only on Android
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _controller = TabController(length: tabs.length, vsync: this);
    videoModel = widget.videoModel;
    _loadDetail();
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
          child: videoModel?.url != null
              ? Column(
                  children: [
                    //iOS black navigator
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
                        Center(
                          child: Text(
                            'Coming soon...',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ],
                    ))
                  ],
                )
              : Container()),
    );
  }

  _buildVideoView() {
    var model = videoModel;
    return VideoView(
      model!.url!,
      cover: model.cover,
      overlayUI: videoAppBar(),
      barrageUI: HiBarrage(
          headers: HiConstants.headers(),
          key: _barrageKey,
          vid: model.vid,
          autoPlay: true),
    );
  }

  _buildTabNavigation() {
    return Material(
      elevation: 5,
      shadowColor: _themeProvider.isDark() ? HiColor.dark_bg : Colors.grey[100],
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(
            horizontal: 5), // Minimize left and right padding
        child: Row(
          children: [
            // TabBar on the left
            Flexible(
              child: Container(
                alignment: Alignment.centerLeft, // Align TabBar to the left
                margin: EdgeInsets.only(
                    right: 15), // Add space between TabBar and Button
                child: TabBar(
                  controller: _controller,
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  indicator: UnderlineIndicator(
                    strokeCap: StrokeCap.round,
                    borderSide: BorderSide(
                      color: primaryColor,
                      width: 3,
                    ),
                    insets: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  labelColor: primaryColor,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: tabs
                      .map((tab) => Padding(
                            padding:
                                EdgeInsets.only(right: 5), // Adjust tab spacing
                            child: Tab(text: tab),
                          ))
                      .toList(),
                ),
              ),
            ),
            // Space for Barrage Button
            _buildBarrageBtn(),
          ],
        ),
      ),
    );
  }

  _buildDetailList() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [...buildContents(), ..._buildVideoList()],
    );
  }

  buildContents() {
    return [
      VideoHeader(
        owner: videoModel!.owner,
      ),
      ExpandableContent(mo: videoModel!),
      VideoToolBar(
        detailMo: videoDetailMo,
        videoModel: videoModel!,
        onLike: _doLike,
        onUnLike: _onUnLike,
        onFavorite: _onFavorite,
      )
    ];
  }

  void _loadDetail() async {
    try {
      VideoDetailMo result = await VideoDetailDao.get(videoModel!.vid);
      print(result);
      setState(() {
        videoDetailMo = result;
        videoModel = result.videoInfo;
        videoList = result.videoList;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  _doLike() async {
    try {
      var result = await LikeDao.like(videoModel!.vid, !videoDetailMo!.isLike);
      print(result);

      // Translate the message
      final translator = GoogleTranslator();
      var translatedMsg = await translator.translate(result['msg'], to: 'en');

      videoDetailMo!.isLike = !videoDetailMo!.isLike;
      if (videoDetailMo!.isLike) {
        videoModel!.like += 1;
      } else {
        videoModel!.like -= 1;
      }
      setState(() {
        videoDetailMo = videoDetailMo;
        videoModel = videoModel;
      });

      // Display the translated message
      showToast(translatedMsg.text);
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  void _onUnLike() {}

  void _onFavorite() async {
    try {
      var result = await FavoriteDao.favorite(
          videoModel!.vid, !videoDetailMo!.isFavorite);
      print(result);

      videoDetailMo!.isFavorite = !videoDetailMo!.isFavorite;

      if (videoDetailMo!.isFavorite) {
        videoModel!.favorite += 1;
      } else {
        videoModel!.favorite -= 1;
      }

      // Translate result['msg'] to English
      final translator = GoogleTranslator();
      var translatedMsg = await translator.translate(result['msg'], to: 'en');

      setState(() {
        videoDetailMo = videoDetailMo;
        videoModel = videoModel;
      });

      showToast(translatedMsg.text);
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  _buildVideoList() {
    return videoList
        .map((VideoModel mo) => VideoLargeCard(videoModel: mo))
        .toList();
  }

  _buildBarrageBtn() {
    return BarrageSwitch(
        inoutShowing: _inoutShowing,
        onShowInput: () {
          setState(() {
            _inoutShowing = true;
          });
          HiOverlay.show(context, child: BarrageInput(
            onTabClose: () {
              setState(() {
                _inoutShowing = false;
              });
            },
          )).then((value) {
            print('---input:$value');
            _barrageKey.currentState!.send(value);
          });
        },
        onBarrageSwitch: (open) {
          if (open) {
            _barrageKey.currentState!.play();
          } else {
            _barrageKey.currentState!.pause();
          }
        });
  }
}
