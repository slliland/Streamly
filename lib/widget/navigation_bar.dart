import 'package:flutter/material.dart';

import '../util/view_util.dart';

class MyNavigationBar extends StatelessWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget? child;
  const MyNavigationBar(
      {Key? key,
      this.statusStyle = StatusStyle.DARK_CONTENT,
      this.color = Colors.white,
      this.height = 10,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + height,
      child: child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: color),
    );
  }

  void _statusBarInit() {
    // Immersive navigation bar
    changeStatusBar(color: color, statusStyle: statusStyle);
  }
}
