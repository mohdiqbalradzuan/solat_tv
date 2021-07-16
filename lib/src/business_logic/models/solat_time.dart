import 'package:flutter/material.dart';

class SolatTimeModel {
  final TimeOfDay imsak;
  final TimeOfDay subuh;
  final TimeOfDay syuruk;
  final TimeOfDay zuhur;
  final TimeOfDay asar;
  final TimeOfDay maghrib;
  final TimeOfDay isyak;

  SolatTimeModel(this.imsak, this.subuh, this.syuruk, this.zuhur, this.asar, this.maghrib, this.isyak);
}