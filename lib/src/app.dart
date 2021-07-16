import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:solat_tv/src/views/theme/app_theme.dart';
import 'package:solat_tv/src/views/ui/configuration.dart';
import 'package:solat_tv/src/views/ui/dashboard.dart';
import 'package:solat_tv/src/views/ui/home.dart';
import 'package:solat_tv/src/views/utils/provider/theme_provider.dart';

class SolatTvApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return Shortcuts(
            shortcuts: <LogicalKeySet, Intent>{
              LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: themeProvider.themeMode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              home: Home(),
              routes: <String, WidgetBuilder>{
                '/home': (BuildContext context) => new Home(),
                '/dashboard': (BuildContext context) => new Dashboard(),
                '/configuration': (BuildContext context) => new Configuration(),
              },
            ),
          );
        },
      );
}
