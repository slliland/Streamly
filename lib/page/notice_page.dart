import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/hi_base_tab_state.dart';
import '../http/dao/notice_dao.dart';
import '../model/home_mo.dart';
import '../model/notice_mo.dart';
import '../widget/navigation_bar.dart';
import '../widget/notice_card.dart';

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends HiBaseTabState<NoticeMo, BannerMo, NoticePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildNavigationBar(context), // Pass context here
          Expanded(child: super.build(context)),
        ],
      ),
    );
  }

  _buildNavigationBar(BuildContext context) {
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
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black54.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3), // Slight shadow for depth
            ),
          ],
        ),
        alignment: Alignment.center,
        padding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Adds spacing
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Icon(
                Icons.arrow_back_ios,
                color:
                    isDarkMode ? Colors.white : Colors.black, // Dynamic color
                size: 20,
              ),
            ),
            // Title
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Dynamic color
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
            // Placeholder for alignment
            SizedBox(
                width: 20), // To balance the space taken by the back button
          ],
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
            NoticeCard(bannerMo: dataList[index]),
      );

  @override
  Future<NoticeMo> getData(int pageIndex) async {
    try {
      return await NoticeDao.noticeList(pageIndex: pageIndex, pageSize: 10);
    } catch (e) {
      showWarnToast("Failed to load notifications: ${e.toString()}");
      rethrow;
    }
  }

  @override
  List<BannerMo> parseList(NoticeMo result) {
    return result.list ?? []; // Ensure a non-null list
  }
}
