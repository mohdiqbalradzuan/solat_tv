import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:intl/intl.dart';

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

  // TO-DO Get the values from JAKIM service
  List<DateTime> solatTimes = [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 1),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 2),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 3),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 4),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 5),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 6),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 42),
  ];

  List<DateTime> iqamatTimes = [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 1).add(const Duration(minutes: 10)),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 2).add(const Duration(minutes: 10)),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 3).add(const Duration(minutes: 10)),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 4).add(const Duration(minutes: 10)),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 5).add(const Duration(minutes: 10)),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 6).add(const Duration(minutes: 10)),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 42).add(const Duration(minutes: 10)),
  ];

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
        if (e.isAfter(now) && !activeTimeChecked) {
          print('Set active solat time to $i');

          activeSolatIndex = i;
          activeTimeChecked = true;
        }

        if (e.hour == now.hour && e.minute == now.minute && e.second == now.second) {
          print('Laungkan azan');
        }
      });

      if(!activeTimeChecked){
        print('Check next day');
      }

      update();
    });
  }

  stopScheduleTimer() {
    scheduleTimer.cancel();
    isScheduleTimerRunning = false;
    update();
  }
}
