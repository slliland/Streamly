import 'package:flutter/material.dart';
import 'package:flutter_nested/flutter_nested.dart';
import 'package:streamly/model/home_mo.dart';
import 'package:streamly/util/color.dart';
import 'package:streamly/widget/hi_banner.dart';

import '../http/core/hi_error.dart';
import '../http/dao/home_dao.dart';
import '../model/video_model.dart';
import '../util/toast.dart';
import '../widget/video_card.dart';

/// Represents a home tab page with videos and a banner.
class HomeTabPage extends StatefulWidget {
  final String categoryName; // Category name for fetching data
  final List<BannerMo>? bannerList; // List of banners to display

  const HomeTabPage({Key? key, required this.categoryName, this.bannerList})
      : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

/// State class for the `HomeTabPage`, includes data loading and UI updates.
class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  List<VideoModel> videoList = []; // List of videos displayed on the page
  int pageIndex = 1; // Current page index for pagination
  bool _loading = false; // Tracks if a data load operation is ongoing
  ScrollController _scrollController =
      ScrollController(); // Scroll controller for detecting scroll events

  // 分类名称映射表
  final Map<String, String> categoryNameMap = {
    "recommend": "推荐",
    "funny": "搞笑",
    "daily": "日常",
    "comprehensive": "综合",
    "Ghosts": "鬼畜调教",
    "MAD·AMV": "MAD·AMV",
    "Mobile game": "手机游戏",
    "Stand -alone game": "单机游戏",
    "Short film · Handbook · Dubbing": "短片·手书·配音"
  };

  @override
  void initState() {
    super.initState();
    // Add a scroll listener to detect when user scrolls near the bottom
    _scrollController.addListener(() {
      var dis = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      print('dis:$dis');
      // Load more data when the user scrolls near the bottom and no other loading is in progress
      if (dis < 300 && !_loading) {
        print('------_loadData---');
        _loadData(loadMore: true);
      }
    });
    _loadData(); // Initial data load
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose(); // Dispose of the scroll controller
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _loadData, // Triggered when user pulls down to refresh
      color: primaryColor, // Refresh indicator color
      child: MediaQuery.removePadding(
        removeTop: true, // Remove default padding at the top
        context: context,
        child: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: HiNestedScrollView(
            controller: _scrollController,
            itemCount: videoList.length,
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            headers: [
              if (widget.bannerList != null)
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: _banner(),
                )
            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (BuildContext context, int index) {
              return VideoCard(videoMo: videoList[index]);
            },
          ),
        ),
      ),
    );
  }

  /// Builds the banner widget.
  _banner() {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: HiBanner(widget.bannerList!));
  }

  /// Loads data from the server with support for pagination and pull-to-refresh.
  Future<void> _loadData({loadMore = false}) async {
    _loading = true; // Indicate that loading is in progress
    if (!loadMore) {
      pageIndex = 1; // Reset page index for refresh
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0); // Determine current page
    print('loading:currentIndex:$currentIndex');

    // 使用映射表获取中文分类名
    String translatedCategoryName =
        categoryNameMap[widget.categoryName] ?? widget.categoryName;

    print('Mapped category name: $translatedCategoryName');
    try {
      // Fetch data from server using the mapped category name
      HomeMo result = await HomeDao.get(translatedCategoryName,
          pageIndex: currentIndex, pageSize: 10);
      setState(() {
        if (loadMore) {
          if (result.videoList!.isNotEmpty) {
            // Append new videos to the list
            videoList = [...videoList, ...?result.videoList];
            pageIndex++;
          }
        } else {
          // Replace the list during refresh
          videoList = result.videoList!;
        }
      });
      // Allow some time before marking loading as complete
      Future.delayed(Duration(milliseconds: 1000), () {
        _loading = false;
      });
    } on NeedAuth catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message); // Show warning message
    } on HiNetError catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message); // Show error message
    }
  }

  @override
  bool get wantKeepAlive => true; // Preserve the state when switching tabs
}
