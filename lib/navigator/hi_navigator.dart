import 'package:flutter/material.dart';
import 'package:streamly/page/home_page.dart';
import 'package:streamly/page/login_page.dart';
import 'package:streamly/page/registration_page.dart';
import 'package:streamly/page/video_detail_page.dart';

//Init Page
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

//Get current page's location on the page stack
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

//Router Wrap
enum RouteStatus { login, registration, home, detail, unknown }

//Get page's correspond route status
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is HomePage) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknown;
  }
}

//Route information
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}
