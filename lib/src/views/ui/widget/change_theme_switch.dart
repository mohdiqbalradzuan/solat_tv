import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:solat_tv/src/views/utils/provider/theme_provider.dart';
import 'package:solat_tv/src/globals.dart' as globals;

class SwitchThemeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      _SwitchThemeWidgetState();
}

class _SwitchThemeWidgetState extends State<SwitchThemeWidget> {
  bool status = globals.isDarkMode;

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
        value: status,
        borderRadius: 30.0,
        padding: 4.0,
        activeToggleColor: Colors.black,
        inactiveToggleColor: Colors.white,
        activeSwitchBorder: Border.all(
          color: Colors.black26,
          width: 1.0,
        ),
        inactiveSwitchBorder: Border.all(
          color: Colors.black54,
          width: 1.0,
        ),
        activeColor: Colors.black26,
        inactiveColor: Colors.amber[50],
        activeIcon: Icon(
          Icons.nightlight_round,
          color: Colors.amber[400],
        ),
        inactiveIcon: Icon(
          Icons.wb_sunny,
          color: Colors.amber[400],
        ),
        onToggle: (value) {
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          provider.toggleTheme(value);
          setState(() {
            status = value;
            globals.isDarkMode = value;
          });
        },
      ),
    );
  }
}
