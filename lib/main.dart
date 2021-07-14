import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solat_tv/src/app.dart';
import 'package:solat_tv/globals.dart' as globals;

Future<void> main() async {
  await runZonedGuarded(
        () async {
      WidgetsFlutterBinding.ensureInitialized();
      print('Try to get SharedPreferences');
      final prefs = await SharedPreferences.getInstance();

      if (prefs != null) {
        print('Get from settings');
        globals.isDarkMode = prefs.getBool('isDarkMode') ?? true;
        globals.durationForWaitingForAzan = prefs.getInt('durationForWaitingForAzan') ?? 60;
        globals.durationForAlertForAzan = prefs.getInt('durationForWaitingForAzan') ?? 30;
        globals.durationForIqamatBuffer = prefs.getInt('durationForWaitingForAzan') ?? 600;
      }
      runApp(SolatTvApp());    },
        (error, st) => print(error),
  );

}