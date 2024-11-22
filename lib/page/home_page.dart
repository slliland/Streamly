import 'package:flutter/material.dart';
import 'package:streamly/core/hi_state.dart';
import 'package:streamly/http/dao/home_dao.dart';
import 'package:streamly/model/home_mo.dart';
import 'package:streamly/model/video_model.dart';
import 'package:streamly/navigator/hi_navigator.dart';
import 'package:translator/translator.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../http/core/hi_error.dart';
import '../util/color.dart';
import '../util/toast.dart';
import 'home_tab_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 60),
            child: _tabBar(),
          ),
          // Make page changes according to its tab
          Flexible(
              child: TabBarView(
                  controller: _controller,
                  children: categoryList.map((tab) {
                    return HomeTabPage(
                      name: tab.name ?? 'Unknown',
                      bannerList: (tab.name == '推荐' || tab.name == 'recommend')
                          ? bannerList
                          : null,
                    );
                  }).toList()))
        ],
      ),
    );
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
        _controller.dispose();
        _controller = TabController(
            length: result.categoryList?.length ?? 0, vsync: this);
      }

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
}
