import 'package:flutter/material.dart';
import 'package:solat_tv/src/views/ui/widget/change_theme_switch.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      _HomeState();
}

class _HomeState extends State<Home> {
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
              Align(
                child: ElevatedButton(
                  child: Text('Go to dashboard'),
                  onPressed: (){
                    Navigator.of(context).pushNamed('/dashboard').then((_) => setState(() {}));
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
