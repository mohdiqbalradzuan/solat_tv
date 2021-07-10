import 'package:flutter/material.dart';
import 'package:solat_tv/src/views/ui/widget/change_theme_switch.dart';
import 'package:solat_tv/src/globals.dart' as globals;

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static MediaQueryData _mediaQueryData;

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: globals.dashboardPadding),
              Row(
                children: [
                  SizedBox(width: globals.dashboardPadding),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: (_mediaQueryData.size.height - (globals.dashboardPadding * 2)),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(0,0,10,0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(globals.dashboardBorderRadius),
                        color: Colors.black12,
                        border: Border.all(
                          color: Colors.white12,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Align(
                                child: Text(
                                  'Waktu sekarang:',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Row(
                            children: [
                              Align(
                                child: Text(
                                  'Clock here:',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                        height: (_mediaQueryData.size.height - (globals.dashboardPadding * 2)),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(10,0,0,0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(globals.dashboardBorderRadius),
                        color: Colors.black12,
                        border: Border.all(
                          color: Colors.white12,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Align(
                                child: ElevatedButton(
                                  child: Text('Back to home page'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/home',
                                            ModalRoute.withName('/home'));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: globals.dashboardPadding),
                ],
              ),
              SizedBox(height: globals.dashboardPadding),
            ],
          ),
          SwitchThemeWidget(),
        ],
      ),
    );
  }
}
