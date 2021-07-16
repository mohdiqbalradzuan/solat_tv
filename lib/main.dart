import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solat_tv/globals.dart' as globals;
import 'package:solat_tv/src/app.dart';
import 'package:wakelock/wakelock.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      //print('Try to get SharedPreferences');
      final prefs = await SharedPreferences.getInstance();

      if (prefs != null) {
        //print('Get from settings');
        globals.isDarkMode = prefs.getBool('isDarkMode') ?? true;
        globals.durationForWaitingForAzan =
            prefs.getInt('durationForWaitingForAzan') ?? 60;
        globals.durationForAlertForAzan =
            prefs.getInt('durationForWaitingForAzan') ?? 30;
        globals.durationForIqamatBuffer =
            prefs.getInt('durationForWaitingForAzan') ?? 600;
        globals.durationForReminderBuffer =
            prefs.getInt('durationForReminderBuffer') ?? 600;

        globals.enableSolatReminder =
            prefs.getBool('enableSolatReminder') ?? true;

        globals.defaultZone = prefs.getString('defaultZone') ?? 'WLY01';

        globals.imsak = TimeOfDay(
            hour: prefs.getInt('imsak_hour') ?? 0,
            minute: prefs.getInt('imsak_minute') ?? 0);
        globals.subuh = TimeOfDay(
            hour: prefs.getInt('subuh_hour') ?? 0,
            minute: prefs.getInt('subuh_minute') ?? 0);
        globals.syuruk = TimeOfDay(
            hour: prefs.getInt('syuruk_hour') ?? 0,
            minute: prefs.getInt('syuruk_minute') ?? 0);
        globals.zuhur = TimeOfDay(
            hour: prefs.getInt('zuhur_hour') ?? 0,
            minute: prefs.getInt('zuhur_minute') ?? 0);
        globals.asar = TimeOfDay(
            hour: prefs.getInt('asar_hour') ?? 0,
            minute: prefs.getInt('asar_minute') ?? 0);
        globals.maghrib = TimeOfDay(
            hour: prefs.getInt('maghrib_hour') ?? 0,
            minute: prefs.getInt('maghrib_minute') ?? 0);
        globals.isyak = TimeOfDay(
            hour: prefs.getInt('isyak_hour') ?? 0,
            minute: prefs.getInt('isyak_minute') ?? 0);
      }

      await FlutterLogs.initLogs(
          logLevelsEnabled: [
            LogLevel.INFO,
            LogLevel.WARNING,
            LogLevel.ERROR,
            LogLevel.SEVERE
          ],
          logSystemCrashes: true,
          timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
          directoryStructure: DirectoryStructure.FOR_DATE,
          logTypesEnabled: ['device', 'network', 'errors'],
          logFileExtension: LogFileExtension.LOG,
          logsWriteDirectoryName: 'solat_tv_logs',
          logsExportDirectoryName: 'solat_tv_logs/exported',
          debugFileOperations: true,
          isDebuggable: true);

      Wakelock.enable();

      runApp(SolatTvApp());
    },
    (error, st) => print(error),
  );
}
