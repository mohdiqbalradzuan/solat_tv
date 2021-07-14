import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solat_tv/src/views/utils/provider/theme_provider.dart';
import 'package:solat_tv/globals.dart' as globals;

class SwitchThemeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SwitchThemeWidgetState();
}

class _SwitchThemeWidgetState extends State<SwitchThemeWidget> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isDarkMode = globals.isDarkMode;

  Future<void> _changeTheme(isDarkMode) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: 70,
      height: 30,
      top: globals.switchThemePadding,
      right: globals.switchThemePadding,
      child: FlutterSwitch(
        width: 60.0,
        height: 30.0,
        toggleSize: 25.0,
        value: _isDarkMode,
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
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          provider.toggleTheme(value);
          setState(() {
            _isDarkMode = value;
            _changeTheme(_isDarkMode);
            globals.isDarkMode = value;
          });
        },
      ),
    );
  }
}
