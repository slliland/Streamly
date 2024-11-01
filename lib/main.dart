import 'package:flutter/material.dart';
import 'package:streamly/db/hi_cache.dart';
import 'package:streamly/http/dao/login_dao.dart';
import 'package:streamly/navigator/hi_navigator.dart';
import 'package:streamly/page/home_page.dart';
import 'package:streamly/page/login_page.dart';
import 'package:streamly/page/registration_page.dart';
import 'package:streamly/page/video_detail_page.dart';
import 'package:streamly/model/video_model.dart';

void main() {
  runApp(StreamApp());
}

class StreamApp extends StatefulWidget {
  @override
  _StreamAppState createState() => _StreamAppState();
}

class _StreamAppState extends State<StreamApp> {
  final StreamRouteDelegate _routeDelegate = StreamRouteDelegate();

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
  VideoModel? videoModel;
  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = [];
  StreamRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();

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
      page = pageWrap(HomePage(
        onJumpToDetail: (videoModel) {
          this.videoModel = videoModel;
          notifyListeners();
        },
      ));
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoModel!));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage(onSuccess: () {
        _routeStatus = RouteStatus.home;
        notifyListeners();
      }, onJumpRegistration: () {
        _routeStatus = RouteStatus.registration;
        notifyListeners();
      }));
    }
    //Not keep pages in stack, create a new page, then put it back
    tempPages = [...tempPages, page];
    pages = tempPages;

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        if (videoModel != null) {
          // Clear videoModel to return to home page
          videoModel = null;
          notifyListeners();
        }
        return true;
      },
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
