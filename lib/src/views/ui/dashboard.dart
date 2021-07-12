import 'package:flutter/material.dart';
import 'package:solat_tv/src/views/ui/widget/change_theme_switch.dart';
import 'package:solat_tv/src/globals.dart' as globals;
import 'package:solat_tv/src/views/ui/widget/left.dart';
import 'package:solat_tv/src/views/ui/widget/right.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);

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
                    flex: null,
                    child: Container(
                      width: 390,
                      height: (_mediaQueryData.size.height -
                          (globals.dashboardPadding * 2)),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            globals.dashboardBorderRadius),
                        border: Border.all(
                          color: Theme.of(context).cardColor,
                          width: 0,
                          style: BorderStyle.solid,
                        ),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor,
                            spreadRadius: 1,
                            blurRadius: globals.dashboardBorderRadius,
                            offset: Offset(1, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints box) {
                          return LeftWidget(box.maxWidth);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: (_mediaQueryData.size.height -
                          (globals.dashboardPadding * 2)),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            globals.dashboardBorderRadius),
                        //color: Colors.black12,
                        border: Border.all(
                          color: Theme.of(context).cardColor,
                          width: 0,
                          style: BorderStyle.solid,
                        ),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor,
                            spreadRadius: 1,
                            blurRadius: globals.dashboardBorderRadius,
                            offset: Offset(1, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child:
                      LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints box) {
                            return RightWidget(box.maxWidth);
                          }
                      ),

                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Column(
                      //       children: [
                      //         Align(
                      //           child: ElevatedButton(
                      //             child: Text('Back to home page'),
                      //             onPressed: () {
                      //               Navigator.of(context)
                      //                   .pushNamedAndRemoveUntil('/home',
                      //                       ModalRoute.withName('/home'));
                      //             },
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
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
