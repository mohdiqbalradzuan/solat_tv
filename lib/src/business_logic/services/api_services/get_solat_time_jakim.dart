import 'dart:convert';

import 'package:flutter_logs/flutter_logs.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solat_tv/globals.dart' as globals;
import 'package:solat_tv/src/business_logic/models/solat_time_jakim.dart';
import 'package:solat_tv/src/business_logic/services/api_services/get_solat_time.dart';

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

  @override
  Map<String, String> getZoneCodeList() {
    Map<String, String> zoneCodeList = {
      'JHR01': 'JHR01 - Pulau Aur dan Pulau Pemanggil',
      'JHR02': 'JHR02 - Johor Bahru, Kota Tinggi, Mersing',
      'JHR03': 'JHR03 - Kluang, Pontian',
      'JHR04': 'JHR04 - Batu Pahat, Muar, Segamat, Gemas Johor',
      'KDH01': 'KDH01 - Kota Setar, Kubang Pasu, Pokok Sena (Daerah Kecil)',
      'KDH02': 'KDH02 - Kuala Muda, Yan, Pendang',
      'KDH03': 'KDH03 - Padang Terap, Sik',
      'KDH04': 'KDH04 - Baling',
      'KDH05': 'KDH05 - Bandar Baharu, Kulim',
      'KDH06': 'KDH06 - Langkawi',
      'KDH07': 'KDH07 - Puncak Gunung Jerai',
      'KTN01':
          'KTN01 - Bachok, Kota Bharu, Machang, Pasir Mas, Pasir Puteh, Tanah Merah, Tumpat, Kuala Krai, Mukim Chiku',
      'KTN03':
          'KTN03 - Gua Musang (Daerah Galas Dan Bertam), Jeli, Jajahan Kecil Lojing',
      'MLK01': 'MLK01 - SELURUH NEGERI MELAKA',
      'NGS01': 'NGS01 - Tampin, Jempol',
      'NGS02': 'NGS02 - Jelebu, Kuala Pilah, Port Dickson, Rembau, Seremban',
      'PHG01': 'PHG01 - Pulau Tioman',
      'PHG02': 'PHG02 - Kuantan, Pekan, Rompin, Muadzam Shah',
      'PHG03': 'PHG03 - Jerantut, Temerloh, Maran, Bera, Chenor, Jengka',
      'PHG04': 'PHG04 - Bentong, Lipis, Raub',
      'PHG05': 'PHG05 - Genting Sempah, Janda Baik, Bukit Tinggi',
      'PHG06': 'PHG06 - Cameron Highlands, Genting Higlands, Bukit Fraser',
      'PLS01': 'PLS01 - Kangar, Padang Besar, Arau',
      'PNG01': 'PNG01 - Seluruh Negeri Pulau Pinang',
      'PRK01': 'PRK01 - Tapah, Slim River, Tanjung Malim',
      'PRK02': 'PRK02 - Kuala Kangsar, Sg. Siput , Ipoh, Batu Gajah, Kampar',
      'PRK03': 'PRK03 - Lenggong, Pengkalan Hulu, Grik',
      'PRK04': 'PRK04 - Temengor, Belum',
      'PRK05':
          'PRK05 - Kg Gajah, Teluk Intan, Bagan Datuk, Seri Iskandar, Beruas, Parit, Lumut, Sitiawan, Pulau Pangkor',
      'PRK06': 'PRK06 - Selama, Taiping, Bagan Serai, Parit Buntar',
      'PRK07': 'PRK07 - Bukit Larut',
      'SBH01':
          'SBH01 - Bahagian Sandakan (Timur), Bukit Garam, Semawang, Temanggong, Tambisan, Bandar Sandakan, Sukau',
      'SBH02':
          'SBH02 - Beluran, Telupid, Pinangah, Terusan, Kuamut, Bahagian Sandakan (Barat)',
      'SBH03':
          'SBH03 - Lahad Datu, Silabukan, Kunak, Sahabat, Semporna, Tungku, Bahagian Tawau  (Timur)',
      'SBH04':
          'SBH04 - Bandar Tawau, Balong, Merotai, Kalabakan, Bahagian Tawau (Barat)',
      'SBH05':
          'SBH05 - Kudat, Kota Marudu, Pitas, Pulau Banggi, Bahagian Kudat',
      'SBH06': 'SBH06 - Gunung Kinabalu',
      'SBH07':
          'SBH07 - Kota Kinabalu, Ranau, Kota Belud, Tuaran, Penampang, Papar, Putatan, Bahagian Pantai Barat',
      'SBH08':
          'SBH08 - Pensiangan, Keningau, Tambunan, Nabawan, Bahagian Pendalaman (Atas)',
      'SBH09':
          'SBH09 - Beaufort, Kuala Penyu, Sipitang, Tenom, Long Pa Sia, Membakut, Weston, Bahagian Pendalaman (Bawah)',
      'SGR01':
          'SGR01 - Gombak, Petaling, Sepang, Hulu Langat, Hulu Selangor, S.Alam',
      'SGR02': 'SGR02 - Kuala Selangor, Sabak Bernam',
      'SGR03': 'SGR03 - Klang, Kuala Langat',
      'SWK01': 'SWK01 - Limbang, Lawas, Sundar, Trusan',
      'SWK02': 'SWK02 - Miri, Niah, Bekenu, Sibuti, Marudi',
      'SWK03': 'SWK03 - Pandan, Belaga, Suai, Tatau, Sebauh, Bintulu',
      'SWK04':
          'SWK04 - Sibu, Mukah, Dalat, Song, Igan, Oya, Balingian, Kanowit, Kapit',
      'SWK05': 'SWK05 - Sarikei, Matu, Julau, Rajang, Daro, Bintangor, Belawai',
      'SWK06':
          'SWK06 - Lubok Antu, Sri Aman, Roban, Debak, Kabong, Lingga, Engkelili, Betong, Spaoh, Pusa, Saratok',
      'SWK07': 'SWK07 - Serian, Simunjan, Samarahan, Sebuyau, Meludam',
      'SWK08': 'SWK08 - Kuching, Bau, Lundu, Sematan',
      'SWK09': 'SWK09 - Zon Khas (Kampung Patarikan)',
      'TRG01': 'TRG01 - Kuala Terengganu, Marang, Kuala Nerus',
      'TRG02': 'TRG02 - Besut, Setiu',
      'TRG03': 'TRG03 - Hulu Terengganu',
      'TRG04': 'TRG04 - Dungun, Kemaman',
      'WLY01': 'WLY01 - Kuala Lumpur, Putrajaya',
      'WLY02': 'WLY02 - Labuan',
    };

    return zoneCodeList;
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

    prefs.setString('latest_date_sync',
        DateFormat('yyyy-MM-dd').format(solatTime.gregorianDate));

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
