import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:screen_state/screen_state.dart';
import 'package:solat_tv/globals.dart' as globals;
import 'package:solat_tv/src/business_logic/services/api_services/get_solat_time_jakim.dart';

class SolatTimerBlocs extends GetxController {
  static const platform = const MethodChannel('samples.flutter.dev/solat_tv');

  StreamController<DateTime> currentTime =
      StreamController<DateTime>.broadcast();
  ScrollController scrollController = new ScrollController();

  AudioPlayer azanPlayer;
  AudioCache azanPlayerCache;

  AudioPlayer alertPlayer;
  AudioCache alertPlayerCache;

  Timer clockTimer;
  bool isClockTimerRunning = false;

  Timer scheduleTimer;
  bool isScheduleTimerRunning = false;

  Timer reminderTimer;
  bool isReminderTimerRunning = false;

  double percent = .0;
  int activeSolatIndex = 0;
  bool activateAzanSound = false;
  bool showWarning = false;
  bool showReminder = false;
  String countdownText = '';
  String nowSolatName = '';

  ScreenStateEvent currentScreenState;

  var solatSchedules = {
    0: {
      'name': 'Imsak',
      'hour': globals.imsak.hour,
      'minute': globals.imsak.minute
    },
    1: {
      'name': 'Subuh',
      'hour': globals.subuh.hour,
      'minute': globals.subuh.minute
    },
    2: {
      'name': 'Syuruk',
      'hour': globals.syuruk.hour,
      'minute': globals.syuruk.minute
    },
    3: {
      'name': 'Zuhur',
      'hour': globals.zuhur.hour,
      'minute': globals.zuhur.minute
    },
    4: {
      'name': 'Asar',
      'hour': globals.asar.hour,
      'minute': globals.asar.minute
    },
    5: {
      'name': 'Maghrib',
      'hour': globals.maghrib.hour,
      'minute': globals.maghrib.minute
    },
    6: {
      'name': 'Isyak',
      'hour': globals.isyak.hour,
      'minute': globals.isyak.minute
    },
  };

  List<DateTime> solatTimes;
  List<DateTime> iqamatTimes;

