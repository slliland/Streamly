import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:hi_base/hi_state.dart';
import 'package:translator/translator.dart';
import 'package:underline_indicator/underline_indicator.dart';

import 'package:streamly/http/dao/home_dao.dart';
import 'package:streamly/model/home_mo.dart';
import 'package:streamly/model/video_model.dart';
import 'package:streamly/navigator/hi_navigator.dart';
import 'package:streamly/page/profile_page.dart';
import 'package:streamly/page/video_detail_page.dart';
import 'package:streamly/widget/loading_container.dart';
import 'package:streamly/widget/navigation_bar.dart';
import '../provider/theme_provider.dart';
import 'package:hi_base/color.dart';
import '../util/toast.dart';

// IMPORTANT: Import view_util.dart for StatusStyle and changeStatusBar
import '../util/view_util.dart';

import '../widget/hi_tab.dart';
import 'home_tab_page.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;
  const HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  var listener;
  TabController? _controller;
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];
  bool _isLoading = true;
  Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    HiNavigator.getInstance().addListener(listener = (current, pre) {
      _currentPage = current.page;
      print('home:current: ${current.page}');
      print('home:pre: ${pre?.page}');

      // If we open HomePage
      if (widget == current.page || current.page is HomePage) {
        print('Opened HomePage:onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('HomePage:onPause');
      }
      // If we left VideoDetailPage and did not go to ProfilePage
      if (pre?.page is VideoDetailPage && !(current.page is ProfilePage)) {
        changeStatusBar(
          color: Colors.white,
          statusStyle: StatusStyle.DARK_CONTENT,
        );
      }
    });

    // Load initial data
    loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    HiNavigator.getInstance().removeListener(listener);
    _controller?.dispose();
    super.dispose();
  }

  // Listen for system dark mode changes
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    context.read<ThemeProvider>().darModeChange();
  }

  /// Monitor lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(':didChangeAppLifecycleState: $state');

    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        // Switch from background to foreground
        if (!(_currentPage is VideoDetailPage)) {
          changeStatusBar(
            color: Colors.white,
            statusStyle: StatusStyle.DARK_CONTENT,
            context: context,
          );
        }
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void convertCategoryListToEnglish() async {
    final translator = GoogleTranslator();
    for (var category in categoryList) {
      category.name =
          (await translator.translate(category.name ?? '', to: 'en')).text;
    }
    setState(() {});
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
              decoration: bottomBoxShadow(context),
              child: _tabBar(),
            ),
            Expanded(
              child: _controller == null
                  ? Container()
                  : TabBarView(
                      controller: _controller,
                      children: categoryList.map((tab) {
                        return HomeTabPage(
                          categoryName: tab.name ?? 'Unknown',
                          bannerList:
                              (tab.name == '推荐' || tab.name == 'recommend')
                                  ? bannerList
                                  : null,
                        );
                      }).toList(),
                    ),
            )
          ],
        ),
      ),
    );
  }

  // Ensure we don't rebuild from scratch when switching tabs
  @override
  bool get wantKeepAlive => true;

  _tabBar() {
    return _controller == null
        ? Container()
        : HiTab(
            categoryList.map<Tab>((tab) {
              return Tab(text: tab.name);
            }).toList(),
            controller: _controller,
            fontSize: 16,
            borderWidth: 3,
            unselectedLabelColor: Colors.black54,
            insets: 13,
          );
  }

  void loadData() async {
    try {
      HomeMo result = await HomeDao.get("推荐");
      print('loadData(): $result');
      List<CategoryMo> categories = result.categoryList ?? [];
      List<BannerMo> banners = result.bannerList ?? [];

      // A function from view_util.dart if needed
      updateBannerCovers(banners);

      final translator = GoogleTranslator();
      for (var category in categories) {
        category.name =
            (await translator.translate(category.name ?? '', to: 'en')).text;
      }

      setState(() {
        categoryList = categories;
        bannerList = banners;
        _isLoading = false;
        // Dispose old controller before creating a new one
        _controller?.dispose();
        _controller = TabController(length: categoryList.length, vsync: this);
      });
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
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () => widget.onJumpTo?.call(3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: const Image(
                height: 46,
                width: 46,
                image: AssetImage('images/avatar.png'),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  height: 32,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(color: Colors.grey[100]),
                  child: const Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: _mockCrash,
            child: const Icon(Icons.explore_outlined, color: Colors.grey),
          ),
          InkWell(
            onTap: () => HiNavigator.getInstance().onJumpTo(RouteStatus.notice),
            child: const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(Icons.mail_outline, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  /// Simulate Crash
  void _mockCrash() async {
    // Use try-catch to capture synchronous exceptions
    try {
      throw StateError('This is a dart exception.');
    } catch (e) {
      print(e);
    }

    // Use catchError to capture asynchronous exceptions
    Future.delayed(const Duration(seconds: 1))
        .then(
            (_) => throw StateError('This is first Dart exception in Future.'))
        .catchError((e) => print(e));

    try {
      await Future.delayed(const Duration(seconds: 1))
          .then((_) =>
              throw StateError('This is second Dart exception in Future.'))
          .catchError((e) => print(e));
    } catch (e) {
      print(e);
    }

    runZonedGuarded(() {
      throw StateError('runZonedGuarded: This is a dart exception.');
    }, (e, s) => print(e));

    runZonedGuarded(() {
      Future.delayed(const Duration(seconds: 1)).then((_) => throw StateError(
            'runZonedGuarded: This is first Dart exception in Future.',
          ));
    }, (e, s) => print(e));

    throw StateError('main: This is second Dart exception.');
  }
}
