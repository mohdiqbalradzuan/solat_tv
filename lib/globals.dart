library solat_tv.globals;

import 'package:flutter/material.dart';

// Fixed
const double switchThemePadding = 30.0;
const double versionInfoPadding = 3.0;
const double dashboardPadding = 20.0;
const double dashboardBorderRadius = 3.0;
const double tablePadding = 10.0;

// Configurable settings
bool isDarkMode = true;

int durationForWaitingForAzan = 60; // in seconds
int durationForAlertForAzan = 30; // in seconds
int durationForIqamatBuffer = 600; // in seconds
int durationForReminderBuffer = 1800; // in seconds
bool enableSolatReminder = true;

double defaultLat = 3.204946;
double defaultLong = 101.689958;

String defaultZone = '';

TimeOfDay imsak = TimeOfDay(hour: 0, minute: 0);
TimeOfDay subuh = TimeOfDay(hour: 0, minute: 0);
TimeOfDay syuruk = TimeOfDay(hour: 0, minute: 0);
TimeOfDay zuhur = TimeOfDay(hour: 0, minute: 0);
TimeOfDay asar = TimeOfDay(hour: 0, minute: 0);
TimeOfDay maghrib = TimeOfDay(hour: 0, minute: 0);
TimeOfDay isyak = TimeOfDay(hour: 0, minute: 0);
