import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class SolatTimerBlocs extends GetxController {
  StreamController<DateTime> currentTime =
  StreamController<DateTime>.broadcast();
  ScrollController scrollController = new ScrollController();
  Timer timer;
  double percent = .0;
  bool isRunning = false;
  List<DateTime> dateTimes = [];

  formatTime(input) {
    if (input < 10) {
      return '0$input';
    }
    return input.toString();
  }

  startTimer() {
    isRunning = true;
    update();
    timer = Timer.periodic(Duration(milliseconds: 17), (timer) {
      currentTime.add(DateTime.now());
      percent = DateTime.now().second / 60.0;
      update();
    });
  }

  stopTimer() {
    timer.cancel();
    isRunning = false;
    update();
  }
}
