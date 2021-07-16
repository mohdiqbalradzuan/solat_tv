import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solat_tv/globals.dart' as globals;
import 'package:solat_tv/src/business_logic/services/api_services/get_solat_time_jakim.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isZoneSelected = false;

  @override
  void initState() {
    _checkConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                child: new Image.asset(
                  'assets/images/logo.png',
                  height: 200,
                  width: 200,
                ),
              ),
              Align(
                child: SizedBox(
                  height: 30,
                ),
              ),
              Align(
                child: Text(
                  'Solat TV',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Align(
                child: SizedBox(
                  height: 20,
                ),
              ),
              SizedBox(
                child: LinearProgressIndicator(),
                width: 300,
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.only(top: globals.dashboardPadding),
                child: Text('Initializing solat time data'),
              ),
            ],
          ),
          //SwitchThemeWidget(),
        ],
      ),
    );
  }

  Future<void> _checkConfig() async {
    SharedPreferences prefs = await this._prefs;

    if (prefs != null) {
      if ((prefs.getString('defaultZone') == '' ||
              prefs.getString('defaultZone') == null) &&
          (prefs.getInt('durationForReminderBuffer') == null ||
              prefs.getInt('durationForReminderBuffer') == 0)) {
        Navigator.of(context).pushReplacementNamed('/configuration');
      } else if (prefs.getString('latest_date_sync') == '' ||
          prefs.getString('latest_date_sync') == null ||
          (prefs.getString('latest_date_sync') !=
              DateFormat('yyyy-MM-dd').format(DateTime.now()))) {
        GetSolatTimeJakim solatProvider = new GetSolatTimeJakim();
        solatProvider.getTimeFromSource().then((value) =>
            Navigator.of(context).pushReplacementNamed('/dashboard'));
      } else {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    }
  }
}
