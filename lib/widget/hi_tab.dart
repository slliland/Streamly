import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamly/util/color.dart';
import 'package:underline_indicator/underline_indicator.dart';

/// Tab changing widgets for detail page
class HiTab extends StatelessWidget {
  final List<Widget> tabs;
  final TabController? controller;
  final double fontSize;
  final double borderWidth;
  final double insets;
  final Color unselectedLabelColor;

  const HiTab(this.tabs,
      {Key? key,
      this.controller,
      this.fontSize = 13,
      this.borderWidth = 2,
      this.insets = 15,
      this.unselectedLabelColor = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
        controller: controller,
        isScrollable: true,
        labelColor: primaryColor,
        unselectedLabelColor: unselectedLabelColor,
        labelStyle: TextStyle(fontSize: fontSize),
        indicator: UnderlineIndicator(
            strokeCap: StrokeCap.square,
            borderSide: BorderSide(color: primaryColor, width: borderWidth),
            insets: EdgeInsets.only(left: insets, right: insets)),
        tabs: tabs);
  }
}
