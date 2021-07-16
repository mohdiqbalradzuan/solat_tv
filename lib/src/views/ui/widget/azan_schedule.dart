import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:screen_state/screen_state.dart';
import 'package:solat_tv/globals.dart' as globals;
import 'package:solat_tv/src/business_logic/blocs/solat_timer_blocs.dart';

class AzanScheduleWidget extends StatefulWidget {
  final double _width;

  AzanScheduleWidget(this._width);

  @override
  State<StatefulWidget> createState() => _AzanScheduleWidgetState();
}

class _AzanScheduleWidgetState extends State<AzanScheduleWidget> {
  final _timerController = Get.put(SolatTimerBlocs());

  int _activeIndex = 0;
  bool _showWarning = false;
  bool _showReminder = false;

  String _nowSolatName = '';
  double _tableHeaderFontRatio = 18.0;
  double _activeFontRatio = 15.0;
  double _inactiveFontRatio = 22.0;

  Screen _screen = Screen();
  StreamSubscription<ScreenStateEvent> _subscription;
  bool screenStateEventStreamStarted = false;
  ScreenStateEvent currentScreenState;

  @override
  void initState() {
    this._timerController.startScheduleTimer();
    this._startScreenStateListening();
    super.initState();
  }

  @override
  void dispose() {
    this._timerController.stopScheduleTimer();
    this._timerController.stopReminderTimer();
    this._stopScreenStateListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this._timerController.currentTime.stream,
      builder: (context, AsyncSnapshot snapshot) {
        this._activeIndex = this._timerController.activeSolatIndex;
        this._showWarning = this._timerController.showWarning;
        this._showReminder = this._timerController.showReminder;
        this._nowSolatName = this._timerController.nowSolatName;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  '${this._timerController.countdownText}',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: widget._width / 15.0,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                SizedBox(height: 10),
                Opacity(
                  child: Text(
                    'to ${this._timerController.solatSchedules[this._activeIndex]['name']}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget._width / 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  opacity: !this._showWarning ? 1.0 : 0.0,
                ),
                SizedBox(height: 20),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            AnimatedOpacity(
                              // If the widget is visible, animate to 0.0 (invisible).
                              // If the widget is hidden, animate to 1.0 (fully visible).
                              opacity: this._showReminder ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 500),
                              // The green box must be a child of the AnimatedOpacity widget.
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).disabledColor,
                                  border: Border.all(
                                    width: 1,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/reminder.png',
                                          height: 100,
                                          width: 100,
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          'Have you perform your solat ${this._nowSolatName}?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: widget._width / 20.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              this
                                                  ._timerController
                                                  .stopReminderTimer();
                                              this._showReminder = this
                                                  ._timerController
                                                  .showReminder;
                                            });
                                          },
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AnimatedOpacity(
                              // If the widget is visible, animate to 0.0 (invisible).
                              // If the widget is hidden, animate to 1.0 (fully visible).
                              opacity: this._showWarning ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 500),
                              // The green box must be a child of the AnimatedOpacity widget.
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).disabledColor,
                                  border: Border.all(
                                    width: 1,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/no-phone.png',
                                    height: 200,
                                    width: 200,
                                  ),
                                ),
                              ),
                            ),
                            AnimatedOpacity(
                              // If the widget is visible, animate to 0.0 (invisible).
                              // If the widget is hidden, animate to 1.0 (fully visible).
                              opacity: (this._showWarning || this._showReminder)
                                  ? 0.0
                                  : 1.0,
                              duration: Duration(milliseconds: 500),
                              // The green box must be a child of the AnimatedOpacity widget.
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                ),
                                child: _createTable(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _createTable() {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
      },
      //   border: TableBorder.symmetric(
      //   inside: BorderSide(width: 0),
      // ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                color: Theme.of(context).shadowColor.withOpacity(0.30),
                padding: EdgeInsets.all(globals.tablePadding),
                child: Text(
                  'Solat',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: widget._width / this._tableHeaderFontRatio,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                color: Theme.of(context).shadowColor.withOpacity(0.30),
                padding: EdgeInsets.all(globals.tablePadding),
                child: Center(
                  child: Text(
                    'Azan',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget._width / this._tableHeaderFontRatio,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                color: Theme.of(context).shadowColor.withOpacity(0.30),
                padding: EdgeInsets.all(globals.tablePadding),
                child: Center(
                  child: Text(
                    'Iqamat',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget._width / this._tableHeaderFontRatio,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
        for (var loop in [1, 2, 3, 4, 5, 6])
          TableRow(
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  padding: EdgeInsets.all(globals.tablePadding),
                  child: Text(
                    '${this._timerController.solatSchedules[loop]['name']}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget._width /
                              ((this._activeIndex == loop)
                                  ? this._activeFontRatio
                                  : this._inactiveFontRatio),
                          fontWeight: FontWeight.w700,
                          color: (this._activeIndex == loop)
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  padding: EdgeInsets.all(globals.tablePadding),
                  child: Center(
                    child: Text(
                      '${DateFormat('HH:mm').format(this._timerController.solatTimes[loop])}',
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            fontSize: widget._width /
                                ((this._activeIndex == loop)
                                    ? this._activeFontRatio
                                    : this._inactiveFontRatio),
                            fontWeight: FontWeight.w700,
                            color: (this._activeIndex == loop)
                                ? Theme.of(context).primaryColor
                                : null,
                          ),
                    ),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  padding: EdgeInsets.all(globals.tablePadding),
                  child: Center(
                    child: Text(
                      '${DateFormat('HH:mm').format(this._timerController.iqamatTimes[loop])}',
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            fontSize: widget._width /
                                ((this._activeIndex == loop)
                                    ? this._activeFontRatio
                                    : this._inactiveFontRatio),
                            fontWeight: FontWeight.w700,
                            color: (this._activeIndex == loop)
                                ? Theme.of(context).primaryColor
                                : null,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _onScreenStateData(ScreenStateEvent event) {
    this.currentScreenState = event;
    setState(() {
      this._timerController.updateScreenState(event);
    });
  }

  void _startScreenStateListening() {
    try {
      this._subscription =
          this._screen.screenStateStream.listen(_onScreenStateData);
      setState(() => this.screenStateEventStreamStarted = true);
    } on ScreenStateException catch (exception) {}
  }

  void _stopScreenStateListening() {
    _subscription.cancel();
  }
}
