import 'package:flutter/material.dart';
import 'package:streamly/util/view_util.dart';
import 'package:streamly/widget/dark_mode_item.dart';
import 'package:streamly/widget/hi_blur.dart';
import 'package:streamly/widget/hi_flexible_header.dart';

import '../core/hi_base_tab_state.dart';
import '../http/core/hi_error.dart';
import '../http/dao/profile_dao.dart';
import '../model/profile_mo.dart';
import '../widget/benefit_card.dart';
import '../widget/course_card.dart';
import '../widget/hi_banner.dart';

///Profile
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  ProfileMo? _profileMo;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[_buildAppBar()];
        },
        body: ListView(
          padding: EdgeInsets.only(top: 10),
          children: [..._buildContentList()],
        ),
      ),
    );
  }

  void _loadData() async {
    try {
      ProfileMo result = await ProfileDao.get();
      print(result);
      setState(() {
        _profileMo = result;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildHead() {
    if (_profileMo == null) return Container();
    return HiFlexibleHeader(
        name: _profileMo!.name,
        face: _profileMo!.face,
        controller: _controller);
  }

  _buildContentList() {
    if (_profileMo == null) {
      return [];
    }
    return [
      _buildBanner(),
      CourseCard(courseList: _profileMo!.courseList),
      BenefitCard(
        benefitList: _profileMo!.benefitList,
        computerCourses: [
          'Introduction to Programming',
          'Data Structures & Algorithms',
          'Machine Learning Fundamentals',
          'Database Management Systems',
          'Cloud Computing',
          'Computer Networks',
        ],
      ),
      DarkModelItem()
    ];
  }

  _buildBanner() {
    if (_profileMo?.bannerList != null) {
      updateBannerCovers(_profileMo!.bannerList);
    }

    return HiBanner(
      _profileMo!.bannerList,
      bannerHeight: 120,
      padding: EdgeInsets.only(left: 10, right: 10),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        titlePadding: EdgeInsets.only(left: 0),
        title: _buildHead(),
        background: Stack(
          children: [
            Positioned.fill(
              child: cachedImage(
                  'https://smarthistory.org/wp-content/uploads/2021/12/Cranes-painting-570x350.jpg'),
            ),
            Positioned.fill(
                child: HiBlur(
              sigma: 10,
            )),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildProfileTab(),
            )
          ],
        ),
      ),
    );
  }

  _buildProfileTab() {
    if (_profileMo == null) return Container();
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(color: Colors.white54),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText('Favorites', _profileMo!.favorite),
          _buildIconText('Likes', _profileMo!.like),
          _buildIconText('Views', _profileMo!.browsing),
          _buildIconText('Coins', _profileMo!.coin),
          _buildIconText('Followers', _profileMo!.fans),
        ],
      ),
    );
  }

  _buildIconText(String text, int count) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 15, color: Colors.black87)),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