  SolatTimerBlocs() {
    this.azanPlayer = AudioPlayer();
    this.azanPlayerCache = AudioCache(fixedPlayer: azanPlayer);

    this.alertPlayer = AudioPlayer();
    this.alertPlayerCache = AudioCache(fixedPlayer: alertPlayer);

    this.azanPlayer.onPlayerCompletion.listen((event) {
      //print('Player audio complete');
      this.showWarning = false;
      update();
    });

    this.solatTimes = [
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          solatSchedules[0]['hour'], solatSchedules[0]['minute']),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          solatSchedules[1]['hour'], solatSchedules[1]['minute']),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          solatSchedules[2]['hour'], solatSchedules[2]['minute']),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          solatSchedules[3]['hour'], solatSchedules[3]['minute']),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          solatSchedules[4]['hour'], solatSchedules[4]['minute']),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          solatSchedules[5]['hour'], solatSchedules[5]['minute']),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          solatSchedules[6]['hour'], solatSchedules[6]['minute']),
    ];

    this.iqamatTimes = [
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              solatSchedules[0]['hour'], solatSchedules[0]['minute'])
          .add(Duration(seconds: globals.durationForIqamatBuffer)),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              solatSchedules[1]['hour'], solatSchedules[1]['minute'])
          .add(Duration(seconds: globals.durationForIqamatBuffer)),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              solatSchedules[2]['hour'], solatSchedules[2]['minute'])
          .add(Duration(seconds: globals.durationForIqamatBuffer)),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              solatSchedules[3]['hour'], solatSchedules[3]['minute'])
          .add(Duration(seconds: globals.durationForIqamatBuffer)),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              solatSchedules[4]['hour'], solatSchedules[4]['minute'])
          .add(Duration(seconds: globals.durationForIqamatBuffer)),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              solatSchedules[5]['hour'], solatSchedules[5]['minute'])
          .add(Duration(seconds: globals.durationForIqamatBuffer)),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              solatSchedules[6]['hour'], solatSchedules[6]['minute'])
          .add(Duration(seconds: globals.durationForIqamatBuffer)),
    ];
  }

  showTime(format, input) {
    return DateFormat(format).format(input);
  }

  startClockTimer() {
    this.isClockTimerRunning = true;

    update();

    this.clockTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      currentTime.add(DateTime.now());
      this.percent = DateTime.now().second / 60.0;

      update();
    });
  }

  stopClockTimer() {
    this.clockTimer.cancel();
    this.isClockTimerRunning = false;

    update();
  }

  startScheduleTimer() {
    this.isScheduleTimerRunning = true;

    update();

    this.scheduleTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      var now = DateTime.now();
      bool activeTimeChecked = false;

      this.solatTimes.asMap().forEach((key, value) {
        if (key != 0 && key != 2) {
          if (value.isAfter(now) && !activeTimeChecked) {
            activeSolatIndex = key;
            //print('$key - ${DateFormat('dd-MMM-yyyy HH:mm:ss').format(value)} vs  ${DateFormat('dd-MMM-yyyy HH:mm:ss').format(now)}');
            //print('$now Set active solat time to $activeSolatIndex');
            activeTimeChecked = true;
          }

          // Activate azan
          if (value.hour == now.hour &&
              value.minute == now.minute &&
              value.second == now.second) {
            this.nowSolatName = this.solatSchedules[key]['name'];

            this.activateAzanSound = true;

            this._wakeScreen();
            this.alertPlayer.stop();
            this.azanPlayerCache.play('audio/azan_makkah.mp3', volume: 1.0);

            if (globals.enableSolatReminder) {
              this.startReminderTimer();
            }
          } else {
            this.activateAzanSound = false;
          }
        }
      });

      if (!activeTimeChecked) {
        //print('Check next day');

        this.solatTimes.asMap().forEach((key, value) {
          this.solatTimes[key] = value.add(Duration(days: 1));
          this.iqamatTimes[key] = value
              .add(Duration(days: 1, seconds: globals.durationForIqamatBuffer));
        });

        //print('Check the latest today from JAKIM');
        this.activeSolatIndex = 1;
      }

      //print('Validate solatTime ${DateFormat('yyyy-MM-dd HH:mm:ss').format(this.solatTimes[this.activeSolatIndex])} vs ${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}');
      countdownText = this._validateDuration(
          this.solatTimes[this.activeSolatIndex].difference(now));

      // Get today data from Jakim every 00:05
      if (now.hour == 00 && now.minute == 5 && now.second == 0) {
        // print('Get latest data from solat time provider');
        FlutterLogs.logInfo(
            runtimeType.toString(),
            'startScheduleTimer 00:05:00',
            'Get latest data from solat time provider');

        GetSolatTimeJakim solatProvider = new GetSolatTimeJakim();
        solatProvider.getTimeFromSource();
      }

      update();
    });
  }

  stopScheduleTimer() {
    this.scheduleTimer.cancel();
    this.isScheduleTimerRunning = true;

    update();
  }

  startReminderTimer() {
    this.isReminderTimerRunning = false;

    update();

    this.reminderTimer = Timer.periodic(
        Duration(seconds: globals.durationForReminderBuffer), (timer) {
      this._wakeScreen();

      if (!this.showReminder) {
        this.showReminder = true;
        this.alertPlayerCache.loop('audio/alert.wav');
      }

      update();
    });
  }

  stopReminderTimer() {
    if (this.reminderTimer != null) {
      this.reminderTimer.cancel();
    }
    this.showReminder = false;
    this.alertPlayer.stop();
    this.isReminderTimerRunning = false;

    update();
  }

  updateScreenState(ScreenStateEvent event) {
    this.currentScreenState = event;
  }

  String _validateDuration(Duration duration) {
    if (duration < Duration(seconds: globals.durationForAlertForAzan)) {
      this._wakeScreen();
      this.alertPlayerCache.loop('audio/alert.wav');

      return 'Waiting for azan...';
    } else if (duration <
        Duration(seconds: globals.durationForWaitingForAzan)) {
      this._wakeScreen();
      this.showWarning = true;

      return 'Waiting for azan...';
    } else if (this.showWarning) {
      this._wakeScreen();
      return 'Azan ${this.nowSolatName} 🕋';
    } else {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));

      return '${twoDigits(duration.inHours)} hr${(duration.inHours == 1) ? '' : 's'} : $twoDigitMinutes min${((duration.inMinutes.remainder(60)) == 1) ? '' : 's'}';
    }
  }

  _wakeScreen() async {
    // FlutterLogs.logInfo(runtimeType.toString(), '_wakeScreen',
    //     '_wakeScreen and checking for screen state ${this.currentScreenState}');
    // print(
    //     '_wakeScreen and checking for screen state ${this.currentScreenState}');

    if (this.currentScreenState == ScreenStateEvent.SCREEN_OFF) {
      // print('Screen is ${this.currentScreenState}');
      //
      // FlutterLogs.logInfo(runtimeType.toString(), '_wakeScreen',
      //     'Screen is ${this.currentScreenState}');
      //
      // print('Invoke method postWakeScreen');
      //
      // FlutterLogs.logInfo(runtimeType.toString(), '_wakeScreen',
      //     'Invoke method postWakeScreen');
      await platform.invokeMethod('postWakeScreen');
    }

    Bringtoforeground.bringAppToForeground();
  }
}
