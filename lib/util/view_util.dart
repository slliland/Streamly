import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hi_base/format_util.dart';
import 'package:provider/provider.dart';

import '../model/home_mo.dart';
import '../navigator/hi_navigator.dart';
import '../page/profile_page.dart';
import '../page/video_detail_page.dart';
import '../provider/theme_provider.dart';
import 'package:hi_base/color.dart';

enum StatusStyle { LIGHT_CONTENT, DARK_CONTENT }

/// Modify status bar
void changeStatusBar(
    {color = Colors.white,
    StatusStyle statusStyle = StatusStyle.DARK_CONTENT,
    BuildContext? context}) {
  if (context != null) {
    //fix Tried to listen to a value exposed with provider, from outside of the widget tree.
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (themeProvider.isDark()) {
      statusStyle = StatusStyle.LIGHT_CONTENT;
      color = HiColor.dark_bg;
    }
  }
  var page = HiNavigator.getInstance().getCurrent()?.page;
  //fix Android switch to profile, status bar changed to white's issue
  if (page is ProfilePage) {
    color = Colors.transparent;
  } else if (page is VideoDetailPage) {
    color = Colors.black;
    statusStyle = StatusStyle.LIGHT_CONTENT;
  }
  // Immersive status bar style
  var brightness;
  if (Platform.isIOS) {
    brightness = statusStyle == StatusStyle.LIGHT_CONTENT
        ? Brightness.dark
        : Brightness.light;
  } else {
    brightness = statusStyle == StatusStyle.LIGHT_CONTENT
        ? Brightness.light
        : Brightness.dark;
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    statusBarBrightness: brightness,
    statusBarIconBrightness: brightness,
  ));
}

/// border line
borderLine(BuildContext context, {bottom = true, top = false}) {
  var themeProvider = context.watch<ThemeProvider>();
  var lineColor = themeProvider.isDark() ? Colors.grey : Colors.grey[200];
  BorderSide borderSide = BorderSide(width: 0.5, color: lineColor!);
  return Border(
      bottom: bottom ? borderSide : BorderSide.none,
      top: top ? borderSide : BorderSide.none);
}

/// Bottom shadow
BoxDecoration? bottomBoxShadow(BuildContext context) {
  var themeProvider = context.watch<ThemeProvider>();
  if (themeProvider.isDark()) {
    return null;
  }
  return BoxDecoration(color: Colors.white, boxShadow: [
    BoxShadow(
        color: Colors.grey[100]!,
        offset: Offset(0, 5), // Offset on the x and y axes
        blurRadius: 5.0, // Degree of shadow blur
        spreadRadius: 1 // Degree of shadow spread
        )
  ]);
}

void updateBannerCovers(List<BannerMo> bannerList) {
  for (var banner in bannerList) {
    if (banner.subtitle != null) {
      if (banner.subtitle!.contains('全新Flutter从入门到进阶')) {
        // Replace with a local image for the subtitle containing "全新Flutter从入门到进阶"
        banner.cover = 'images/banner_eg_1.jpg';
      } else if (banner.subtitle!.contains('ChatGPT + Flutter快速开发多端聊天机器人App')) {
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
