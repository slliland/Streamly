import 'package:flutter/material.dart';
import 'package:streamly/page/dark_mode_page.dart';
import 'package:streamly/page/home_page.dart';
import 'package:streamly/page/login_page.dart';
import 'package:streamly/page/registration_page.dart';
import 'package:streamly/page/video_detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../page/notice_page.dart';
import 'bottom_navigator.dart';

typedef RouteChangeListener(RouteStatusInfo current, RouteStatusInfo? pre);

/// Creates a page
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

/// Gets the index of routeStatus in the page stack
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

/// Custom route wrapper, route status
enum RouteStatus {
  login,
  registration,
  home,
  detail,
  unknown,
  notice,
  darkMode
}

/// Gets the RouteStatus corresponding to a page
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is BottomNavigator) {
    return RouteStatus.home;
  } else if (page.child is NoticePage) {
    return RouteStatus.notice;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else if (page.child is DarkModePage) {
    return RouteStatus.darkMode;
  } else {
    return RouteStatus.unknown;
  }
}

/// Route information
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

/// Listens for route page transitions
/// Monitors if the current page is sent to the background
class HiNavigator extends _RouteJumpListener {
  static HiNavigator? _instance;
  RouteJumpListener? _routeJump;
  List<RouteChangeListener> _listeners = [];
  RouteStatusInfo? _current;
  RouteStatusInfo? _bottomTab;

  HiNavigator._();

  static HiNavigator getInstance() {
    _instance ??= HiNavigator._();
    return _instance!;
  }

  RouteStatusInfo? getCurrent() {
    return _current;
  }

  /// Open H5 pages
  Future<bool> openH5(String url) async {
    var result = await canLaunch(url);
    if (result) {
      return await launch(url);
    } else {
      return Future.value(false);
    }
  }

  /// Listener for switching home page bottom tabs
  void onBottomTabChange(int index, Widget page) {
    _bottomTab = RouteStatusInfo(RouteStatus.home, page);
    _notify(_bottomTab!);
  }

  /// Registers route jump logic
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    this._routeJump = routeJumpListener;
  }

  /// Adds a listener for route page transitions
  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// Removes a listener
  void removeListener(RouteChangeListener listener) {
    _listeners.remove(listener);
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump?.onJumpTo(routeStatus, args: args);
  }

  /// Notifies of route page changes
  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) return;
    var current =
        RouteStatusInfo(getStatus(currentPages.last), currentPages.last.child);
    _notify(current);
  }

  void _notify(RouteStatusInfo current) {
    if (current.page is BottomNavigator && _bottomTab != null) {
      // If the opened page is the home page, specify the exact tab of the home page
      current = _bottomTab!;
    }
    print('hi_navigator:current:${current.page}');
    print('hi_navigator:pre:${_current?.page}');
    _listeners.forEach((listener) {
      listener(current, _current);
    });
    _current = current;
  }
}

/// Abstract class for HiNavigator to implement
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map? args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

/// Defines the functionality required for route jump logic
class RouteJumpListener {
  final OnJumpTo onJumpTo;

  RouteJumpListener({required this.onJumpTo});
}
