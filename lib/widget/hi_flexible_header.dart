import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/view_util.dart';

/// A Header component that can dynamically change position
/// Performance optimization: local refresh application @refresh principle
class HiFlexibleHeader extends StatefulWidget {
  final String name;
  final String face;
  final ScrollController controller;

  const HiFlexibleHeader(
      {Key? key,
      required this.name,
      required this.face,
      required this.controller})
      : super(key: key);

  @override
  _HiFlexibleHeaderState createState() => _HiFlexibleHeaderState();
}

class _HiFlexibleHeaderState extends State<HiFlexibleHeader> {
  static const double MAX_BOTTOM = 40;
  static const double MIN_BOTTOM = 10;

  // Scroll range
  static const MAX_OFFSET = 80;
  double _dyBottom = MAX_BOTTOM;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      var offset = widget.controller.offset;
      print('offset:$offset');
      // Calculate the padding change factor, 0-1
      var dyOffset = (MAX_OFFSET - offset) / MAX_OFFSET;
      // Calculate the specific padding value based on dyOffset
      var dy = dyOffset * (MAX_BOTTOM - MIN_BOTTOM);
      // Boundary protection
      if (dy > (MAX_BOTTOM - MIN_BOTTOM)) {
        dy = MAX_BOTTOM - MIN_BOTTOM;
      } else if (dy < 0) {
        dy = 0;
      }
      setState(() {
        // Calculate the actual padding
        _dyBottom = MIN_BOTTOM + dy;
      });
      print('_dyBottom:$_dyBottom');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(bottom: _dyBottom, left: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: Image(
              height: 46,
              width: 46,
              image: AssetImage('images/avatar.png'),
            ),
          ),
          hiSpace(width: 8),
          Text(
            widget.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Harmonize with the background
              letterSpacing: 1.2,
              shadows: [
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
