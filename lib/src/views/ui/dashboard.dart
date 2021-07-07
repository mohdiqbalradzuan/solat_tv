import 'package:flutter/material.dart';
import 'package:solat_tv/src/views/ui/widget/change_theme_switch.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                child: Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Align(
                child: SizedBox(
                  height: 20,
                ),
              ),
              Align(
                child: ElevatedButton(
                  child: Text('Back to home page'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          SwitchThemeWidget(),
        ],
      ),
    );
  }
}
