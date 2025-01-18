import 'package:flutter/cupertino.dart';

// Page state management
abstract class HiState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    } else {
      print(
          "HiState: The page has been destroyed, so setState is not executed this time: ${toString()}");
    }
  }
}
