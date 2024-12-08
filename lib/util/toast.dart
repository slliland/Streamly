import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Warning Toast with enhanced styling
void showWarnToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    backgroundColor:
        Colors.red.shade600.withOpacity(0.9), // Vivid semi-transparent red
    textColor: Colors.white,
    fontSize: 16.0, // Larger font size for better readability
    webBgColor:
        "linear-gradient(to right, #ff5f6d, #ffc371)", // Gradient for web support
    webPosition: "center",
  );
}

// Regular Toast with enhanced styling
void showToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.blueGrey.shade900
        .withOpacity(0.85), // Cool semi-transparent dark blue-grey
    textColor: Colors.white,
    fontSize: 16.0, // Larger font size for better readability
    webBgColor:
        "linear-gradient(to right, #00c6ff, #0072ff)", // Gradient for web support
    webPosition: "center",
  );
}
