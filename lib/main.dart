import 'package:flutter/material.dart';
import 'package:streamly/db/hi_cache.dart';
import 'package:streamly/http/dao/login_dao.dart';
import 'package:streamly/navigator/hi_navigator.dart';
import 'package:streamly/page/home_page.dart';
import 'package:streamly/page/login_page.dart';
import 'package:streamly/page/notice_page.dart';
import 'package:streamly/page/registration_page.dart';
import 'package:streamly/page/video_detail_page.dart';
import 'package:streamly/model/video_model.dart';
import 'package:streamly/util/toast.dart';

import 'http/core/hi_error.dart';
import 'http/core/hi_net.dart';
import 'navigator/bottom_navigator.dart';

void main() {
  runApp(StreamApp());
}

class StreamApp extends StatefulWidget {
  @override
  _StreamAppState createState() => _StreamAppState();
}

class _StreamAppState extends State<StreamApp> {
  StreamRouteDelegate _routeDelegate = StreamRouteDelegate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache>(
        //Using Hicache to pre initialize
        future: HiCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
          //Define Router
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(
                  routerDelegate: _routeDelegate,
                )
              : Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
          return MaterialApp(
            home: widget,
            theme: ThemeData(primarySwatch: Colors.cyan),
          );
        });
  }
}

class StreamRouteDelegate extends RouterDelegate<StreamRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<StreamRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  // Set a key for Navigator. When necessary, you can get the NavigatorState object through navigatorKey.currentState
  StreamRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    // Implementing routing jump logic
    HiNavigator.getInstance().registerRouteJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.detail) {
        this.videoModel = args!['videoMo'];
      }
      notifyListeners();
    }));
    //设置网络错误拦截器
    HiNet.getInstance().setErrorInterceptor((error) {
      if (error is NeedLogin) {
        //清空失效的登录令牌
        HiCache.getInstance().remove(LoginDao.BOARDING_PASS);
        //拉起登录
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      }
    });
  }

  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = [];
  VideoModel? videoModel;

  @override
  Widget build(BuildContext context) {
    //Manage Router Stack
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      //If the page to be opened already exists in the stack, pop the page and all the pages above it out of the stack
      //tips The specific rules can be adjusted as needed. Here, only one instance of the same page is allowed in the stack
      tempPages = tempPages.sublist(0, index);
    }
    var page;
    if (routeStatus == RouteStatus.home) {
      //When jump to the home page, other pages should be out of the stack, because home page can not roll back
      pages.clear();
      page = pageWrap(BottomNavigator());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoModel!));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(const RegistrationPage());
    } else if (routeStatus == RouteStatus.notice) {
      page = pageWrap(NoticePage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(const LoginPage());
    }
    //Not keep pages in stack, create a new page, then put it back
    tempPages = [...tempPages, page];

    /// Notify route changes
    HiNavigator.getInstance().notify(tempPages, pages);
    pages = tempPages;
    return WillPopScope(
      //Fix Android physical back button
      onWillPop: () async =>
          !(await navigatorKey.currentState?.maybePop() ?? false),
      child: Navigator(
        key: navigatorKey,
        pages: pages,
        onPopPage: (route, result) {
          if (route.settings is MaterialPage) {
            // Login page not logged in return interception
            if ((route.settings as MaterialPage).child is LoginPage) {
              if (!hasLogin) {
                showWarnToast("Please Log in First");
                return false;
              }
            }
          }
          // Execute return operation
          if (!route.didPop(result)) {
            return false;
          }
          var tempPages = [...pages];
          pages.removeLast();
          // Notify route changes
          HiNavigator.getInstance().notify(pages, tempPages);
          return true;
        },
      ),
    );
  }

  //Router Interception
  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;

  @override
  Future<void> setNewRoutePath(StreamRoutePath path) async {}
}

class StreamRoutePath {
  final String location;

  StreamRoutePath.home() : location = "/";
  StreamRoutePath.detail() : location = "/detail";
}
