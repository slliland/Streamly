import 'package:flutter/material.dart';
import 'package:streamly/core/hi_state.dart';
import 'package:streamly/http/dao/home_dao.dart';
import 'package:streamly/model/home_mo.dart';
import 'package:streamly/model/video_model.dart';
import 'package:streamly/navigator/hi_navigator.dart';
import 'package:streamly/widget/loading_container.dart';
import 'package:translator/translator.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'package:streamly/widget/navigation_bar.dart';

import '../http/core/hi_error.dart';
import '../util/color.dart';
import '../util/toast.dart';
import '../util/view_util.dart';
import 'home_tab_page.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;
  const HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var listener;
  late TabController _controller;
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: categoryList.length, vsync: this);
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      print('home:current:${current.page}');
      print('home:pre:${pre.page}');

      /// Page is opened
      if (widget == current.page || current.page is HomePage) {
        print('Opened the home page:onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('Home Page:onPause');
      }
    });
    loadData();
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this.listener);
    // Must map with creation of the _controller
    _controller.dispose();
    super.dispose();
  }

  void convertCategoryListToEnglish() async {
    final translator = GoogleTranslator();
    for (var category in categoryList) {
      // Access the 'text' property of the Translation object
      category.name =
          (await translator.translate(category.name ?? '', to: 'en')).text;
    }
    setState(() {});
  }

  void updateBannerCovers(List<BannerMo> bannerList) {
    for (var banner in bannerList) {
      if (banner.subtitle != null) {
        if (banner.subtitle!.contains('全新Flutter从入门到进阶')) {
          // Replace with a local image for the subtitle containing "全新Flutter从入门到进阶"
          banner.cover = 'images/banner_eg_1.jpg';
        } else if (banner.subtitle!
            .contains('ChatGPT + Flutter快速开发多端聊天机器人App')) {
          // Replace with a local image for the subtitle containing "ChatGPT + Flutter"
          banner.cover = 'images/banner_eg_2.jpg';
        } else if (banner.subtitle!.contains('Flutter高级进阶实战 仿哔哩哔哩APP')) {
          // Replace with a local image for the subtitle containing "Flutter高级进阶实战"
          banner.cover = 'images/banner_eg_3.jpg';
        } else if (banner.subtitle!.contains('移动端普通工程师到架构师的全方位蜕变')) {
          // Replace with a local image for the subtitle containing "移动端普通工程师到架构师"
          banner.cover = 'images/banner_eg_4.jpg';
        } else {}
      } else {
        // Assign a default local image if subtitle is null
        banner.cover = 'images/banner_default.jpg';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: LoadingContainer(
      isLoading: _isLoading,
      child: Column(
        children: [
          MyNavigationBar(
            height: 50,
            child: _appBar(),
            color: Colors.white,
            statusStyle: StatusStyle.DARK_CONTENT,
          ),
          Container(
            color: Colors.white,
            child: _tabBar(),
          ),
          // Make page changes according to its tab
          Flexible(
              child: TabBarView(
                  controller: _controller,
                  children: categoryList.map((tab) {
                    return HomeTabPage(
                      categoryName: tab.name ?? 'Unknown',
                      bannerList: (tab.name == '推荐' || tab.name == 'recommend')
                          ? bannerList
                          : null,
                    );
                  }).toList()))
        ],
      ),
    ));
  }

  // Ensure not create duplicate pages while tab changes
  @override
  bool get wantKeepAlive => true;

  /// Customized Header Tabs
  _tabBar() {
    return TabBar(
        controller: _controller,
        isScrollable: true,
        labelColor: Colors.black,
        indicator: UnderlineIndicator(
            strokeCap: StrokeCap.round,
            borderSide: BorderSide(color: primaryColor.shade500, width: 3),
            insets: EdgeInsets.only(left: 15, right: 15)),
        tabs: categoryList.map<Tab>((tab) {
          return Tab(
              child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tab.name ?? 'Unknown',
              style: TextStyle(fontSize: 16),
            ),
          ));
        }).toList());
  }

  void loadData() async {
    try {
      HomeMo result = await HomeDao.get("推荐");
      print('loadData():$result');
      if (result.categoryList != null) {
        // Dispose of the old controller before creating a new one
        // _controller.dispose();
        _controller = TabController(
            length: result.categoryList?.length ?? 0, vsync: this);
      }
      List<BannerMo> updatedBannerList = result.bannerList ?? [];
      updateBannerCovers(updatedBannerList);

      setState(() {
        categoryList = result.categoryList ?? [];
        bannerList = result.bannerList ?? [];
        _isLoading = false;
      });

      // Translate category names to English after updating the list
      convertCategoryListToEnglish();
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
    }
  }

  _appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.onJumpTo != null) {
                widget.onJumpTo!(3);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Image(
                height: 46,
                width: 46,
                image: AssetImage('images/avatar.png'),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.only(left: 10),
                height: 32,
                alignment: Alignment.centerLeft,
                child: Icon(Icons.search, color: Colors.grey),
                decoration: BoxDecoration(color: Colors.grey[100]),
              ),
            ),
          )),
          Icon(
            Icons.explore_outlined,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Icon(
              Icons.mail_outline,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
