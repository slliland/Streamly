import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum StatusStyle { LIGHT_CONTENT, DARK_CONTENT }

/// Image with caching
Widget cachedImage(
  String url, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover, // Added fit parameter with default value
}) {
  return CachedNetworkImage(
    height: height,
    width: width,
    fit: fit, // Utilize the fit parameter
    placeholder: (
      BuildContext context,
      String url,
    ) =>
        Container(color: Colors.grey[200]),
    errorWidget: (
      BuildContext context,
      String url,
      dynamic error,
    ) =>
        Icon(Icons.error),
    imageUrl: url,
  );
}

/// Black linear gradient
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: [
        Colors.black54,
        Colors.black45,
        Colors.black38,
        Colors.black26,
        Colors.black12,
        Colors.transparent
      ]);
}

/// Modify status bar
void changeStatusBar(
    {color = Colors.white,
    StatusStyle statusStyle = StatusStyle.DARK_CONTENT,
    BuildContext? context}) {
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
