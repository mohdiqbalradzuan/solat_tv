import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solat_tv/globals.dart' as globals;
import 'package:solat_tv/src/views/utils/provider/theme_provider.dart';

class ConfigurationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConfigurationWidgetWidgetState();
}

class _ConfigurationWidgetWidgetState extends State<ConfigurationWidget> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isDarkMode = globals.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: 55,
      //height: 30,
      top: globals.switchThemePadding,
      right: globals.switchThemePadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FlutterSwitch(
            width: 60.0,
            height: 30.0,
            toggleSize: 25.0,
            value: this._isDarkMode,
            borderRadius: 30.0,
            padding: 4.0,
            activeToggleColor: Colors.black,
            inactiveToggleColor: Colors.amber,
            activeSwitchBorder: Border.all(
              color: Colors.black26,
              width: 1.0,
            ),
            inactiveSwitchBorder: Border.all(
              color: Colors.black54,
              width: 1.0,
            ),
            activeColor: Colors.black26,
            inactiveColor: Colors.white,
            activeIcon: Icon(
              Icons.nightlight_round,
              color: Colors.amber[400],
            ),
            inactiveIcon: Icon(
              Icons.wb_sunny,
              color: Colors.white,
            ),
            onToggle: (value) {
              final provider =
                  Provider.of<ThemeProvider>(context, listen: false);
              provider.toggleTheme(value);
              setState(() {
                this._isDarkMode = value;
                _changeTheme(this._isDarkMode);
                globals.isDarkMode = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/configuration');
            },
            // elevation: 2.0,
            // color: Colors.black26,
            child: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.secondary,
              // size: 35.0,
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).shadowColor),
              shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
              overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Theme.of(context)
                      .colorScheme
                      .primary; // <-- Splash color
                } else if (states.contains(MaterialState.hovered)) {
                  return Theme.of(context)
                      .colorScheme
                      .primary; // <-- Splash color
                }
                return Theme.of(context).colorScheme.primary;
              }),
            ),
            // shape: CircleBorder(),
          ),
        ],
      ),
    );
  }

  Future<void> _changeTheme(isDarkMode) async {
    final SharedPreferences prefs = await this._prefs;
    prefs.setBool('isDarkMode', isDarkMode);
  }
}
