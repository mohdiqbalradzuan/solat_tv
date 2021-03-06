import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailySolatTimeModelJakim {
  final DateTime gregorianDate;
  final String dayOfWeek;
  final TimeOfDay imsak;
  final TimeOfDay subuh;
  final TimeOfDay syuruk;
  final TimeOfDay zuhur;
  final TimeOfDay asar;
  final TimeOfDay maghrib;
  final TimeOfDay isyak;

  DailySolatTimeModelJakim(this.gregorianDate, this.dayOfWeek, this.imsak,
      this.subuh, this.syuruk, this.zuhur, this.asar, this.maghrib, this.isyak);

  factory DailySolatTimeModelJakim.fromJson(Map<String, dynamic> json) {
    DateTime gregorianDate;
    String dayOfWeek;
    TimeOfDay imsak;
    TimeOfDay subuh;
    TimeOfDay syuruk;
    TimeOfDay zuhur;
    TimeOfDay asar;
    TimeOfDay maghrib;
    TimeOfDay isyak;

    //print('Data from JAKIM: $json');
    gregorianDate = DateFormat('dd-MMM-yyyy').parse(json['date']
        .replaceAll('-Mac-', '-Mar-')
        .replaceAll('-Mei-', '-May-')
        .replaceAll('-Ogos-', '-Aug-')
        .replaceAll('-Okt-', '-Oct-')
        .replaceAll('-Dis-', '-Dec-'));
    dayOfWeek = json['dayOfWeek'];

    var imsakTimeOfDayString = json['imsak'];
    var subuhTimeOfDayString = json['fajr'];
    var syurukTimeOfDayString = json['syuruk'];
    var zuhurTimeOfDayString = json['dhuhr'];
    var asarTimeOfDayString = json['asr'];
    var maghribTimeOfDayString = json['maghrib'];
    var isyakTimeOfDayString = json['isha'];

    imsak = TimeOfDay(
        hour: int.parse(imsakTimeOfDayString.split(':')[0]),
        minute: int.parse(imsakTimeOfDayString.split(':')[1]));
    subuh = TimeOfDay(
        hour: int.parse(subuhTimeOfDayString.split(':')[0]),
        minute: int.parse(subuhTimeOfDayString.split(':')[1]));
    syuruk = TimeOfDay(
        hour: int.parse(syurukTimeOfDayString.split(':')[0]),
        minute: int.parse(syurukTimeOfDayString.split(':')[1]));
    zuhur = TimeOfDay(
        hour: int.parse(zuhurTimeOfDayString.split(':')[0]),
        minute: int.parse(zuhurTimeOfDayString.split(':')[1]));
    asar = TimeOfDay(
        hour: int.parse(asarTimeOfDayString.split(':')[0]),
        minute: int.parse(asarTimeOfDayString.split(':')[1]));
    maghrib = TimeOfDay(
        hour: int.parse(maghribTimeOfDayString.split(':')[0]),
        minute: int.parse(maghribTimeOfDayString.split(':')[1]));
    isyak = TimeOfDay(
        hour: int.parse(isyakTimeOfDayString.split(':')[0]),
        minute: int.parse(isyakTimeOfDayString.split(':')[1]));

    return new DailySolatTimeModelJakim(gregorianDate, dayOfWeek, imsak, subuh,
        syuruk, zuhur, asar, maghrib, isyak);
  }
}
