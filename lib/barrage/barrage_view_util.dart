import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/barrage_model.dart';

class BarrageViewUtil {
  // If you want to define barrage styles, you can customize them here based on the type of barrage
  static barrageView(BarrageModel model) {
    switch (model.type) {
      case 1:
        return _barrageType1(model);
      case 2:
        return _barrageType2(model);
      case 3:
        return _barrageType3(model);
      case 4:
        return _barrageType4(model);
      case 5:
        return _barrageType5(model);
    }
    return Text(model.content, style: TextStyle(color: Colors.white));
  }

  // Type 1: white text
  static _barrageType1(BarrageModel model) {
    return Center(
      child: Container(
        child: Text(
          model.content,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // Type 2: Bold white text with semi-transparent background
  static _barrageType2(BarrageModel model) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          model.content,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Type 3: Large gradient text
  static _barrageType3(BarrageModel model) {
    return Center(
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [Colors.purple, Colors.blue],
        ).createShader(bounds),
        child: Text(
          model.content,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Type 4: Rounded container with shadow
  static _barrageType4(BarrageModel model) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          model.content,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(2, 2),
              ),
            ]),
      ),
    );
  }

  // Type 5: Animated text
  static _barrageType5(BarrageModel model) {
    return Center(
      child: Container(
        child: AnimatedDefaultTextStyle(
          style: TextStyle(
            color: Colors.yellowAccent,
            fontSize: 14 + (model.priority ?? 1).toDouble(),
          ),
          duration: Duration(milliseconds: 500),
          child: Text(model.content),
        ),
      ),
    );
  }
}
