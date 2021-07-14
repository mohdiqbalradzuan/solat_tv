import 'package:audioplayers/audioplayers.dart';
import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:solat_tv/globals.dart' as globals;

import 'package:intl/intl.dart';

class SolatTimerBlocs extends GetxController {
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

  double percent = .0;
  int activeSolatIndex = 0;
  bool activateAzanSound = false;
  bool showWarning = false;
  String countdownText = '';
  String solatNowName = '';

  var solatSchedules = {
    0: {'name': 'Imsak', 'hour': 5, 'minute': 49},
    1: {'name': 'Subuh', 'hour': 5, 'minute': 59},
    2: {'name': 'Syuruk', 'hour': 7, 'minute': 10},
    3: {'name': 'Zuhur', 'hour': 8, 'minute': 40},
    4: {'name': 'Asar', 'hour': 16, 'minute': 47},
    5: {'name': 'Maghrib', 'hour': 19, 'minute': 58},
    6: {'name': 'Isyak', 'hour': 20, 'minute': 06},
  };

  List<DateTime> solatTimes;
  List<DateTime> iqamatTimes;

  SolatTimerBlocs() {
    azanPlayer = AudioPlayer();
    azanPlayerCache = AudioCache(fixedPlayer: azanPlayer);

    alertPlayer = AudioPlayer();
    alertPlayerCache = AudioCache(fixedPlayer: alertPlayer);

    azanPlayer.onPlayerCompletion.listen((event) {
      //print('Player audio complete');
      showWarning = false;
      update();
    });

    solatTimes = [
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

    iqamatTimes = [
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
    isClockTimerRunning = true;
    update();
    clockTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      currentTime.add(DateTime.now());
      percent = DateTime.now().second / 60.0;
      update();
    });
  }

  stopClockTimer() {
    clockTimer.cancel();
    isClockTimerRunning = false;
    update();
  }

  startScheduleTimer() {
    isScheduleTimerRunning = true;
    update();
    scheduleTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      var now = DateTime.now();
      bool activeTimeChecked = false;

      solatTimes.asMap().forEach((key, value) {
        if (key != 0 && key != 2) {
          if (value.isAfter(now) && !activeTimeChecked) {
            activeSolatIndex = key;
            //print('$key - ${DateFormat('dd-MMM-yyyy HH:mm:ss').format(value)} vs  ${DateFormat('dd-MMM-yyyy HH:mm:ss').format(now)}');
            print('$now Set active solat time to $activeSolatIndex');
            activeTimeChecked = true;
          }

          if (value.hour == now.hour &&
              value.minute == now.minute &&
              value.second == now.second) {
            solatNowName = solatSchedules[key]['name'];
            activateAzanSound = true;

            //print('Activate azan');
            Bringtoforeground.bringAppToForeground();
            azanPlayerCache.play('audio/azan_makkah.mp3', volume: 1.0);

          } else {
            activateAzanSound = false;
          }
        }
      });

      if (!activeTimeChecked ||
          (00 == now.hour && 00 == now.minute && 00 == now.second)) {
        //print('Check next day');

        solatTimes.asMap().forEach((key, value) {
          solatTimes[key] = value.add(Duration(days: 1));
          iqamatTimes[key] = value.add(Duration(days: 1, seconds: globals.durationForIqamatBuffer));
        });

        //print('Check the latest today from JAKIM');
        activeSolatIndex = 1;
      }

      countdownText =
          _validateDuration(solatTimes[activeSolatIndex].difference(now));

      update();
    });
  }

  stopScheduleTimer() {
    scheduleTimer.cancel();
    isScheduleTimerRunning = false;
    update();
  }

  String _validateDuration(Duration duration) {
    if (duration < Duration(seconds: globals.durationForAlertForAzan)) {
      Bringtoforeground.bringAppToForeground();
      alertPlayerCache.play('audio/alert.wav');

      return 'Waiting for azan...';
    } else if (duration < Duration(seconds: globals.durationForWaitingForAzan)) {
      Bringtoforeground.bringAppToForeground();
      showWarning = true;

      return 'Waiting for azan...';
    } else if (showWarning) {
      return 'Azan $solatNowName 🕋';
    } else {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));

      return "${twoDigits(duration.inHours)} hr${(duration.inHours == 1) ? '' : 's'} : $twoDigitMinutes min${((duration.inMinutes.remainder(60)) == 1) ? '' : 's'}";
    }
  }
}
