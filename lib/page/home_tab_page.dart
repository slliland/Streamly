import 'package:flutter/material.dart';
import 'package:flutter_nested/flutter_nested.dart';
import 'package:streamly/model/home_mo.dart';
import 'package:streamly/util/color.dart';
import 'package:streamly/widget/hi_banner.dart';

import '../core/hi_base_tab_state.dart';
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

/// State class for the `HomeTabPage`, refactored using HiBaseTabState.
class _HomeTabPageState
    extends HiBaseTabState<HomeMo, VideoModel, HomeTabPage> {
  // Category name mapping table
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
  Widget get contentChild => ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: HiNestedScrollView(
          controller: scrollController,
          itemCount: dataList.length,
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
            return VideoCard(videoMo: dataList[index]);
          },
        ),
      );

  /// Builds the banner widget.
  Widget _banner() {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: HiBanner(widget.bannerList!));
  }

  @override
  Future<HomeMo> getData(int pageIndex) async {
    // Use the mapping table to get the category name in Chinese
    String translatedCategoryName =
        categoryNameMap[widget.categoryName] ?? widget.categoryName;

    print('Mapped category name: $translatedCategoryName');

    return await HomeDao.get(
      translatedCategoryName,
      pageIndex: pageIndex,
      pageSize: 10,
    );
  }

  @override
  List<VideoModel> parseList(HomeMo result) {
    return result.videoList ?? [];
  }
}
