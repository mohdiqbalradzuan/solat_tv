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
  double activeFontRatio = 15.0;
  double inactiveFontRatio = 22.0;

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
                  '${timerController.countdownText}',
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
