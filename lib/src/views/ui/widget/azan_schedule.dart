import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solat_tv/src/business_logic/blocs/solat_timer_blocs.dart';
import 'package:solat_tv/src/globals.dart' as globals;

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
  double activeFontRatio = 18.0;
  double inactiveFontRatio = 24.0;

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
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  'Next prayer call: ',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: widget.width / 28,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                SizedBox(height: 20),
                Text(
                  'Countdown',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: widget.width / 10.0,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: _createTable(),
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
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                padding: EdgeInsets.all(globals.tablePadding),
                child: Text(
                  'Subuh',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: widget.width /
                            ((activeIndex == 0)
                                ? activeFontRatio
                                : inactiveFontRatio),
                        fontWeight: FontWeight.w700,
                        color: (activeIndex == 0)
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
                    '${DateFormat('HH:mm').format(timerController.solatTimes[0])}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget.width /
                              ((activeIndex == 0)
                                  ? activeFontRatio
                                  : inactiveFontRatio),
                          fontWeight: FontWeight.w700,
                          color: (activeIndex == 0)
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
                    '${DateFormat('HH:mm').format(timerController.iqamatTimes[0])}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget.width /
                              ((activeIndex == 0)
                                  ? activeFontRatio
                                  : inactiveFontRatio),
                          fontWeight: FontWeight.w700,
                          color: (activeIndex == 0)
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                padding: EdgeInsets.all(globals.tablePadding),
                child: Text(
                  'Syuruk',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: widget.width /
                            ((activeIndex == 1)
                                ? activeFontRatio
                                : inactiveFontRatio),
                        fontWeight: FontWeight.w700,
                        color: (activeIndex == 1)
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
                    '${DateFormat('HH:mm').format(timerController.solatTimes[1])}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget.width /
                              ((activeIndex == 1)
                                  ? activeFontRatio
                                  : inactiveFontRatio),
                          fontWeight: FontWeight.w700,
                          color: (activeIndex == 1)
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
                    '${DateFormat('HH:mm').format(timerController.iqamatTimes[1])}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget.width /
                              ((activeIndex == 1)
                                  ? activeFontRatio
                                  : inactiveFontRatio),
                          fontWeight: FontWeight.w700,
                          color: (activeIndex == 1)
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                padding: EdgeInsets.all(globals.tablePadding),
                child: Text(
                  'Zuhur',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: widget.width /
                            ((activeIndex == 2)
                                ? activeFontRatio
                                : inactiveFontRatio),
                        fontWeight: FontWeight.w700,
                        color: (activeIndex == 2)
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
                    '${DateFormat('HH:mm').format(timerController.solatTimes[2])}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget.width /
                              ((activeIndex == 2)
                                  ? activeFontRatio
                                  : inactiveFontRatio),
                          fontWeight: FontWeight.w700,
                          color: (activeIndex == 2)
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
                    '${DateFormat('HH:mm').format(timerController.iqamatTimes[2])}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget.width /
                              ((activeIndex == 2)
                                  ? activeFontRatio
                                  : inactiveFontRatio),
                          fontWeight: FontWeight.w700,
                          color: (activeIndex == 2)
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                padding: EdgeInsets.all(globals.tablePadding),
                child: Text(
                  'Asar',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: widget.width /
                            ((activeIndex == 3)
                                ? activeFontRatio
                                : inactiveFontRatio),
                        fontWeight: FontWeight.w700,
                        color: (activeIndex == 3)
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
                    '${DateFormat('HH:mm').format(timerController.solatTimes[3])}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget.width /
                              ((activeIndex == 3)
                                  ? activeFontRatio
                                  : inactiveFontRatio),
                          fontWeight: FontWeight.w700,
                          color: (activeIndex == 3)
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
                    '${DateFormat('HH:mm').format(timerController.iqamatTimes[4])}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget.width /
                              ((activeIndex == 3)
                                  ? activeFontRatio
                                  : inactiveFontRatio),
                          fontWeight: FontWeight.w700,
                          color: (activeIndex == 3)
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                padding: EdgeInsets.all(globals.tablePadding),
                child: Text(
                  'Maghrib',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: widget.width /
                            ((activeIndex == 4)
                                ? activeFontRatio
                                : inactiveFontRatio),
                        fontWeight: FontWeight.w700,
                        color: (activeIndex == 4)
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
                    '${DateFormat('HH:mm').format(timerController.solatTimes[5])}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget.width /
                              ((activeIndex == 4)
                                  ? activeFontRatio
                                  : inactiveFontRatio),
                          fontWeight: FontWeight.w700,
                          color: (activeIndex == 4)
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
                    '${DateFormat('HH:mm').format(timerController.iqamatTimes[5])}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget.width /
                              ((activeIndex == 4)
                                  ? activeFontRatio
                                  : inactiveFontRatio),
                          fontWeight: FontWeight.w700,
                          color: (activeIndex == 4)
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                padding: EdgeInsets.all(globals.tablePadding),
                child: Text(
                  'Isyak',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: widget.width /
                            ((activeIndex == 5)
                                ? activeFontRatio
                                : inactiveFontRatio),
                        fontWeight: FontWeight.w700,
                        color: (activeIndex == 5)
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
                    '${DateFormat('HH:mm').format(timerController.solatTimes[6])}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget.width /
                              ((activeIndex == 6)
                                  ? activeFontRatio
                                  : inactiveFontRatio),
                          fontWeight: FontWeight.w700,
                          color: (activeIndex == 6)
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
                    '${DateFormat('HH:mm').format(timerController.iqamatTimes[6])}',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: widget.width /
                              ((activeIndex == 6)
                                  ? activeFontRatio
                                  : inactiveFontRatio),
                          fontWeight: FontWeight.w700,
                          color: (activeIndex == 6)
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
