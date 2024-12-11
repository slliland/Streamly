import 'package:flutter/material.dart';
import 'package:streamly/page/video_detail_page.dart';
import 'package:streamly/widget/navigation_bar.dart';

import '../core/hi_base_tab_state.dart';
import '../http/dao/favorite_dao.dart';
import '../model/ranking_mo.dart';
import '../model/video_model.dart';
import '../navigator/hi_navigator.dart';
import '../util/view_util.dart';
import '../widget/video_large_card.dart';

/// Favorites
class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState
    extends HiBaseTabState<RankingMo, VideoModel, FavoritePage> {
  late RouteChangeListener listener;

  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      if (pre?.page is VideoDetailPage && current.page is FavoritePage) {
        loadData();
      }
    });
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this.listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildNavigationBar(), Expanded(child: super.build(context))],
    );
  }

  _buildNavigationBar() {
    // Detect the current theme brightness (dark or light)
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return MyNavigationBar(
      height: 60, // Slightly increased height for better appearance
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    Colors.grey.shade900,
                    Colors.grey.shade800,
                  ] // Dark mode gradient
                : [
                    Colors.blue.shade50,
                    Colors.blue.shade500,
                  ], // Light mode gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: isDarkMode
              ? [
                  BoxShadow(
                    color: Colors.black54.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 3), // Slight shadow for depth
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 3), // Slight shadow for depth
                  ),
                ],
        ),
        alignment: Alignment.center,
        padding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Adds spacing
        child: Text(
          'Favorites',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Adjust text color
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 3,
                color: isDarkMode
                    ? Colors.black87 // Subtle shadow for dark mode
                    : Colors.black26, // Subtle shadow for light mode
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  get contentChild => ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount: dataList.length,
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) =>
            VideoLargeCard(videoModel: dataList[index]),
      );

  @override
  Future<RankingMo> getData(int pageIndex) async {
    RankingMo result =
        await FavoriteDao.favoriteList(pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(RankingMo result) {
    return result.list;
  }
}
