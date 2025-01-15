import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class HiDefend {
  run(Widget app) {
    ///Framework's error
    FlutterError.onError = (FlutterErrorDetails details) async {
      ///Release mode
      if (kReleaseMode) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      } else {
        ///Develop mode
        FlutterError.dumpErrorToConsole(details);
      }
    };
    runZonedGuarded(() {
      runApp(app);
    }, (e, s) => _reportError(e, s));
  }

  ///Report exceptions through the interface
  _reportError(Object error, StackTrace s) {
    print('kReleaseMode:$kReleaseMode');
    print('catch error:$error');
  }
}
