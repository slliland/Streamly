import 'package:flutter/material.dart';
import 'package:streamly/page/ranking_tab_page.dart';

import '../http/dao/ranking_dao.dart';
import '../util/view_util.dart';
import '../widget/hi_tab.dart';
import '../widget/navigation_bar.dart';

/// Ranking
class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage>
    with TickerProviderStateMixin {
  static const TABS = [
    {"key": "like", "name": "最热"},
    {"key": "pubdate", "name": "最新"},
    {"key": "favorite", "name": "收藏"}
  ];

  // Translation map for tab names
  final Map<String, String> tabTranslations = {
    "最热": "Hottest",
    "最新": "Latest",
    "收藏": "Your Collection",
  };

  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: TABS.length, vsync: this);
    RankingDao.get("like");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_buildNavigationBar(), _buildTabView()],
      ),
    );
  }

  _buildNavigationBar() {
    return MyNavigationBar(
      height: 70, // Adjust height for enough space
      statusStyle: StatusStyle.DARK_CONTENT,
      child: Center(
        // Use Center to ensure vertical and horizontal alignment
        child: Container(
          decoration: bottomBoxShadow(),
          child: _tabBar(),
        ),
      ),
    );
  }

  _tabBar() {
    // Define icons for each tab
    final Map<String, IconData> tabIcons = {
      "最热": Icons.whatshot, // Updated to use a flame icon
      "最新": Icons.update, // Update icon for "Latest"
      "收藏": Icons.bookmark, // Bookmark icon for "Your Collection"
    };

    return HiTab(
      TABS.map<Tab>((tab) {
        return Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (tabIcons[tab['name']] != null) ...[
                Icon(
                  tabIcons[tab['name']], // Icon based on tab name
                  size: 18, // Adjust icon size
                ),
                SizedBox(width: 8), // Space between icon and text
              ],
              Text(
                tabTranslations[tab['name']] ??
                    tab['name']!, // Translated names
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      }).toList(),
      fontSize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
      controller: _controller,
    );
  }

  _buildTabView() {
    return Flexible(
      child: TabBarView(
        controller: _controller,
        children: TABS.map((tab) {
          return RankingTabPage(sort: tab['key'] as String);
        }).toList(),
      ),
    );
  }
}
