import 'package:flutter/material.dart';
import 'package:solat_tv/globals.dart' as globals;
import 'package:solat_tv/src/business_logic/services/api_services/get_solat_time_jakim.dart';
import 'dashboard.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    GetSolatTimeJakim solatProvider = new GetSolatTimeJakim();
    solatProvider.getTimeFromSource().then((value) => Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return Dashboard();
        })));
    super.initState();
  }

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
              SizedBox(
                child: LinearProgressIndicator(),
                width: 300,
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.only(top: globals.dashboardPadding),
                child: Text('Initializing solat time data'),
              ),
            ],
          ),
          //SwitchThemeWidget(),
        ],
      ),
    );
  }
}
