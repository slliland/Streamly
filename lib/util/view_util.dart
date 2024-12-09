import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'format_util.dart';

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

/// mini icon with text
smallIconText(IconData iconData, var text) {
  var style = TextStyle(fontSize: 12, color: Colors.grey);
  if (text is int) {
    text = countFormat(text);
  }
  return [
    Icon(
      iconData,
      color: Colors.grey,
      size: 12,
    ),
    Text(
      ' $text',
      style: style,
    )
  ];
}

/// border line
borderLine(BuildContext context, {bottom = true, top = false}) {
  BorderSide borderSide = BorderSide(width: 0.5, color: Colors.grey[200]!);
  return Border(
    bottom: bottom ? borderSide : BorderSide.none,
    top: top ? borderSide : BorderSide.none,
  );
}

/// space
SizedBox hiSpace({double height = 1, double width = 1}) {
  return SizedBox(height: height, width: width);
}

/// Bottom shadow
BoxDecoration? bottomBoxShadow() {
  return BoxDecoration(color: Colors.white, boxShadow: [
    BoxShadow(
        color: Colors.grey[100]!,
        offset: Offset(0, 5), // Offset on the x and y axes
        blurRadius: 5.0, // Degree of shadow blur
        spreadRadius: 1 // Degree of shadow spread
        )
  ]);
}
