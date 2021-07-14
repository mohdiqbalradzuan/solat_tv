import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solat_tv/src/business_logic/services/api_services/get_solat_time_jakim.dart';
import 'package:solat_tv/globals.dart' as globals;

class Configuration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _selectedZoneCode;

  @override
  Widget build(BuildContext context) {
    GetSolatTimeJakim provider = new GetSolatTimeJakim();

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: DropdownButton<String>(
            value: _selectedZoneCode,
            items: provider
                .getZoneCodeList()
                .map((code, description) {
                  return MapEntry(
                      description,
                      DropdownMenuItem<String>(
                        value: code,
                        child: Text(
                          description,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ));
                })
                .values
                .toList(),
            hint: Text(
              "  Please choose a your zone code",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            onChanged: (String code) {
              setState(() {
                _updateZoneCodeToConfig(code);
                _selectedZoneCode = code;
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home', ModalRoute.withName('/home'));
              });
            },
          ),
        ),
      ),
    );
  }

  Future<void> _updateZoneCodeToConfig(String code) async {
    final SharedPreferences prefs = await this._prefs;

    prefs.setString('defaultZone', code);
    globals.defaultZone = code;
  }
}
