import 'dart:convert';

import 'package:flutter_logs/flutter_logs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solat_tv/src/business_logic/models/solat_time_jakim.dart';
import 'package:solat_tv/src/business_logic/services/api_services/get_solat_time.dart';
import 'package:http/http.dart' as http;
import 'package:solat_tv/globals.dart' as globals;

class GetSolatTimeJakim implements GetSolatTime {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<void> getTimeFromSource() async {
    FlutterLogs.logInfo(runtimeType.toString(), 'getTimeFromSource',
        'Getting data from JAKIM service: ${'https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat&period=week&zone=${globals.defaultZone}'}');

    final response = await http.get(Uri.parse(
        'https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat&period=week&zone=${globals.defaultZone}'));

    FlutterLogs.logInfo(runtimeType.toString(), 'getTimeFromSource',
        'Response code from JAKIM service: ${response.statusCode}');
    FlutterLogs.logInfo(runtimeType.toString(), 'getTimeFromSource',
        'Response data: ${json.decode(response.body)['prayerTime']}');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      var dailyPrayerTimeList = List<DailySolatTimeModelJakim>.from(json
          .decode(response.body)['prayerTime']
          .map((data) => DailySolatTimeModelJakim.fromJson(data)));

      var today = DateTime.now();

      var todaySolatTime = dailyPrayerTimeList.where((p) =>
          p.gregorianDate.year == today.year &&
          p.gregorianDate.month == today.month &&
          p.gregorianDate.day == today.day &&
          p.gregorianDate.weekday == today.weekday);

      // print('Exist checking: ${todaySolatTime.length > 0}');
      // print('Solat time: ${todaySolatTime.first.gregorianDate.toString()}');

      await _updateSolatTimeToConfig(todaySolatTime.first);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      FlutterLogs.logError(runtimeType.toString(), 'getTimeFromSource',
          'Failed to load data from JAKIM');
      throw Exception('Failed to load data from JAKIM');
    }
  }

  Future<void> _updateSolatTimeToConfig(
      DailySolatTimeModelJakim solatTime) async {
    final SharedPreferences prefs = await this._prefs;
    globals.imsak = solatTime.imsak;
    globals.subuh = solatTime.subuh;
    globals.syuruk = solatTime.syuruk;
    globals.zuhur = solatTime.zuhur;
    globals.asar = solatTime.asar;
    globals.maghrib = solatTime.maghrib;
    globals.isyak = solatTime.isyak;

    prefs.setInt('imsak_hour', solatTime.imsak.hour);
    prefs.setInt('imsak_minute', solatTime.imsak.minute);
    prefs.setInt('subuh_hour', solatTime.subuh.hour);
    prefs.setInt('subuh_minute', solatTime.subuh.minute);
    prefs.setInt('syuruk_hour', solatTime.syuruk.hour);
    prefs.setInt('syuruk_minute', solatTime.syuruk.minute);
    prefs.setInt('zuhur_hour', solatTime.zuhur.hour);
    prefs.setInt('zuhur_minute', solatTime.zuhur.minute);
    prefs.setInt('asar_hour', solatTime.asar.hour);
    prefs.setInt('asar_minute', solatTime.asar.minute);
    prefs.setInt('maghrib_hour', solatTime.maghrib.hour);
    prefs.setInt('maghrib_minute', solatTime.maghrib.minute);
    prefs.setInt('isyak_hour', solatTime.isyak.hour);
    prefs.setInt('isyak_minute', solatTime.isyak.minute);
  }

  T tryCast<T>(dynamic x, {T fallback}) {
    try {
      return (x as T);
    } on TypeError catch (e) {
      print('CastError when trying to cast $x to $T!');
      return fallback;
    }
  }
}
