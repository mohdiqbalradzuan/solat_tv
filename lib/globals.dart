library solat_tv.globals;

import 'package:flutter/material.dart';

// Fixed
const double switchThemePadding = 30.0;
const double dashboardPadding = 20.0;
const double dashboardBorderRadius = 3.0;
const double tablePadding = 10.0;

// Configurable settings
bool isDarkMode = true;

int durationForWaitingForAzan = 60;
int durationForAlertForAzan = 30;
int durationForIqamatBuffer = 600;

double defaultLat = 3.204946;
double defaultLong = 101.689958;

TimeOfDay imsak = TimeOfDay(hour: 05, minute: 47);
TimeOfDay subuh = TimeOfDay(hour: 05, minute: 59);
TimeOfDay syuruk = TimeOfDay(hour: 07, minute: 10);
TimeOfDay zuhur = TimeOfDay(hour: 13, minute: 22);
TimeOfDay asar = TimeOfDay(hour: 16, minute: 47);
TimeOfDay maghrib = TimeOfDay(hour: 19, minute: 31);
TimeOfDay isyak = TimeOfDay(hour: 20, minute: 45);
