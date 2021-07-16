import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:solat_tv/globals.dart' as globals;

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = globals.isDarkMode ? ThemeMode.dark : ThemeMode.system;

  bool get isDarkMode {
    if (this.themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return this.themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    this.themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
