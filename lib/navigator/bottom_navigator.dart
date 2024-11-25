import 'package:flutter/material.dart';

import '../page/favorite_page.dart';
import '../page/home_page.dart';
import '../page/profile_page.dart';
import '../page/ranking_page.dart';
import '../util/color.dart';
import 'hi_navigator.dart';

class BottomNavigator extends StatefulWidget {
  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primaryColor.shade500; // Use a specific shade
  int _currentIndex = 0;
  static int initialPage = 0;
  final PageController _controller = PageController(initialPage: initialPage);
  late List<Widget> _pages;

  /// Only call it when first building
  bool _hasBuild = false;

  @override
  Widget build(BuildContext context) {
    _pages = [
      HomePage(onJumpTo: (index) => _onJumpTo(index, pageChange: false)),
      RankingPage(),
      FavoritePage(),
      ProfilePage()
    ];
    if (!_hasBuild) {
      // Notify which tab is opened when the page is first built
      HiNavigator.getInstance()
          .onBottomTabChange(initialPage, _pages[initialPage]);
      _hasBuild = true;
    }

    return Scaffold(
      body: PageView(
        controller: _controller,
        children: _pages,
        // Sync tab with scrolling screen
        onPageChanged: (index) => _onJumpTo(index, pageChange: true),
        // Make sure tab won't have more animations
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onJumpTo(index),

        /// Fix label at the bottom
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _activeColor, // Use the corrected color
        items: [
          _bottomItem('Home', Icons.home, 0),
          _bottomItem('Rank', Icons.local_fire_department, 1),
          _bottomItem('Fav', Icons.favorite, 2),
          _bottomItem('Me', Icons.live_tv, 3),
        ],
      ),
    );
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(icon, color: _defaultColor),
        activeIcon: Icon(icon, color: _activeColor), // Use the corrected color
        label: title);
  }

  void _onJumpTo(int index, {pageChange = false}) {
    if (!pageChange) {
      // Let PageView display the corresponding tab
      _controller.jumpToPage(index);
    } else {
      HiNavigator.getInstance().onBottomTabChange(index, _pages[index]);
    }
    setState(() {
      // Control selection of the tab
      _currentIndex = index;
    });
  }
}
