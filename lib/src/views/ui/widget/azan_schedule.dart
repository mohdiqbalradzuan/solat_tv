import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solat_tv/src/business_logic/blocs/solat_timer_blocs.dart';
import 'package:solat_tv/globals.dart' as globals;

class AzanScheduleWidget extends StatefulWidget {
  final double width;

  AzanScheduleWidget(this.width);

  @override
  State<StatefulWidget> createState() => _AzanScheduleWidgetState();
}

class _AzanScheduleWidgetState extends State<AzanScheduleWidget> {
  final timerController = Get.put(SolatTimerBlocs());

  int activeIndex = 0;
  double tableHeaderFontRatio = 18.0;
  double activeFontRatio = 15.0;
  double inactiveFontRatio = 22.0;
  bool showWarning = false;

  @override
  void initState() {
    timerController.startScheduleTimer();
    super.initState();
  }

  @override
  void dispose() {
    timerController.startScheduleTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: timerController.currentTime.stream,
      builder: (context, AsyncSnapshot snapshot) {
        activeIndex = timerController.activeSolatIndex;
        showWarning = timerController.showWarning;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  '${timerController.countdownText}',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: widget.width / 15.0,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                SizedBox(height: 10),
                Opacity(
                  child: Text(
                    'to ${timerController.solatSchedules[activeIndex]['name']}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                      fontSize: widget.width / 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  opacity: !showWarning ? 1.0 : 0.0,
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
                              opacity: showWarning ? 1.0 : 0.0,
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
                                  child: new Image.asset(
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
                              opacity: !showWarning ? 1.0 : 0.0,
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
                        fontSize: widget.width / tableHeaderFontRatio,
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
                          fontSize: widget.width / tableHeaderFontRatio,
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
                          fontSize: widget.width / tableHeaderFontRatio,
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
                    '${timerController.solatSchedules[loop]['name']}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget.width /
                              ((activeIndex == loop)
                                  ? activeFontRatio
                                  : inactiveFontRatio),
                          fontWeight: FontWeight.w700,
                          color: (activeIndex == loop)
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
                      '${DateFormat('HH:mm').format(timerController.solatTimes[loop])}',
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            fontSize: widget.width /
                                ((activeIndex == loop)
                                    ? activeFontRatio
                                    : inactiveFontRatio),
                            fontWeight: FontWeight.w700,
                            color: (activeIndex == loop)
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
                      '${DateFormat('HH:mm').format(timerController.iqamatTimes[loop])}',
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            fontSize: widget.width /
                                ((activeIndex == loop)
                                    ? activeFontRatio
                                    : inactiveFontRatio),
                            fontWeight: FontWeight.w700,
                            color: (activeIndex == loop)
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
}
