import 'dart:ui';

import 'package:flutter/material.dart';

/// Gaussian Blur
class HiBlur extends StatelessWidget {
  final Widget? child;

  // Blur value
  final double sigma;

  const HiBlur({Key? key, this.sigma = 10, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: Container(
        color: Colors.white10,
        child: child,
      ),
    );
  }
}
