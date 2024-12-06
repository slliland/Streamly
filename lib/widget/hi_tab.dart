import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamly/util/color.dart';
import 'package:underline_indicator/underline_indicator.dart';

/// Enhanced Tab changing widget for detail page
class HiTab extends StatelessWidget {
  final List<Widget> tabs;
  final TabController? controller;
  final double fontSize;
  final double borderWidth;
  final double insets;
  final Color unselectedLabelColor;

  const HiTab(
    this.tabs, {
    Key? key,
    this.controller,
    this.fontSize = 13,
    this.borderWidth = 2,
    this.insets = 0, // Reduced insets for better alignment
    this.unselectedLabelColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      labelColor: primaryColor,
      unselectedLabelColor: unselectedLabelColor,
      labelStyle: TextStyle(
        fontSize: fontSize + 2, // Slightly larger for active tab
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
      ),
      indicator: UnderlineIndicator(
        strokeCap: StrokeCap.round, // Rounded indicator
        borderSide: BorderSide(color: primaryColor, width: borderWidth),
        insets: EdgeInsets.symmetric(horizontal: insets),
      ),
      tabs: tabs,
    );
  }
}
