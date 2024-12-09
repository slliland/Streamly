import 'package:flutter/material.dart';

import 'barrage_transition.dart';

/// Barrage widget
class BarrageItem extends StatelessWidget {
  final String id; // Unique ID for the barrage
  final double top; // Vertical position of the barrage
  final Widget child; // Content of the barrage
  final ValueChanged onComplete; // Callback when animation completes
  final Duration duration; // Duration of the barrage animation

  BarrageItem(
      {Key? key,
      required this.id,
      required this.top,
      required this.onComplete,
      this.duration = const Duration(milliseconds: 9000),
      required this.child})
      : super(key: key);

  // Fix animation state issues
  final _key = GlobalKey<BarrageTransitionState>();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        top: top,
        child: BarrageTransition(
          key: _key,
          child: child,
          onComplete: (v) {
            onComplete(id); // Notify when the animation is complete
          },
          duration: duration,
        ));
  }
}
