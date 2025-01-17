import 'package:flutter/material.dart';

/// Barrage movement effect
class BarrageTransition extends StatefulWidget {
  final Widget child; // Content of the barrage
  final Duration duration; // Duration of the animation
  final ValueChanged onComplete; // Callback when the animation completes

  const BarrageTransition(
      {Key? key,
      required this.duration,
      required this.onComplete,
      required this.child})
      : super(key: key);

  @override
  BarrageTransitionState createState() => BarrageTransitionState();
}

class BarrageTransitionState extends State<BarrageTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController; // Controls the animation
  late Animation<Offset> _animation; // Handles the movement of the widget

  @override
  void initState() {
    super.initState();
    // Create the animation controller
    _animationController =
        AnimationController(duration: widget.duration, vsync: this)
          ..addStatusListener((status) {
            // Callback when the animation is completed
            if (status == AnimationStatus.completed) {
              widget.onComplete('');
            }
          });
    // Define a right-to-left tween animation
    var begin = Offset(1.0, 0); // Start position (off-screen right)
    var end = Offset(-1.0, 0); // End position (off-screen left)
    _animation = Tween(begin: begin, end: end).animate(_animationController);
    _animationController.forward(); // Start the animation
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation, // Apply the animation to the position
      child: widget.child, // Content of the barrage
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose of the animation controller
    super.dispose();
  }
}
