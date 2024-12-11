import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:streamly/util/color.dart';

import '../db/hi_cache.dart';
import '../util/hi_constants.dart';

// save previous setting locally
extension ThemeModeExtension on ThemeMode {
  String get value => <String>['System', 'Light', 'Dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode? _themeMode;
  var _platformBrightness = SchedulerBinding.instance.window.platformBrightness;

  // monitor system's dark mode changes
  void darModeChange() {
    if (_platformBrightness !=
        SchedulerBinding.instance.window.platformBrightness) {
      _platformBrightness = SchedulerBinding.instance.window.platformBrightness;
      notifyListeners();
    }
  }

  // whether is in a dark mode
  bool isDark() {
    if (_themeMode == ThemeMode.system) {
      // get system's theme mode
      return SchedulerBinding.instance.window.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // get theme mode
  ThemeMode getThemeMode() {
    String? theme = HiCache.getInstance().get(HiConstants.theme);
    switch (theme) {
      case 'Dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'System':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.light;
        break;
    }
    return _themeMode!;
  }

  // set theme mode
  void setTheme(ThemeMode themeMode) {
    HiCache.getInstance().setString(HiConstants.theme, themeMode.value);
    notifyListeners();
  }

  // return theme data
  ThemeData getTheme({bool isDarkMode = false}) {
    var themeData = ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        // errorColor: isDarkMode ? HiColor.dark_red : HiColor.red,
        primaryColor: isDarkMode ? HiColor.dark_bg : white,
        // accentColor: isDarkMode ? primary[50] : white,
        // tab's color
        indicatorColor: isDarkMode ? primaryColor[50] : white,
        // page background color
        scaffoldBackgroundColor: isDarkMode ? HiColor.dark_bg : white);
    return themeData;
  }
}
