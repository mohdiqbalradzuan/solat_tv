import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solat_tv/src/views/theme/app_theme.dart';
import 'package:solat_tv/src/views/ui/dashboard.dart';
import 'package:solat_tv/src/views/ui/home.dart';
import 'package:solat_tv/src/views/utils/provider/theme_provider.dart';
import 'globals.dart' as globals;

main() {
  globals.isDarkMode = true;
}

class SolatTvApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: Dashboard(),
            routes: <String, WidgetBuilder>{
              '/home': (BuildContext context) => new Home(),
              '/dashboard': (BuildContext context) => new Dashboard(),
            },
          );
        },
      );
}
