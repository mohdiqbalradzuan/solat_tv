import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solat_tv/globals.dart' as globals;
import 'package:solat_tv/src/business_logic/services/api_services/get_solat_time_jakim.dart';

class Configuration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  final _formKey = GlobalKey<FormState>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _selectedZoneCode = globals.defaultZone;
  bool _enableSolatReminder = globals.enableSolatReminder;
  int _durationForReminderBuffer = globals.durationForReminderBuffer;

  @override
  Widget build(BuildContext context) {
    GetSolatTimeJakim provider = new GetSolatTimeJakim();

    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints box) {
            return Center(
              child: Container(
                width: box.maxWidth / 2,
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: globals.dashboardPadding),
                    Column(
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.app_settings_alt_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 35.0,
                                ),
                              ),
                              SizedBox(width: globals.dashboardPadding),
                              Text(
                                'Settings',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(
                                      fontSize: box.maxWidth / 30,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: globals.dashboardPadding),
                    SizedBox(height: globals.dashboardPadding),
                    Text(
                      'JAKIM zone:',
                    ),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: this._selectedZoneCode,
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
                        'Please choose your zone code',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      onChanged: (String code) {
                        setState(() {
                          this._selectedZoneCode = code;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select your zone';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: globals.dashboardPadding),
                    Row(
                      children: [
                        Text(
                          'Enable prayer reminder after \'x\' minutes:',
                        ),
                        Checkbox(
                          fillColor:
                              MaterialStateProperty.resolveWith(_getColor),
                          value: this._enableSolatReminder,
                          onChanged: (bool value) {
                            setState(() {
                              this._enableSolatReminder = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: globals.dashboardPadding),
                    Row(
                      children: [
                        Text(
                          'What is the \'x\' minutes for \nreminder for prayer after azan:',
                        ),
                        SizedBox(width: globals.dashboardPadding),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            isExpanded: true,
                            value: this._durationForReminderBuffer ~/ 60,
                            items: _getMinuteList()
                                .map((key, value) {
                                  return MapEntry(
                                      value,
                                      DropdownMenuItem<int>(
                                        value: key,
                                        child: Text(
                                          value.toString(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ));
                                })
                                .values
                                .toList(),
                            hint: Text(
                              'Select minutes',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onChanged: (int value) {
                              setState(() {
                                this._durationForReminderBuffer = value * 60;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select your minute';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: globals.dashboardPadding),
                    SizedBox(height: globals.dashboardPadding),
                    SizedBox(height: globals.dashboardPadding),
                    Column(
                      children: [
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _updateConfiguration();
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/home', ModalRoute.withName('/home'));
                                });
                              }
                              ;
                            },
                            child: const Text('Done'),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Theme.of(context).primaryColor;
    }
    return Theme.of(context).primaryColor;
  }

  Future<void> _updateConfiguration() async {
    final SharedPreferences prefs = await this._prefs;

    prefs.setString('defaultZone', this._selectedZoneCode);
    prefs.setInt('durationForReminderBuffer', this._durationForReminderBuffer);
    prefs.setBool('enableSolatReminder', this._enableSolatReminder);

    globals.defaultZone = this._selectedZoneCode;
    globals.durationForReminderBuffer = this._durationForReminderBuffer;
    globals.enableSolatReminder = this._enableSolatReminder;
  }

  Map<int, int> _getMinuteList() {
    Map<int, int> minuteList = {
      10: 10,
      11: 11,
      12: 12,
      13: 13,
      14: 14,
      15: 15,
      16: 16,
      17: 17,
      18: 18,
      19: 19,
      20: 20,
      21: 21,
      22: 22,
      23: 23,
      24: 24,
      25: 25,
      26: 26,
      27: 27,
      28: 28,
      29: 29,
      30: 30,
      31: 31,
      32: 32,
      33: 33,
      34: 34,
      35: 35,
      36: 36,
      37: 37,
      38: 38,
      39: 39,
      40: 40,
      41: 41,
      42: 42,
      43: 43,
      44: 44,
      45: 45,
      46: 46,
      47: 47,
      48: 48,
      49: 49,
      50: 50,
      51: 51,
      52: 52,
      53: 53,
      54: 54,
      55: 55,
      56: 56,
      57: 57,
      58: 58,
      59: 59,
      60: 60,
    };

    return minuteList;
  }
}
