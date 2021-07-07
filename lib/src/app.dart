import 'package:flutter/material.dart';
import 'package:solat_tv/src/views/theme/dark.dart';
import 'package:solat_tv/src/views/ui/home.dart';

class SolatTvApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: DarkTheme().theme,
      home: Home(),
    );
  }
}
