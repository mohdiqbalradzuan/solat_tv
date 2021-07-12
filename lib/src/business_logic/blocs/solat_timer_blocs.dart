import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:solat_tv/src/business_logic/services/audio_services/audio_helper.dart';

class SolatTimerBlocs extends GetxController {
  StreamController<DateTime> currentTime =
      StreamController<DateTime>.broadcast();
  ScrollController scrollController = new ScrollController();

  Timer clockTimer;
  bool isClockTimerRunning = false;

  Timer scheduleTimer;
  bool isScheduleTimerRunning = false;

  double percent = .0;
  int activeSolatIndex = 0;
  bool activateAzanSound = false;
  String countdownText = '';

  var solatSchedules = {
    0: {'name': 'Imsak', 'hour': 5, 'minute': 49},
    1: {'name': 'Subuh', 'hour': 5, 'minute': 59},
    2: {'name': 'Syuruk', 'hour': 7, 'minute': 10},
    3: {'name': 'Zuhur', 'hour': 13, 'minute': 23},
    4: {'name': 'Asar', 'hour': 16, 'minute': 46},
    5: {'name': 'Maghrib', 'hour': 19, 'minute': 31},
    6: {'name': 'Isyak', 'hour': 20, 'minute': 45},
  };

  List<DateTime> solatTimes;
  List<DateTime> iqamatTimes;

  SolatTimerBlocs() {
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
          .add(const Duration(minutes: 10)),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              solatSchedules[1]['hour'], solatSchedules[1]['minute'])
          .add(const Duration(minutes: 10)),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              solatSchedules[2]['hour'], solatSchedules[2]['minute'])
          .add(const Duration(minutes: 10)),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              solatSchedules[3]['hour'], solatSchedules[3]['minute'])
          .add(const Duration(minutes: 10)),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              solatSchedules[4]['hour'], solatSchedules[4]['minute'])
          .add(const Duration(minutes: 10)),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              solatSchedules[5]['hour'], solatSchedules[5]['minute'])
          .add(const Duration(minutes: 10)),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
              solatSchedules[6]['hour'], solatSchedules[6]['minute'])
          .add(const Duration(minutes: 10)),
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

      solatTimes.asMap().forEach((i, e) {
        if (i != 0) {
          //print('$i - ${DateFormat('dd-MMM-yyyy HH:mm:ss').format(e)}');
          if (e.isBefore(now)) {
            solatTimes[i] = e.add(Duration(days: 1));
            iqamatTimes[i] = e.add(Duration(days: 1, minutes: 10));
          } else if (e.isAfter(now) && !activeTimeChecked) {
            activeSolatIndex = i;
            //print('Set active solat time to $activeSolatIndex');
            activeTimeChecked = true;
          }

          if (e.hour == now.hour &&
              e.minute == now.minute &&
              e.second == now.second) {
            activateAzanSound = true;

            new AudioHelper().playAzan();
          } else {
            activateAzanSound = false;
          }
        }
      });

      if (!activeTimeChecked ||
          (00 == now.hour && 00 == now.minute && 00 == now.second)) {
        //print('Check next day');
        //print('Check the latest today from JAKIM');
        activeSolatIndex = 1;
      }

      countdownText =
          _printDuration(solatTimes[activeSolatIndex].difference(now));

      update();
    });
  }

  stopScheduleTimer() {
    scheduleTimer.cancel();
    isScheduleTimerRunning = false;
    update();
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)} hr${(duration.inHours == 1) ? '' : 's'} : $twoDigitMinutes sec${((duration.inMinutes.remainder(60)) == 1) ? '' : 's'}";
  }
}
